# interactions/usuarios/registrarUsuario.feature
# =============================================================================
# Patron Screenplay - Capa: INTERACTIONS
# Responsabilidad UNICA: encapsular POST /usuarios
#
# Variables de entrada: urlAccion, cuerpoSolicitud, cabeceras
# Variantes: @exitoso (201), @crudo (sin validacion - para datos invalidos)
# =============================================================================
@interaction @post
Feature: [INTERACTION] Registrar Nuevo Usuario - POST /usuarios

  @exitoso
  Scenario: [POST-REGISTRAR] Registrar usuario validando codigo 201
    Given url urlAccion
    And   headers cabeceras
    And   request cuerpoSolicitud
    When  method POST
    Then  status 201

  @crudo
  Scenario: [POST-REGISTRAR] Registrar usuario sin validar codigo de respuesta
    Given url urlAccion
    And   headers cabeceras
    And   request cuerpoSolicitud
    When  method POST