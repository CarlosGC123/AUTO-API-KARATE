# interactions/usuarios/obtenerListaUsuarios.feature
# =============================================================================
# Patron Screenplay - Capa de Logica de Negocio (Business Logic Layer)
# Capa: INTERACTIONS
#
# Responsabilidad UNICA (SRP): encapsular la llamada HTTP GET al endpoint
# de lista de usuarios. Accion ATOMICA - solo realiza el GET y retorna la
# respuesta sin logica de negocio adicional.
#
# Variables de entrada (del contexto del llamador):
#   urlConsulta : URL completa con o sin query params (construida por pantalla)
#   cabeceras   : cabeceras HTTP comunes (disponibles via hooks)
#
# Variantes:
#   @exitoso : valida codigo 200 (Happy Path)
#   @crudo   : sin validacion de codigo (flujos negativos)
#
# Equivalencia Screenplay: "Interaction" - accion atomica reutilizable.
# =============================================================================
@interaction @get
Feature: [INTERACTION] Obtener Lista de Usuarios - GET /usuarios

  @exitoso
  Scenario: [GET-LISTA] Obtener lista de usuarios validando codigo 200
    Given url urlConsulta
    And   headers cabeceras
    When  method GET
    Then  status 200

  @crudo
  Scenario: [GET-LISTA] Obtener lista de usuarios sin validar codigo de respuesta
    Given url urlConsulta
    And   headers cabeceras
    When  method GET