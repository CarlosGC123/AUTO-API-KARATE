# features/usuarios/actualizarUsuario.feature
# =============================================================================
# Patron Screenplay - Capa de Guiones de Prueba (Test Script Layer)
#
# Historia de Usuario:
#   Como administrador del sistema,
#   Quiero actualizar la informacion de un usuario existente,
#   Para mantener los datos del sistema actualizados.
#
# Endpoint: PUT /usuarios/{_id}
# =============================================================================
@usuarios @put @regression
Feature: PUT /usuarios/{id} - Actualizar Usuario

  Background:
    * call read('classpath:hooks/inicializacion.feature')
    # Crear usuario base para actualizar en los escenarios
    * def datosUsuarioBase = fabricaDatos.usuarioValido()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosUsuarioBase)' }
    * def idUsuarioBase = idUsuarioCreado


  # TC-PUT-001
  @smoke @TC-PUT-001
  Scenario: [POSITIVO] Actualizar todos los campos de un usuario existente retorna 200

    * def nuevosDatosDelUsuario = fabricaDatos.usuarioActualizado()
    * call read('classpath:tasks/usuarios/actualizarDatosUsuario.feature') { idUsuarioAActualizar: '#(idUsuarioBase)', nuevosDatosDelUsuario: '#(nuevosDatosDelUsuario)' }

    Then match responseStatus == 200
    And  match respuestaActualizacion.message == mensajes.usuarioAtualizado

    # Verificar que los cambios persisten
    * def urlConsulta           = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def resultadoVerificacion = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@exitoso')
    And  call read('classpath:questions/verificarDatosUsuario.feature') { datosReales: '#(resultadoVerificacion.response)', datosEsperados: '#(nuevosDatosDelUsuario)' }

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }


  # TC-PUT-002
  @TC-PUT-002
  Scenario: [POSITIVO] Cambiar rol de administrador a usuario regular se refleja al consultar

    * def nuevosDatosDelUsuario = fabricaDatos.usuarioActualizado()
    * set nuevosDatosDelUsuario.administrador = 'false'
    * call read('classpath:tasks/usuarios/actualizarDatosUsuario.feature') { idUsuarioAActualizar: '#(idUsuarioBase)', nuevosDatosDelUsuario: '#(nuevosDatosDelUsuario)' }

    * def urlConsulta           = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def resultadoVerificacion = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@exitoso')
    Then match resultadoVerificacion.response.administrador == 'false'

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }


  # TC-PUT-003
  @TC-PUT-003
  Scenario: [POSITIVO] PUT con ID inexistente crea el usuario - comportamiento upsert de ServeRest

    * def idQueNoExisteEnElSistema = fabricaDatos.idInexistente()
    * def datosParaUpsert          = fabricaDatos.usuarioValido()

    * def urlAccion       = pantalla.urlBaseUsuarios + '/' + idQueNoExisteEnElSistema
    * def cuerpoSolicitud = datosParaUpsert
    * def resultadoUpsert = call read('classpath:interactions/usuarios/actualizarUsuario.feature@crudo')

    Then match resultadoUpsert.responseStatus == 201
    And  match resultadoUpsert.response.message == mensajes.usuarioCadastrado
    And  match resultadoUpsert.response._id == '#notnull'

    * def idCreadoPorUpsert = resultadoUpsert.response._id
    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idCreadoPorUpsert)' }
    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }


  # TC-PUT-004
  @TC-PUT-004
  Scenario: [NEGATIVO] Actualizar con email ya registrado en otro usuario retorna 400

    * def datosSegundoUsuario = fabricaDatos.usuarioValido()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosSegundoUsuario)' }
    * def idSegundoUsuario = idUsuarioCreado

    * def datosConEmailConflictivo = fabricaDatos.usuarioActualizado()
    * set datosConEmailConflictivo.email = datosSegundoUsuario.email

    * def urlAccion          = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def cuerpoSolicitud    = datosConEmailConflictivo
    * def resultadoConflicto = call read('classpath:interactions/usuarios/actualizarUsuario.feature@crudo')

    Then match resultadoConflicto.responseStatus == 400
    And  match resultadoConflicto.response.message == mensajes.emailJaCadastrado

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }
    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idSegundoUsuario)' }


  # TC-PUT-005
  @TC-PUT-005
  Scenario: [NEGATIVO] Actualizar usuario con nombre vacio retorna 400

    * def datosConNombreVacio = fabricaDatos.usuarioActualizado()
    * set datosConNombreVacio.nome = ''

    * def urlAccion         = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def cuerpoSolicitud   = datosConNombreVacio
    * def resultadoInvalido = call read('classpath:interactions/usuarios/actualizarUsuario.feature@crudo')

    Then match resultadoInvalido.responseStatus == 400
    # ServeRest retorna errores por campo: {"nome":"..."} — no tiene clave "message"
    And  match resultadoInvalido.response == '#notnull'

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }


  # TC-PUT-006
  @TC-PUT-006
  Scenario: [NEGATIVO] Actualizar con email de formato invalido retorna 400

    * def datosConEmailInvalido = fabricaDatos.usuarioActualizado()
    * set datosConEmailInvalido.email = 'formato-invalido-sin-arroba'

    * def urlAccion         = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def cuerpoSolicitud   = datosConEmailInvalido
    * def resultadoInvalido = call read('classpath:interactions/usuarios/actualizarUsuario.feature@crudo')

    Then match resultadoInvalido.responseStatus == 400
    # ServeRest retorna errores por campo: {"email":"..."} — no tiene clave "message"
    And  match resultadoInvalido.response == '#notnull'

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }


  # TC-PUT-007 - Scenario Outline para campos vacios en actualizacion
  @TC-PUT-007
  Scenario Outline: [NEGATIVO] Actualizar con campo <campo> vacio retorna error de validacion

    * def urlAccion         = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def cuerpoSolicitud   = constructorCuerpo.cuerpoDesdeColumnas('<nombre>', '<email>', '<password>', '<administrador>')
    * def resultadoInvalido = call read('classpath:interactions/usuarios/actualizarUsuario.feature@crudo')

    Then match resultadoInvalido.responseStatus == 400
    # ServeRest retorna errores por campo — no tiene clave "message"
    And  match resultadoInvalido.response == '#notnull'

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }

    Examples:
      | campo    | nombre            | email                      | password | administrador |
      | nombre   |                   | actualizar_nombre@test.com | Pass@123 | true          |
      | password | Sin Contrasena    | actualizar_pass@test.com   |          | true          |