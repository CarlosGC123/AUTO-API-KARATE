# questions/verificarEsquemaListaUsuarios.feature
# =============================================================================
# Patron Screenplay - Capa de Logica de Negocio (Business Logic Layer)
# Capa: QUESTIONS (PLANA - sin subdirectorios de modulo)
#
# Responsabilidad: verificar que una respuesta de lista de usuarios cumple
# el contrato de la API (JSON Schema) y las restricciones estructurales
# requeridas por el negocio.
#
# Principio DRY: esta asercion se define una vez; multiples pruebas la reutilizan.
#
# Variables de entrada: respuestaLista, esquemaListaUsuarios
#
# Equivalencia Screenplay: "Question" - verifica el estado del sistema.
# =============================================================================
@question
Feature: [QUESTION] Verificar Esquema de Lista de Usuarios

  Scenario: La respuesta cumple el contrato de lista de usuarios de la API

    # Validar estructura completa contra el esquema JSON de contrato
    Then match respuestaLista == esquemaListaUsuarios

    # Verificar campos estructurales obligatorios
    And  match respuestaLista.quantidade == '#number'
    And  match respuestaLista.usuarios   == '#array'