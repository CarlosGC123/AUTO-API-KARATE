/**
 * karate-config.js
 * =============================================================================
 * EQUIVALENTE A serenity.conf / serenity.properties EN SERENITY BDD
 * =============================================================================
 * Este archivo ES la configuracion central del framework Karate DSL.
 * Cumple el mismo rol que serenity.conf en Serenity BDD:
 *
 *   serenity.conf (Serenity)            karate-config.js (Karate)
 *   ──────────────────────────────────────────────────────────────
 *   webdriver.base.url = http://...  -> baseUrl: 'https://...'
 *   environments { dev { ... } }     -> mapaDeEntornos: { dev: {...} }
 *   serenity.timeout = 5000          -> connectTimeout / readTimeout
 *
 * ACTIVACION DE ENTORNO (equivalente a -Denvironment=staging en Serenity):
 *   mvn test -P dev             → usa entorno 'dev'  (por defecto)
 *   mvn test -P staging         → usa entorno 'staging'
 *   mvn test -P prod            → usa entorno 'prod'
 *   mvn test -Dkarate.env=staging  (equivalente directo)
 *
 * SELECCION DE TAGS (equivalente a @CucumberOptions(tags) en Serenity):
 *   mvn test -P smoke            → solo escenarios @smoke
 *   mvn test -P regression       → todos los escenarios @regression
 *   mvn test -P e2e              → solo flujos @e2e
 *
 * REPORTES (equivalente a target/site/serenity/index.html en Serenity):
 *   target/karate-reports/karate-summary.html   → resumen ejecutivo
 *   target/karate-reports/features.*.html       → detalle por feature
 *   target/karate-reports/karate-timeline.html  → ejecucion en paralelo
 * =============================================================================
 */
function fn() {

    // ── 1. Detectar entorno activo ───────────────────────────────────────────
    var entornoActivo = karate.env || 'dev';

    karate.log('');
    karate.log('═══════════════════════════════════════════════════════════════');
    karate.log('  [CONFIG]  AUTO-API-KARATE — Inicializando framework');
    karate.log('═══════════════════════════════════════════════════════════════');
    karate.log('  [~] Entorno detectado : ' + entornoActivo);

    // ── 2. Mapa de configuracion por entorno ─────────────────────────────────
    var mapaDeEntornos = {

        // Entorno de desarrollo — timeout standard, SSL desactivado
        dev: {
            urlBase:         'https://serverest.dev',
            tiempoConexion:  5000,
            tiempoRespuesta: 10000
        },

        // Entorno staging — timeouts mas amplios para pre-produccion
        staging: {
            urlBase:         'https://serverest.dev',
            tiempoConexion:  8000,
            tiempoRespuesta: 15000
        },

        // Entorno produccion — timeouts maximos; preferir solo operaciones GET
        prod: {
            urlBase:         'https://serverest.dev',
            tiempoConexion:  10000,
            tiempoRespuesta: 20000
        }
    };

    // ── 3. Obtener configuracion del entorno activo (fallback a 'dev') ───────
    var configuracionDelEntorno = mapaDeEntornos[entornoActivo] || mapaDeEntornos['dev'];

    if (!mapaDeEntornos[entornoActivo]) {
        karate.log('  [!] Entorno desconocido "' + entornoActivo + '" — usando dev por defecto');
    }

    // ── 4. Armar configuracion global del framework ──────────────────────────
    var configuracionGlobal = {

        // URL base accesible en todos los feature files como ${baseUrl}
        baseUrl:     configuracionDelEntorno.urlBase,

        // Nombre del entorno activo (util para condicionales en features)
        environment: entornoActivo,

        // Cabeceras HTTP comunes que se aplican a todas las peticiones
        commonHeaders: {
            'Content-Type': 'application/json',
            'Accept':        'application/json',
            'monitor':       'false'
        },

        // Tiempos de espera aplicados globalmente
        connectTimeout: configuracionDelEntorno.tiempoConexion,
        readTimeout:    configuracionDelEntorno.tiempoRespuesta
    };

    // ── 5. Aplicar configuracion HTTP global de Karate ───────────────────────
    karate.configure('connectTimeout', configuracionDelEntorno.tiempoConexion);
    karate.configure('readTimeout',    configuracionDelEntorno.tiempoRespuesta);

    // Aceptar cualquier certificado SSL en entornos no productivos
    if (entornoActivo !== 'prod') {
        karate.configure('ssl', true);
    }

    // Logs de peticion/respuesta formateados (facilita depuracion de fallos)
    karate.configure('logPrettyRequest',  true);
    karate.configure('logPrettyResponse', true);

    // ── 6. Log de confirmacion de carga ─────────────────────────────────────
    karate.log('  [~] URL base           : ' + configuracionGlobal.baseUrl);
    karate.log('  [~] Timeout conexion   : ' + configuracionDelEntorno.tiempoConexion + ' ms');
    karate.log('  [~] Timeout respuesta  : ' + configuracionDelEntorno.tiempoRespuesta + ' ms');
    karate.log('  [~] SSL permisivo      : ' + (entornoActivo !== 'prod' ? 'SI (no productivo)' : 'NO (produccion)'));
    karate.log('  [i] Framework listo para entorno: ' + entornoActivo);
    karate.log('───────────────────────────────────────────────────────────────');
    karate.log('');

    return configuracionGlobal;
}
