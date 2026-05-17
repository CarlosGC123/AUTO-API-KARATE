# interactions/usuarios/obtenerUsuarioPorId.feature
# =============================================================================
# Patron Screenplay - Capa: INTERACTIONS
# Responsabilidad UNICA: encapsular GET /usuarios/{id}
#
# Variables de entrada: urlConsulta, cabeceras
# Variantes: @exitoso (200), @crudo (sin validacion)
# =============================================================================
@interaction @get
Feature: [INTERACTION] Obtener Usuario por ID - GET /usuarios/{id}

  @exitoso
  Scenario: [GET-POR-ID] Obtener usuario existente validando codigo 200
    Given url urlConsulta
    And   headers cabeceras
    When  method GET
    Then  status 200

  @crudo
  Scenario: [GET-POR-ID] Obtener usuario por ID sin validar codigo de respuesta
    Given url urlConsulta
    And   headers cabeceras
    When  method GET