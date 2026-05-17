# features/usuarios/obtenerUsuarioPorId.feature
# =============================================================================
# Patron Screenplay - Capa de Guiones de Prueba (Test Script Layer)
#
# Historia de Usuario:
#   Como administrador del sistema,
#   Quiero buscar un usuario especifico por su ID,
#   Para consultar o verificar sus datos individualmente.
#
# Endpoint: GET /usuarios/{_id}
# =============================================================================
@usuarios @get @regression
Feature: GET /usuarios/{id} - Buscar Usuario por ID

  Background:
    * call read('classpath:hooks/inicializacion.feature')
    # Crear usuario base para reutilizar en los escenarios positivos
    * def datosUsuarioBase = fabricaDatos.usuarioValido()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosUsuarioBase)' }
    * def idUsuarioBase = idUsuarioCreado


  # TC-GETID-001
  @smoke @TC-GETID-001
  Scenario: [POSITIVO] Buscar usuario existente retorna 200 y cumple el esquema

    * def urlConsulta       = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def resultadoConsulta = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@exitoso')

    Then match resultadoConsulta.responseStatus == 200
    And  call read('classpath:questions/verificarEsquemaUsuario.feature') { respuestaUsuario: '#(resultadoConsulta.response)' }
    And  match resultadoConsulta.response._id == idUsuarioBase

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }


  # TC-GETID-002
  @TC-GETID-002
  Scenario: [POSITIVO] El campo administrador retorna el valor asignado en el registro

    * def urlConsulta       = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def resultadoConsulta = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@exitoso')

    Then match resultadoConsulta.response.administrador == datosUsuarioBase.administrador

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }


  # TC-GETID-003
  @TC-GETID-003
  Scenario: [POSITIVO] Los datos retornados coinciden exactamente con los registrados

    * def urlConsulta       = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def resultadoConsulta = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@exitoso')

    Then call read('classpath:questions/verificarDatosUsuario.feature') { datosReales: '#(resultadoConsulta.response)', datosEsperados: '#(datosUsuarioBase)' }

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }


  # TC-GETID-004
  @TC-GETID-004
  Scenario: [NEGATIVO] Buscar usuario con ID inexistente retorna 400

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }

    # ID de 24 chars hex valido pero inexistente
    * def idQueNoExisteEnElSistema = 'aaaaaaaaaaaaaaaaaaaaaaaa'
    * def urlConsulta              = pantalla.urlBaseUsuarios + '/' + idQueNoExisteEnElSistema
    * def resultadoConsulta        = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@crudo')

    # ServeRest retorna 400 para IDs no encontrados; el cuerpo varia segun la implementacion
    Then match resultadoConsulta.responseStatus == 400
    And  match resultadoConsulta.response == '#notnull'


  # TC-GETID-005
  @TC-GETID-005
  Scenario: [NEGATIVO] Buscar usuario con ID de formato invalido retorna 400

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }

    * def urlConsulta       = pantalla.urlBaseUsuarios + '/formato-invalido!!!'
    * def resultadoConsulta = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@crudo')

    Then match resultadoConsulta.responseStatus == 400
    And  match resultadoConsulta.response == '#notnull'


  # TC-GETID-006
  @TC-GETID-006
  Scenario: [NEGATIVO] Buscar usuario ya eliminado retorna 400 con usuario no encontrado

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@exitoso') { idUsuarioAEliminar: '#(idUsuarioBase)' }

    * def urlConsulta       = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def resultadoConsulta = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@crudo')

    Then match resultadoConsulta.responseStatus == 400
    And  match resultadoConsulta.response.message == mensajes.usuarioNaoEncontrado