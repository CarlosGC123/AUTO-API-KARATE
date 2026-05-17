# interactions/usuarios/eliminarUsuario.feature
# =============================================================================
# Patron Screenplay - Capa: INTERACTIONS
# Responsabilidad UNICA: encapsular DELETE /usuarios/{id}
#
# Variables de entrada: urlAccion, cabeceras
# Variantes: @exitoso (200), @crudo (sin validacion - para IDs inexistentes)
# =============================================================================
@interaction @delete
Feature: [INTERACTION] Eliminar Usuario - DELETE /usuarios/{id}

  @exitoso
  Scenario: [DELETE-ELIMINAR] Eliminar usuario validando codigo 200
    Given url urlAccion
    And   headers cabeceras
    When  method DELETE
    Then  status 200

  @crudo
  Scenario: [DELETE-ELIMINAR] Eliminar usuario sin validar codigo de respuesta
    Given url urlAccion
    And   headers cabeceras
    When  method DELETE