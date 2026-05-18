# tasks/usuarios/actualizarDatosUsuario.feature
# =============================================================================
# Patron Screenplay - Capa: TASKS
# Responsabilidad: orquestar la actualizacion de datos de un usuario existente.
#
# Variables de entrada: idUsuarioAActualizar, nuevosDatosDelUsuario
# Variables expuestas: respuestaActualizacion
# =============================================================================
@task
Feature: [TASK] Actualizar Datos de un Usuario Existente

  Scenario: Enviar nuevos datos al usuario indicado

    # Preparar URL con el ID del recurso a actualizar
    * def urlAccion       = pantalla.urlBaseUsuarios + '/' + idUsuarioAActualizar
    * def cuerpoSolicitud = nuevosDatosDelUsuario

    # Ejecutar interaction atomica PUT /usuarios/{id}
    * call read('classpath:interactions/usuarios/actualizarUsuario.feature@exitoso')

    # Exponer resultado al contexto llamador
    * def respuestaActualizacion = response

    * karate.log('[TASK] Usuario actualizado. ID:', idUsuarioAActualizar)