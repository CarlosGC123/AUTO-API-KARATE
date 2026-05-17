# questions/verificarDatosUsuario.feature
# =============================================================================
# Patron Screenplay - Capa: QUESTIONS (PLANA)
# Responsabilidad: verificar que los datos de un usuario recuperado de la API
# coinciden exactamente con los datos que se registraron o actualizaron.
#
# Variables de entrada: datosReales (respuesta API), datosEsperados (del test)
# =============================================================================
@question
Feature: [QUESTION] Verificar Datos del Usuario Coinciden con los Esperados

  Scenario: Los campos del usuario recuperado son iguales a los registrados

    Then match datosReales.nome          == datosEsperados.nome
    And  match datosReales.email         == datosEsperados.email
    And  match datosReales.administrador == datosEsperados.administrador