# interactions/usuarios/actualizarUsuario.feature
# =============================================================================
# Patron Screenplay - Capa: INTERACTIONS
# Responsabilidad UNICA: encapsular PUT /usuarios/{id}
#
# Variables de entrada: urlAccion, cuerpoSolicitud, cabeceras
# Variantes: @exitoso (200), @crudo (sin validacion - para datos invalidos)
# =============================================================================
@interaction @put
Feature: [INTERACTION] Actualizar Usuario - PUT /usuarios/{id}

  @exitoso
  Scenario: [PUT-ACTUALIZAR] Actualizar usuario validando codigo 200
    Given url urlAccion
    And   headers cabeceras
    And   request cuerpoSolicitud
    When  method PUT
    Then  status 200

  @crudo
  Scenario: [PUT-ACTUALIZAR] Actualizar usuario sin validar codigo de respuesta
    Given url urlAccion
    And   headers cabeceras
    And   request cuerpoSolicitud
    When  method PUT