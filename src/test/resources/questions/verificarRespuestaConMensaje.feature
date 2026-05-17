# questions/verificarRespuestaConMensaje.feature
# =============================================================================
# Patron Screenplay - Capa: QUESTIONS (PLANA)
# Responsabilidad: verificar que una respuesta operacional contiene el schema
# de mensaje correcto Y el texto de mensaje exacto esperado por el negocio.
#
# Variables de entrada: cuerpoRespuesta, mensajeEsperado, esquemaMensaje
# =============================================================================
@question
Feature: [QUESTION] Verificar Respuesta Operacional con Mensaje

  Scenario: La respuesta contiene el mensaje esperado y cumple su esquema

    # Verificar cumplimiento del esquema de mensaje
    Then match cuerpoRespuesta == esquemaMensaje

    # Verificar que el mensaje coincide exactamente con el esperado
    And  match cuerpoRespuesta.message == mensajeEsperado