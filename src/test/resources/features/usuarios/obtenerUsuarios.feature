# features/usuarios/obtenerUsuarios.feature
# =============================================================================
# Patron Screenplay - Capa de Guiones de Prueba (Test Script Layer)
#
# Historia de Usuario:
#   Como administrador del sistema,
#   Quiero obtener la lista de todos los usuarios registrados,
#   Para tener visibilidad completa de la base de usuarios.
#
# Endpoint: GET /usuarios
#
# REGLA DE LA CAPA: ningun escenario contiene llamadas HTTP directas.
# Todo ocurre exclusivamente a traves de Interactions, Tasks y Questions.
# =============================================================================
@usuarios @get @regression
Feature: GET /usuarios - Obtener Lista de Usuarios

  Background:
    # Una sola linea carga todos los recursos compartidos del framework
    * call read('classpath:hooks/inicializacion.feature')


  # TC-GET-001
  @smoke @TC-GET-001
  Scenario: [POSITIVO] Obtener la lista completa retorna 200 y cumple el esquema de contrato

    * def urlConsulta    = pantalla.urlListaUsuarios
    * def resultadoLista = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')

    Then match resultadoLista.responseStatus == 200
    And  call read('classpath:questions/verificarEsquemaListaUsuarios.feature') { respuestaLista: '#(resultadoLista.response)' }


  # TC-GET-002
  @TC-GET-002
  Scenario: [POSITIVO] La cantidad declarada coincide con el tamano del arreglo de usuarios

    * def urlConsulta       = pantalla.urlListaUsuarios
    * def resultadoLista    = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')
    * def cantidadDeclarada = resultadoLista.response.quantidade
    * def tamanoArreglo     = resultadoLista.response.usuarios.length

    Then match cantidadDeclarada == tamanoArreglo


  # TC-GET-003
  @TC-GET-003
  Scenario: [POSITIVO] Cada usuario en la lista posee todos los campos requeridos

    * def urlConsulta     = pantalla.urlListaUsuarios
    * def resultadoLista  = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')
    * def listaDeUsuarios = resultadoLista.response.usuarios

    Then match each listaDeUsuarios == esquemaUsuario


  # TC-GET-004
  @TC-GET-004
  Scenario: [POSITIVO] Filtrar usuarios por nombre retorna solo los que coinciden

    * def datosDelNuevoUsuario = fabricaDatos.usuarioValido()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosDelNuevoUsuario)' }

    * def urlConsulta     = pantalla.urlBaseUsuarios + '?nome=' + datosDelNuevoUsuario.nome
    * def resultadoFiltro = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')

    Then match resultadoFiltro.responseStatus == 200
    # 'match >= N' no es valido en Karate DSL — usar assert para comparaciones numericas
    * assert resultadoFiltro.response.quantidade >= 1
    And  match resultadoFiltro.response.usuarios[0].nome == datosDelNuevoUsuario.nome

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioCreado)' }


  # TC-GET-005
  @TC-GET-005
  Scenario: [POSITIVO] Filtrar por email unico devuelve exactamente un resultado

    * def datosDelNuevoUsuario = fabricaDatos.usuarioValido()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosDelNuevoUsuario)' }

    * def urlConsulta     = pantalla.urlBaseUsuarios + '?email=' + datosDelNuevoUsuario.email
    * def resultadoFiltro = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')

    Then match resultadoFiltro.responseStatus == 200
    And  match resultadoFiltro.response.quantidade == 1
    And  match resultadoFiltro.response.usuarios[0].email == datosDelNuevoUsuario.email

    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@limpieza') { idUsuarioAEliminar: '#(idUsuarioCreado)' }


  # TC-GET-006
  @TC-GET-006
  Scenario: [POSITIVO] Buscar por email inexistente retorna cantidad cero y arreglo vacio

    * def emailInexistente = 'noexiste_' + fabricaDatos.generarMarcaDeTiempo() + '@ningundominioreal.com'
    * def urlConsulta      = pantalla.urlBaseUsuarios + '?email=' + emailInexistente
    * def resultadoFiltro  = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')

    Then match resultadoFiltro.responseStatus == 200
    And  match resultadoFiltro.response.quantidade == 0
    And  match resultadoFiltro.response.usuarios   == []


  # TC-GET-007
  @TC-GET-007
  Scenario: [POSITIVO] La respuesta incluye el header Content-Type application/json
    # Llamada directa para acceder a responseHeaders dentro del escenario (no via call)
    Given url pantalla.urlListaUsuarios
    And   headers cabeceras
    When  method GET
    Then  status 200
    # Karate normaliza los nombres de headers a minusculas en responseHeaders
    And   match responseHeaders['content-type'][0] contains 'application/json'
