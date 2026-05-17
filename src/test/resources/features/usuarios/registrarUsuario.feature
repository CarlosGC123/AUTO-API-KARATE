# features/usuarios/registrarUsuario.feature
# =============================================================================
# Patron Screenplay - Capa de Guiones de Prueba (Test Script Layer)
#
# Historia de Usuario:
#   Como administrador del sistema,
#   Quiero registrar nuevos usuarios con datos validos,
#   Para ampliar la base de datos de usuarios del sistema.
#
# Endpoint: POST /usuarios
# =============================================================================
@usuarios @post @regression
Feature: POST /usuarios - Registrar Nuevo Usuario

  Background:
    * call read('classpath:hooks/inicializacion.feature')


  # TC-POST-001
  @smoke @TC-POST-001
  Scenario: [POSITIVO] Registrar usuario administrador con datos validos retorna 201 y ID

    * def datosDelNuevoUsuario = fabricaDatos.usuarioAdministrador()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosDelNuevoUsuario)' }

    Then match responseStatus == 201
    And  match respuestaCreacion._id == '#notnull'
    And  call read('classpath:questions/verificarRespuestaConMensaje.feature') { cuerpoRespuesta: '#(respuestaCreacion)', mensajeEsperado: '#(mensajes.usuarioCadastrado)', esquemaMensaje: '#(esquemaCrearUsuario)' }

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioCreado)' }


  # TC-POST-002
  @TC-POST-002
  Scenario: [POSITIVO] Registrar usuario no administrador retorna 201 con mensaje de confirmacion

    * def datosDelNuevoUsuario = fabricaDatos.usuarioRegular()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosDelNuevoUsuario)' }

    Then match responseStatus == 201
    And  match respuestaCreacion.message == mensajes.usuarioCadastrado

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioCreado)' }


  # TC-POST-003
  @TC-POST-003
  Scenario: [POSITIVO] El ID retornado es accesible como recurso independiente via GET

    * def datosDelNuevoUsuario = fabricaDatos.usuarioValido()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosDelNuevoUsuario)' }

    * def urlConsulta       = pantalla.urlBaseUsuarios + '/' + idUsuarioCreado
    * def resultadoConsulta = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@exitoso')

    Then match resultadoConsulta.responseStatus == 200
    And  match resultadoConsulta.response._id   == idUsuarioCreado
    And  match resultadoConsulta.response.email == datosDelNuevoUsuario.email

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioCreado)' }


  # TC-POST-004
  @TC-POST-004
  Scenario: [NEGATIVO] Registrar usuario con email duplicado retorna 400

    * def datosUsuarioBase = fabricaDatos.usuarioValido()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosUsuarioBase)' }
    * def idPrimerUsuario = idUsuarioCreado

    * def urlAccion           = pantalla.urlRegistrarUsuario
    * def cuerpoSolicitud     = datosUsuarioBase
    * def resultadoDuplicado  = call read('classpath:interactions/usuarios/registrarUsuario.feature@crudo')

    Then match resultadoDuplicado.responseStatus == 400
    And  match resultadoDuplicado.response.message == mensajes.emailJaCadastrado

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idPrimerUsuario)' }


  # TC-POST-005
  @TC-POST-005
  Scenario: [NEGATIVO] Registrar usuario con email invalido retorna 400

    * def urlAccion         = pantalla.urlRegistrarUsuario
    * def cuerpoSolicitud   = fabricaDatos.usuariosInvalidos.emailConFormatoInvalido
    * def resultadoInvalido = call read('classpath:interactions/usuarios/registrarUsuario.feature@crudo')

    Then match resultadoInvalido.responseStatus == 400
    # ServeRest retorna errores por campo: {"email":"..."} — no tiene clave "message"
    And  match resultadoInvalido.response == '#notnull'


  # TC-POST-006
  @TC-POST-006
  Scenario: [NEGATIVO] Registrar usuario con nombre vacio retorna 400

    * def urlAccion            = pantalla.urlRegistrarUsuario
    * def cuerpoSolicitud      = fabricaDatos.usuariosInvalidos.nombreVacio
    * def resultadoNombreVacio = call read('classpath:interactions/usuarios/registrarUsuario.feature@crudo')

    Then match resultadoNombreVacio.responseStatus == 400
    # ServeRest retorna errores por campo: {"nome":"..."} — no tiene clave "message"
    And  match resultadoNombreVacio.response == '#notnull'


  # TC-POST-007
  @TC-POST-007
  Scenario: [NEGATIVO] Registrar usuario con password vacio retorna 400

    * def urlAccion               = pantalla.urlRegistrarUsuario
    * def cuerpoSolicitud         = fabricaDatos.usuariosInvalidos.passwordVacio
    * def resultadoPasswordVacio  = call read('classpath:interactions/usuarios/registrarUsuario.feature@crudo')

    Then match resultadoPasswordVacio.responseStatus == 400
    # ServeRest retorna errores por campo: {"password":"..."} — no tiene clave "message"
    And  match resultadoPasswordVacio.response == '#notnull'


  # TC-POST-008
  @TC-POST-008
  Scenario: [NEGATIVO] Registrar usuario con email vacio retorna 400

    * def urlAccion           = pantalla.urlRegistrarUsuario
    * def cuerpoSolicitud     = fabricaDatos.usuariosInvalidos.emailVacio
    * def resultadoEmailVacio = call read('classpath:interactions/usuarios/registrarUsuario.feature@crudo')

    Then match resultadoEmailVacio.responseStatus == 400
    # ServeRest retorna errores por campo: {"email":"..."} — no tiene clave "message"
    And  match resultadoEmailVacio.response == '#notnull'


  # TC-POST-009 - Scenario Outline para multiples campos vacios
  @TC-POST-009
  Scenario Outline: [NEGATIVO] Registrar usuario con campo <campo> vacio retorna error de validacion

    * def urlAccion         = pantalla.urlRegistrarUsuario
    * def cuerpoSolicitud   = constructorCuerpo.cuerpoDesdeColumnas('<nombre>', '<email>', '<password>', '<administrador>')
    * def resultadoInvalido = call read('classpath:interactions/usuarios/registrarUsuario.feature@crudo')

    Then match resultadoInvalido.responseStatus == 400
    # ServeRest retorna errores por campo: {"nome":"..."} — no tiene clave "message"
    And  match resultadoInvalido.response == '#notnull'

    Examples:
      | campo    | nombre            | email                   | password | administrador |
      | nombre   |                   | vacio_nombre@prueba.com | Pass@123 | true          |
      | email    | Sin Email         |                         | Pass@123 | true          |
      | password | Sin Contrasena    | vacio_pass@prueba.com   |          | true          |


  # TC-POST-010
  @TC-POST-010
  Scenario: [NEGATIVO] Registrar usuario con body vacio retorna 400

    * def urlAccion            = pantalla.urlRegistrarUsuario
    * def cuerpoSolicitud      = constructorCuerpo.cuerpoVacio()
    * def resultadoCuerpoVacio = call read('classpath:interactions/usuarios/registrarUsuario.feature@crudo')

    Then match resultadoCuerpoVacio.responseStatus == 400
    # ServeRest retorna multiples errores de campo, no un "message" unico
    And  match resultadoCuerpoVacio.response == '#notnull'
