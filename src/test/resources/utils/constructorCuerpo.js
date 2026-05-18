/**
 * utils/constructorCuerpo.js
 * =============================================================================
 * Patron Screenplay - Capa: UTILS
 *
 * Responsabilidad: construir cuerpos de solicitud HTTP (request bodies).
 * Centraliza la estructura de los payloads, eliminando la duplicacion de
 * literales JSON en los features de prueba.
 *
 * SRP - solo construye objetos de solicitud, delega generacion a fabricaDatos.js
 * ISP - metodos granulares y nombrados por caso de uso especifico.
 * =============================================================================
 */
function fn() {

    // Cuerpo vacio — para casos negativos de body ausente o vacio
    var cuerpoVacio = function() {
        return {};
    };

    // Constructor desde columnas de Scenario Outline
    var cuerpoDesdeColumnas = function(nombre, email, password, administrador) {
        return {
            nome:          nombre,
            email:         email,
            password:      password,
            administrador: administrador
        };
    };

    // ── API publica ───────────────────────────────────────────────────────────
    return {
        cuerpoVacio:         cuerpoVacio,
        cuerpoDesdeColumnas: cuerpoDesdeColumnas
    };
}