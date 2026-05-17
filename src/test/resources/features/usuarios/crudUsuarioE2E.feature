# features/usuarios/crudUsuarioE2E.feature
# =============================================================================
# Patron Screenplay - Capa de Guiones de Prueba (Test Script Layer)
# Flujo de Integracion End-to-End
#
# Historia de Usuario:
#   Como administrador del sistema,
#   Quiero ejecutar el ciclo de vida completo de un usuario (CRUD),
#   Para verificar la integracion entre todos los endpoints de la API.
#
# Flujo validado: Crear -> Leer -> Actualizar -> Verificar -> Eliminar -> Confirmar
#
# Principio de diseno:
#   Sin HTTP directo - todo ocurre via Interactions, Tasks y Questions.
#   Los pasos son narrativa de negocio pura, sin logica tecnica.
# =============================================================================
@usuarios @e2e @regression
Feature: CRUD Completo de Usuario - Flujo End-to-End

  Background:
    * call read('classpath:hooks/inicializacion.feature')


  # TC-E2E-001
  @smoke @TC-E2E-001
  Scenario: [E2E] Ciclo de vida completo de un usuario administrador

    # PASO 1: Health Check - verificar que el sistema responde correctamente
    * def urlConsulta     = pantalla.urlListaUsuarios
    * def estadoInicial   = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')
    * def cantidadInicial = estadoInicial.response.quantidade
    And  call read('classpath:questions/verificarEsquemaListaUsuarios.feature') { respuestaLista: '#(estadoInicial.response)' }
    * karate.log('[E2E] PASO 1 - Sistema responde. Usuarios registrados:', cantidadInicial)

    # PASO 2: Registrar nuevo usuario administrador (POST /usuarios)
    * def datosDelNuevoUsuario = fabricaDatos.usuarioAdministrador()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosDelNuevoUsuario)' }
    And  match respuestaCreacion.message == mensajes.usuarioCadastrado
    And  match idUsuarioCreado == '#notnull'
    * karate.log('[E2E] PASO 2 - Usuario creado. ID:', idUsuarioCreado)

    # PASO 3: Verificar que el contador de usuarios incremento en uno
    * def estadoTrasCreacion = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')
    And  match estadoTrasCreacion.response.quantidade == cantidadInicial + 1
    * karate.log('[E2E] PASO 3 - Contador incrementado correctamente')

    # PASO 4: Leer el usuario creado y verificar sus datos (GET /usuarios/{id})
    * def urlConsulta      = pantalla.urlBaseUsuarios + '/' + idUsuarioCreado
    * def resultadoLectura = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@exitoso')
    And  call read('classpath:questions/verificarEsquemaUsuario.feature') { respuestaUsuario: '#(resultadoLectura.response)' }
    And  call read('classpath:questions/verificarDatosUsuario.feature') { datosReales: '#(resultadoLectura.response)', datosEsperados: '#(datosDelNuevoUsuario)' }
    * karate.log('[E2E] PASO 4 - Datos del usuario verificados exitosamente')

    # PASO 5: Actualizar el usuario (PUT /usuarios/{id})
    * def nuevosDatosDelUsuario = fabricaDatos.usuarioActualizado()
    * call read('classpath:tasks/usuarios/actualizarDatosUsuario.feature') { idUsuarioAActualizar: '#(idUsuarioCreado)', nuevosDatosDelUsuario: '#(nuevosDatosDelUsuario)' }
    And  match respuestaActualizacion.message == mensajes.usuarioAtualizado
    * karate.log('[E2E] PASO 5 - Usuario actualizado exitosamente')

    # PASO 6: Verificar que los cambios persisten tras la actualizacion
    * def urlConsulta         = pantalla.urlBaseUsuarios + '/' + idUsuarioCreado
    * def resultadoPostUpdate = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@exitoso')
    And  call read('classpath:questions/verificarDatosUsuario.feature') { datosReales: '#(resultadoPostUpdate.response)', datosEsperados: '#(nuevosDatosDelUsuario)' }
    * karate.log('[E2E] PASO 6 - Cambios verificados correctamente')

    # PASO 7: Buscar por email actualizado para confirmar indexado en el sistema
    * def urlConsulta       = pantalla.urlBaseUsuarios + '?email=' + nuevosDatosDelUsuario.email
    * def resultadoBusqueda = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')
    And  match resultadoBusqueda.response.quantidade == 1
    And  match resultadoBusqueda.response.usuarios[0]._id == idUsuarioCreado
    * karate.log('[E2E] PASO 7 - Encontrado por email actualizado')

    # PASO 8: Eliminar el usuario (DELETE /usuarios/{id})
    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@exitoso') { idUsuarioAEliminar: '#(idUsuarioCreado)' }
    And  match respuestaEliminacion.message == mensajes.usuarioDeletado
    * karate.log('[E2E] PASO 8 - Usuario eliminado exitosamente')

    # PASO 9: Confirmar que el usuario ya no existe en el sistema
    * def urlConsulta         = pantalla.urlBaseUsuarios + '/' + idUsuarioCreado
    * def resultadoPostDelete = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@crudo')
    And  match resultadoPostDelete.responseStatus == 400
    And  match resultadoPostDelete.response.message == mensajes.usuarioNaoEncontrado

    # PASO 10: Verificar que el contador volvio exactamente al estado inicial
    * def urlConsulta = pantalla.urlListaUsuarios
    * def estadoFinal = call read('classpath:interactions/usuarios/obtenerListaUsuarios.feature@exitoso')
    And  match estadoFinal.response.quantidade == cantidadInicial
    * karate.log('[E2E] CICLO COMPLETO VERIFICADO EXITOSAMENTE')


  # TC-E2E-002
  @TC-E2E-002
  Scenario: [E2E] Ciclo de vida de usuario regular con promocion a administrador

    # Crear usuario regular (sin rol de administrador)
    * def datosDelUsuarioRegular = fabricaDatos.usuarioRegular()
    * call read('classpath:tasks/usuarios/crearNuevoUsuario.feature') { datosDelNuevoUsuario: '#(datosDelUsuarioRegular)' }
    * def idDelUsuarioRegular = idUsuarioCreado

    # Verificar que fue creado como usuario regular
    * def urlConsulta         = pantalla.urlBaseUsuarios + '/' + idDelUsuarioRegular
    * def resultadoLecturaRol = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@exitoso')
    Then match resultadoLecturaRol.response.administrador == 'false'
    * karate.log('[E2E] Usuario regular creado y verificado')

    # Actualizar elevando su rol a administrador
    * def datosConRolElevado = fabricaDatos.usuarioActualizado()
    * set datosConRolElevado.administrador = 'true'
    * call read('classpath:tasks/usuarios/actualizarDatosUsuario.feature') { idUsuarioAActualizar: '#(idDelUsuarioRegular)', nuevosDatosDelUsuario: '#(datosConRolElevado)' }

    # Verificar que el cambio de rol fue aplicado
    * def resultadoPostElevacion = call read('classpath:interactions/usuarios/obtenerUsuarioPorId.feature@exitoso')
    And  match resultadoPostElevacion.response.administrador == 'true'
    * karate.log('[E2E] Rol elevado a administrador verificado')

    # Eliminar el usuario al final del flujo (teardown)
    * call read('classpath:tasks/usuarios/eliminarUsuarioExistente.feature@exitoso') { idUsuarioAEliminar: '#(idDelUsuarioRegular)' }
    And  match respuestaEliminacion.message == mensajes.usuarioDeletado
    * karate.log('[E2E] Ciclo completado exitosamente')

