/**
 * utils/constructorCuerpo.js
 * =============================================================================
 * Patron Screenplay - Capa de Librerias Base (Base Library Layer)
 * Capa: UTILS
 *
 * Responsabilidad: construir cuerpos de solicitud HTTP (request bodies)
 * para escenarios especificos. Centraliza la estructura de los payloads,
 * eliminando la duplicacion de literales JSON en los features de prueba.
 *
 * Principios SOLID:
 *   SRP - solo construye objetos de solicitud, delega generacion a fabricaDatos.js
 *   ISP - metodos granulares y nombrados por caso de uso especifico.
 *
 * Equivalencia Screenplay: "Builder" dentro de la capa de Utilidades.
 * =============================================================================
 */
function fn() {

    // Cuerpo de solicitud vacio - para casos negativos de body ausente o vacio
    var cuerpoVacio = function() {
        return {};
    };

    // Constructor desde columnas de Scenario Outline
    // Permite construir el body directamente desde parametros de tabla Examples.
    var cuerpoDesdeColumnas = function(nombre, email, password, administrador) {
        return {
            nome:          nombre,
            email:         email,
            password:      password,
            administrador: administrador
        };
    };

    // Constructor con un campo sobreescrito sobre un objeto base
    // Util para crear variantes invalidas de un usuario valido.
    var cuerpoConCampoModificado = function(baseDelUsuario, nombreCampo, nuevoValor) {
        var cuerpoModificado = {
            nome:          baseDelUsuario.nome,
            email:         baseDelUsuario.email,
            password:      baseDelUsuario.password,
            administrador: baseDelUsuario.administrador
        };
        cuerpoModificado[nombreCampo] = nuevoValor;
        return cuerpoModificado;
    };

    // â”€â”€ API publica del constructor â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    return {
        cuerpoVacio:              cuerpoVacio,
        cuerpoDesdeColumnas:      cuerpoDesdeColumnas,
        cuerpoConCampoModificado: cuerpoConCampoModificado
    };
}