# tasks/usuarios/eliminarUsuarioExistente.feature
# =============================================================================
# Patron Screenplay - Capa: TASKS
# Responsabilidad: eliminar un usuario del sistema.
#
# La variante @limpieza no falla si el recurso ya fue eliminado, lo que la
# hace segura para usarse como teardown al final de cada escenario.
#
# Variables de entrada: idUsuarioAEliminar
# Variables expuestas: respuestaEliminacion
# =============================================================================
@task
Feature: [TASK] Eliminar Usuario del Sistema

  # Variante exitosa: valida codigo 200
  @exitoso
  Scenario: Eliminar usuario existente confirmando eliminacion

    * def urlAccion = pantalla.urlBaseUsuarios + '/' + idUsuarioAEliminar

    * call read('classpath:interactions/usuarios/eliminarUsuario.feature@exitoso')

    * def respuestaEliminacion = response
    * karate.log('[TASK] Usuario eliminado. ID:', idUsuarioAEliminar)


  # Variante de limpieza/teardown: no falla si el recurso ya fue eliminado
  @limpieza
  Scenario: Eliminar usuario tolerando que no exista (teardown seguro)

    * def urlAccion = pantalla.urlBaseUsuarios + '/' + idUsuarioAEliminar

    * call read('classpath:interactions/usuarios/eliminarUsuario.feature@crudo')

    * karate.log('[TASK-LIMPIEZA] Limpieza ejecutada para ID:', idUsuarioAEliminar)