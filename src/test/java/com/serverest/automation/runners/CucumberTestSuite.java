package com.serverest.automation.runners;

import com.intuit.karate.junit5.Karate;
import com.serverest.util.ConstantesPrueba;
import com.serverest.util.FormatoConsola;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;

/**
 * CucumberTestSuite — Runner Unificado del Framework
 * =============================================================================
 * Runner UNICO para toda la suite. Equivalente al CucumberTestSuite de Serenity BDD.
 *
 * ENTORNO   → perfil Maven: -P dev | -P staging | -P prod
 * TAGS      → perfil Maven: -P smoke | -P regression | -P e2e | -P usuarios
 * COMBINADO → mvn clean verify -P dev,smoke
 *
 * Run Configurations en IntelliJ: .idea/runConfigurations/  (ver README.md)
 *
 * REPORTES:
 *   target/karate-reports/karate-summary.html   → resumen ejecutivo
 *   target/karate-reports/karate-tags.html      → resumen por tags
 *   target/karate-reports/karate-timeline.html  → ejecucion paralela
 *
 * EQUIVALENCIAS CON SERENITY BDD:
 *   karate-config.js        ↔  serenity.conf / serenity.properties
 *   @Karate.Test            ↔  @RunWith(CucumberWithSerenity.class)
 *   karate-summary.html     ↔  target/site/serenity/index.html
 *   -P smoke                ↔  @CucumberOptions(tags = {"@smoke"})
 *   -P dev                  ↔  -Denvironment=dev
 * =============================================================================
 */
@DisplayName("Suite Completa — ServeRest API Automation")
public class CucumberTestSuite {

    @BeforeAll
    static void antesDeEjecutarLaSuite() {
        String entorno  = System.getProperty("karate.env",     "dev");
        String opciones = System.getProperty("karate.options", "");
        int    threads  = Integer.parseInt(System.getProperty("threads",
                                  String.valueOf(ConstantesPrueba.THREADS_POR_DEFECTO)));

        FormatoConsola.imprimirEncabezado("ServeRest API Automation");
        FormatoConsola.imprimirResumenConfiguracion(
                "CucumberTestSuite",
                entorno,
                resolverUrlBase(entorno),
                opciones.isEmpty() ? "(sin filtro — todos los escenarios)" : opciones,
                threads);
        FormatoConsola.imprimirInfo("Features",  ConstantesPrueba.RUTA_TODAS_LAS_PRUEBAS);
        FormatoConsola.imprimirInfo("Reporte",   "target/karate-reports/karate-summary.html");
        FormatoConsola.imprimirSeparador();
    }

    @AfterAll
    static void despuesDeEjecutarLaSuite() {
        FormatoConsola.imprimirSeparador();
        FormatoConsola.imprimirExito("Suite finalizada.");
        FormatoConsola.imprimirInfo("Reporte detallado", "target/karate-reports/karate-summary.html");
        FormatoConsola.imprimirInfo("Reporte por tags",  "target/karate-reports/karate-tags.html");
        FormatoConsola.imprimirInfo("Timeline paralelo", "target/karate-reports/karate-timeline.html");
        FormatoConsola.imprimirCierre("Abre los reportes en tu navegador para ver el detalle completo.");
    }

    /**
     * Punto de entrada. Karate lee automaticamente karate.env y karate.options
     * del sistema — no modificar este metodo para cambiar entorno o tags.
     */
    @Karate.Test
    @DisplayName("Ejecutar suite con entorno y tags configurados via Maven")
    Karate ejecutarSuiteCompleta() {
        return Karate.run(ConstantesPrueba.RUTA_TODAS_LAS_PRUEBAS)
                     .relativeTo(getClass());
    }

    private static String resolverUrlBase(String entorno) {
        switch (entorno) {
            case "staging": return "https://serverest.dev  [staging]";
            case "prod":    return "https://serverest.dev  [prod]";
            default:        return "https://serverest.dev  [dev]";
        }
    }
}
