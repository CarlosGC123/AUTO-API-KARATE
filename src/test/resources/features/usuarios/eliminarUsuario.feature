# features/usuarios/eliminarUsuario.feature
# =============================================================================
# Patron Screenplay - Capa de Guiones de Prueba (Test Script Layer)
#
# Historia de Usuario:
#   Como administrador del sistema,
#   Quiero eliminar un usuario del sistema,
#   Para mantener la base de datos limpia y actualizada.
#
# Endpoint: DELETE /usuarios/{_id}
# =============================================================================
@usuarios @delete @regression
Feature: DELETE /usuarios/{id} - Eliminar Usuario

  Background:
    * call read('classpath:hooks/inicializacion.feature')
    # Crear usuario base para eliminar en los escenarios
    * def datosUsuarioBase = fabricaDatos.usuarioValido()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosUsuarioBase)' }
    * def idUsuarioBase = idUsuarioCreado


  # TC-DEL-001
  @smoke @TC-DEL-001
  Scenario: [POSITIVO] Eliminar usuario existente retorna 200 con mensaje de confirmacion

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@exitoso') { idUsuarioAEliminar: '#(idUsuarioBase)' }

    Then match responseStatus == 200
    And  call read('classpath:questions/verificarRespuestaConMensaje.feature') { cuerpoRespuesta: '#(respuestaEliminacion)', mensajeEsperado: '#(mensajes.usuarioDeletado)', esquemaMensaje: '#(esquemaMensaje)' }


  # TC-DEL-002
  @TC-DEL-002
  Scenario: [POSITIVO] Usuario eliminado ya no es accesible por ID

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@exitoso') { idUsuarioAEliminar: '#(idUsuarioBase)' }

    * def urlConsulta       = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def resultadoConsulta = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@crudo')

    Then match resultadoConsulta.responseStatus == 400
    And  match resultadoConsulta.response.message == mensajes.usuarioNaoEncontrado


  # TC-DEL-003
  @TC-DEL-003
  Scenario: [POSITIVO] La cantidad total de usuarios disminuye tras una eliminacion

    * def urlConsulta    = pantalla.urlListaUsuarios
    * def resultadoAntes = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')
    * def cantidadAntes  = resultadoAntes.response.quantidade

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@exitoso') { idUsuarioAEliminar: '#(idUsuarioBase)' }

    * def resultadoDespues = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')
    Then match resultadoDespues.response.quantidade == cantidadAntes - 1


  # TC-DEL-004
  @TC-DEL-004
  Scenario: [NEGATIVO] Eliminar ID inexistente retorna 200 con cero registros excluidos

    * def idQueNoExisteEnElSistema = fabricaDatos.idInexistente()
    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }

    * def urlAccion              = pantalla.urlBaseUsuarios + '/' + idQueNoExisteEnElSistema
    * def resultadoIdInexistente = call read('classpath:interactions/usuarios/eliminarUsuario.feature@crudo')

    Then match resultadoIdInexistente.responseStatus == 200
    And  match resultadoIdInexistente.response.message == mensajes.nenhumRegistroExcluido


  # TC-DEL-005
  @TC-DEL-005
  Scenario: [NEGATIVO] Eliminar dos veces el mismo usuario retorna ningun registro excluido

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@exitoso') { idUsuarioAEliminar: '#(idUsuarioBase)' }

    * def urlAccion           = pantalla.urlBaseUsuarios + '/' + idUsuarioBase
    * def resultadoSegundaVez = call read('classpath:interactions/usuarios/eliminarUsuario.feature@crudo')

    Then match resultadoSegundaVez.responseStatus == 200
    And  match resultadoSegundaVez.response.message == mensajes.nenhumRegistroExcluido


  # TC-DEL-006
  @TC-DEL-006
  Scenario: [NEGATIVO] Eliminar usuario con ID de formato invalido retorna comportamiento no-eliminado

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }

    * def urlAccion                = pantalla.urlBaseUsuarios + '/id-formato-invalido'
    * def resultadoFormatoInvalido = call read('classpath:interactions/usuarios/eliminarUsuario.feature@crudo')

    # ServeRest con Mongoose interpreta formatos no-ObjectId como "no encontrado" -> 200
    Then match resultadoFormatoInvalido.responseStatus == 200
    And  match resultadoFormatoInvalido.response.message == mensajes.nenhumRegistroExcluido


  # TC-DEL-007
  @TC-DEL-007
  Scenario: [POSITIVO] Ciclo completo: crear y eliminar multiples usuarios en secuencia

    * def datosUsuarioUno  = fabricaDatos.usuarioValido()
    * def datosUsuarioDos  = fabricaDatos.usuarioValido()
    * def datosUsuarioTres = fabricaDatos.usuarioValido()

    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosUsuarioUno)' }
    * def idUsuarioUno = idUsuarioCreado

    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosUsuarioDos)' }
    * def idUsuarioDos = idUsuarioCreado

    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosUsuarioTres)' }
    * def idUsuarioTres = idUsuarioCreado

    Then match responseStatus == 201

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@exitoso') { idUsuarioAEliminar: '#(idUsuarioUno)' }
    * def mensajeUno = respuestaEliminacion.message
    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@exitoso') { idUsuarioAEliminar: '#(idUsuarioDos)' }
    * def mensajeDos = respuestaEliminacion.message
    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@exitoso') { idUsuarioAEliminar: '#(idUsuarioTres)' }
    * def mensajeTres = respuestaEliminacion.message

    And  match mensajeUno  == mensajes.usuarioDeletado
    And  match mensajeDos  == mensajes.usuarioDeletado
    And  match mensajeTres == mensajes.usuarioDeletado

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioBase)' }