# questions/verificarEsquemaUsuario.feature
# =============================================================================
# Patron Screenplay - Capa: QUESTIONS (PLANA)
# Responsabilidad: verificar que un objeto de usuario cumple el contrato de
# la API con todos sus campos requeridos y sus tipos correctos.
#
# Variables de entrada: respuestaUsuario, esquemaUsuario
# =============================================================================
@question
Feature: [QUESTION] Verificar Esquema de Usuario Individual

  Scenario: El objeto de usuario cumple el contrato de la API

    # Validar estructura completa contra el esquema JSON
    Then match respuestaUsuario == esquemaUsuario

    # Verificar presencia y tipo de cada campo requerido
    And  match respuestaUsuario._id           == '#notnull'
    And  match respuestaUsuario.nome          == '#string'
    And  match respuestaUsuario.email         == '#string'
    And  match respuestaUsuario.password      == '#string'
    And  match respuestaUsuario.administrador == '#string'