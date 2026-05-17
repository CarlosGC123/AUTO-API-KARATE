package com.serverest.automation.runners;

import com.intuit.karate.junit5.Karate;
import com.serverest.util.ConstantesPrueba;
import com.serverest.util.FormatoConsola;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;

/**
 * CorredorPruebas — Runner Unificado del Framework
 * =============================================================================
 * Equivalente al CucumberTestSuite de Serenity BDD.
 * Runner UNICO para toda la suite: no existe ningun otro corredor.
 *
 * SELECCION DE TAGS (equivalente a @CucumberOptions en Serenity):
 *   -Dkarate.options="--tags @smoke"         // solo humo
 *   -Dkarate.options="--tags @regression"    // regresion completa
 *   -Dkarate.options="--tags @usuarios"      // modulo usuarios
 *   -Dkarate.options="--tags @e2e"           // solo End-to-End
 *   (sin parametro)                           // ejecuta TODOS los escenarios
 *
 * SELECCION DE ENTORNO (equivalente a environments: en serenity.conf):
 *   -Dkarate.env=dev        (por defecto)
 *   -Dkarate.env=staging
 *   -Dkarate.env=prod
 *
 * COMANDOS MAVEN COMPLETOS:
 *   mvn test                                          -> todos los features, entorno dev
 *   mvn test -P smoke                                 -> solo @smoke, entorno dev
 *   mvn test -P regression -Dkarate.env=staging       -> @regression en staging
 *   mvn test -P smoke -Dkarate.env=prod               -> @smoke en prod
 *   mvn test -Dkarate.options="--tags @e2e"           -> tag personalizado
 *   mvn test -Dthreads=8                              -> paralelo con 8 threads
 *
 * DONDE ESTAN LOS REPORTES:
 *   target/karate-reports/karate-summary.html         -> resumen general
 *   target/karate-reports/features.*.html             -> detalle por feature
 *   target/karate-reports/karate-timeline.html        -> linea de tiempo paralela
 *
 * EQUIVALENCIAS CON SERENITY BDD:
 *   karate-config.js       <->  serenity.conf / serenity.properties
 *   karate.options=--tags  <->  @CucumberOptions(tags = {...})
 *   karate-summary.html    <->  target/site/serenity/index.html
 *   @Karate.Test           <->  @RunWith(CucumberWithSerenity.class)
 * =============================================================================
 */
@DisplayName("Suite Completa — ServeRest API Automation")
public class CucumberTestSuite {

    // ── Ciclo de vida del runner ──────────────────────────────────────────────

    /**
     * Se ejecuta UNA VEZ antes de toda la suite.
     * Equivalente al @Before(order=0) global de Serenity.
     */
    @BeforeAll
    static void antesDeEjecutarLaSuite() {
        String entorno  = System.getProperty("karate.env", "dev");
        String opciones = System.getProperty("karate.options", "(sin filtro — todos los escenarios)");

        FormatoConsola.imprimirEncabezado("AUTO-API-KARATE — ServeRest API Automation");
        FormatoConsola.imprimirResumenConfiguracion(
                "CorredorPruebas (runner unico)",
                entorno,
                resolverUrlBase(entorno),
                opciones,
                Integer.parseInt(System.getProperty("threads", String.valueOf(ConstantesPrueba.THREADS_POR_DEFECTO)))
        );
        FormatoConsola.imprimirInfo("Reportes", "target/karate-reports/karate-summary.html");
        FormatoConsola.imprimirSeparador();
    }

    /**
     * Se ejecuta UNA VEZ despues de toda la suite.
     * Equivalente al @AfterSuite de Serenity.
     */
    @AfterAll
    static void despuesDeEjecutarLaSuite() {
        FormatoConsola.imprimirCierre(
            "Suite finalizada. Reporte completo en: target/karate-reports/karate-summary.html"
        );
    }

    // ── Metodo de ejecucion ───────────────────────────────────────────────────

    /**
     * Punto de entrada principal de la suite.
     *
     * Karate lee automaticamente:
     *   - karate.env    : entorno activo (dev / staging / prod) -> karate-config.js
     *   - karate.options: filtro de tags (--tags @smoke, --tags @regression, etc.)
     *
     * No es necesario modificar este metodo para cambiar entorno o tags;
     * se controla EXCLUSIVAMENTE via parametros Maven (-D) o perfiles (-P).
     */
    @Karate.Test
    @DisplayName("Ejecutar suite con entorno y tags configurados via Maven")
    Karate ejecutarSuiteCompleta() {
        return Karate.run(ConstantesPrueba.RUTA_TODAS_LAS_PRUEBAS)
                     .relativeTo(getClass());
    }

    // ── Metodos auxiliares ────────────────────────────────────────────────────

    /** Resuelve la URL base segun el entorno activo para mostrarla en el log de inicio. */
    private static String resolverUrlBase(String entorno) {
        switch (entorno) {
            case "staging": return "https://serverest.dev  [staging]";
            case "prod":    return "https://serverest.dev  [prod]";
            default:        return "https://serverest.dev  [dev]";
        }
    }
}

