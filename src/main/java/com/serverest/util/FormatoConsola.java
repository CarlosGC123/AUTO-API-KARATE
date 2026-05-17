package com.serverest.util;

/**
 * FormatoConsola
 * =============================================================================
 * Clase utilitaria para embellecer y estructurar los mensajes de consola
 * durante la ejecucion de la suite de pruebas automatizadas.
 *
 * Principios SOLID aplicados:
 *   SRP  - responsabilidad unica: formatear mensajes de consola.
 *   OCP  - extensible con nuevos metodos sin modificar los existentes.
 *   DRY  - cada formato se define una vez y se reutiliza desde todos los runners.
 *
 * Uso:
 *   FormatoConsola.imprimirEncabezado("Suite de Usuarios");
 *   FormatoConsola.imprimirInfo("Entorno", "dev");
 *   FormatoConsola.imprimirExito("Suite finalizada con 39 escenarios pasados");
 * =============================================================================
 */
public final class FormatoConsola {

    // ── Codigos de color ANSI (compatibles con Windows Terminal, Linux, macOS) ──
    private static final String REINICIAR       = "\033[0m";
    private static final String AMARILLO        = "\033[33m";
    private static final String AZUL            = "\033[34m";
    private static final String MAGENTA         = "\033[35m";
    private static final String CYAN            = "\033[36m";
    private static final String BLANCO          = "\033[37m";
    private static final String ROJO            = "\033[31m";
    private static final String VERDE_NEGRITA   = "\033[1;32m";
    private static final String CYAN_NEGRITA    = "\033[1;36m";
    private static final String BLANCO_NEGRITA  = "\033[1;37m";
    private static final String AMARILLO_NEGRITA= "\033[1;33m";

    // ── Separadores visuales ──────────────────────────────────────────────────
    private static final String LINEA_DOBLE  = "═══════════════════════════════════════════════════════════════════════";
    private static final String LINEA_SIMPLE = "───────────────────────────────────────────────────────────────────────";
    private static final String LINEA_PUNTOS = "·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·  ·";

    // ── Iconos de estado ──────────────────────────────────────────────────────
    private static final String ICONO_INICIO     = "[>>]";
    private static final String ICONO_FIN        = "[OK]";
    private static final String ICONO_EXITO      = "[+]";
    private static final String ICONO_ERROR      = "[x]";
    private static final String ICONO_INFO       = "[i]";
    private static final String ICONO_ADVERTENCIA= "[!]";
    private static final String ICONO_CONFIG     = "[~]";
    private static final String ICONO_TAG        = "[#]";
    private static final String ICONO_PRUEBA     = "[T]";
    private static final String ICONO_PASO       = "[-]";

    // ── Constructor privado: clase de utilidad, no instanciable ──────────────
    private FormatoConsola() {
        throw new UnsupportedOperationException("Clase de utilidad - no instanciable");
    }

    // =========================================================================
    // METODOS DE FORMATO PRINCIPAL
    // =========================================================================

    /**
     * Imprime el encabezado principal de un corredor de pruebas.
     * Usa linea doble para maxima visibilidad al inicio de cada suite.
     *
     * @param tituloDeLaSuite nombre de la suite que se va a ejecutar
     */
    public static void imprimirEncabezado(String tituloDeLaSuite) {
        System.out.println();
        System.out.println(CYAN_NEGRITA + LINEA_DOBLE + REINICIAR);
        System.out.println(CYAN_NEGRITA + "  " + ICONO_INICIO + "  AUTO-API-KARATE — ServeRest" + REINICIAR);
        System.out.println(BLANCO_NEGRITA + "       " + tituloDeLaSuite + REINICIAR);
        System.out.println(CYAN_NEGRITA + LINEA_DOBLE + REINICIAR);
        System.out.println();
    }

    /**
     * Imprime el cierre de una suite con el resultado final.
     *
     * @param mensajeFinal mensaje descriptivo del resultado
     */
    public static void imprimirCierre(String mensajeFinal) {
        System.out.println();
        System.out.println(VERDE_NEGRITA + LINEA_SIMPLE + REINICIAR);
        System.out.println(VERDE_NEGRITA + "  " + ICONO_FIN + "  " + mensajeFinal + REINICIAR);
        System.out.println(VERDE_NEGRITA + LINEA_SIMPLE + REINICIAR);
        System.out.println();
    }

    /**
     * Imprime una seccion con su titulo, util para agrupar bloques de informacion.
     *
     * @param nombreSeccion nombre de la seccion a mostrar
     */
    public static void imprimirSeccion(String nombreSeccion) {
        System.out.println();
        System.out.println(AMARILLO_NEGRITA + "  ┌─ " + nombreSeccion + REINICIAR);
        System.out.println(AMARILLO + "  │" + REINICIAR);
    }

    /**
     * Marca el cierre de una seccion.
     */
    public static void imprimirCierreSeccion() {
        System.out.println(AMARILLO + "  └" + LINEA_SIMPLE.substring(0, 40) + REINICIAR);
    }

    // =========================================================================
    // METODOS DE INFORMACION
    // =========================================================================

    /**
     * Imprime un par clave-valor como informacion de configuracion.
     *
     * @param clave  nombre del parametro
     * @param valor  valor del parametro
     */
    public static void imprimirInfo(String clave, String valor) {
        System.out.println(AZUL + "  " + ICONO_INFO + "  " + BLANCO + clave
                + ": " + AMARILLO + valor + REINICIAR);
    }

    /**
     * Imprime un par clave-valor de configuracion del entorno.
     *
     * @param clave  nombre del parametro de configuracion
     * @param valor  valor del parametro
     */
    public static void imprimirConfiguracion(String clave, String valor) {
        System.out.println(CYAN + "  " + ICONO_CONFIG + "  " + BLANCO + clave
                + ": " + CYAN_NEGRITA + valor + REINICIAR);
    }

    /**
     * Imprime el tag de ejecucion activo para la suite.
     *
     * @param tagDeEjecucion tag Karate que filtra los escenarios
     */
    public static void imprimirTagActivo(String tagDeEjecucion) {
        System.out.println(MAGENTA + "  " + ICONO_TAG + "  Tag activo: "
                + BLANCO_NEGRITA + tagDeEjecucion + REINICIAR);
    }

    /**
     * Imprime la ruta del classpath que se va a ejecutar.
     *
     * @param rutaDeEjecucion ruta classpath al directorio de features
     */
    public static void imprimirRutaEjecucion(String rutaDeEjecucion) {
        System.out.println(AZUL + "  " + ICONO_PRUEBA + "  Ruta de pruebas: "
                + BLANCO + rutaDeEjecucion + REINICIAR);
    }

    // =========================================================================
    // METODOS DE ESTADO
    // =========================================================================

    /**
     * Imprime un mensaje de exito en verde.
     *
     * @param mensajeDeExito descripcion del exito
     */
    public static void imprimirExito(String mensajeDeExito) {
        System.out.println(VERDE_NEGRITA + "  " + ICONO_EXITO + "  " + mensajeDeExito + REINICIAR);
    }

    /**
     * Imprime un mensaje de error en rojo.
     *
     * @param mensajeDeError descripcion del error
     */
    public static void imprimirError(String mensajeDeError) {
        System.out.println(ROJO + "  " + ICONO_ERROR + "  " + mensajeDeError + REINICIAR);
    }

    /**
     * Imprime una advertencia en amarillo.
     *
     * @param mensajeDeAdvertencia descripcion de la advertencia
     */
    public static void imprimirAdvertencia(String mensajeDeAdvertencia) {
        System.out.println(AMARILLO + "  " + ICONO_ADVERTENCIA + "  " + mensajeDeAdvertencia + REINICIAR);
    }

    /**
     * Imprime el paso actual de un flujo o proceso.
     *
     * @param numeroPaso numero del paso (ej: "1 de 3")
     * @param descripcion descripcion del paso
     */
    public static void imprimirPaso(String numeroPaso, String descripcion) {
        System.out.println(BLANCO + "  " + ICONO_PASO + "  Paso " + numeroPaso
                + ": " + CYAN + descripcion + REINICIAR);
    }

    // =========================================================================
    // METODOS DE SEPARACION
    // =========================================================================

    /**
     * Imprime una linea separadora simple para dividir bloques de informacion.
     */
    public static void imprimirSeparador() {
        System.out.println(AZUL + "  " + LINEA_SIMPLE + REINICIAR);
    }

    /**
     * Imprime una linea de puntos como separador liviano entre secciones.
     */
    public static void imprimirSeparadorLiviano() {
        System.out.println(BLANCO + "  " + LINEA_PUNTOS + REINICIAR);
    }

    /**
     * Imprime una linea en blanco para mejorar la legibilidad.
     */
    public static void imprimirLineaEnBlanco() {
        System.out.println();
    }

    // =========================================================================
    // METODOS DE RESUMEN
    // =========================================================================

    /**
     * Imprime el bloque de resumen de configuracion antes de ejecutar una suite.
     * Centraliza la informacion del entorno para que sea visible de inmediato.
     *
     * @param nombreCorredor  nombre del corredor que se ejecuta
     * @param entorno         entorno activo (dev, staging, prod)
     * @param urlBase         URL base de la API bajo prueba
     * @param tagDeEjecucion  tag Karate activo (puede ser "" si no hay filtro)
     * @param threadsParalelos numero de threads paralelos configurado
     */
    public static void imprimirResumenConfiguracion(
            String nombreCorredor,
            String entorno,
            String urlBase,
            String tagDeEjecucion,
            int    threadsParalelos) {

        imprimirSeccion("Configuracion de Ejecucion");
        imprimirConfiguracion("Corredor",         nombreCorredor);
        imprimirConfiguracion("Entorno activo",   entorno.isEmpty()  ? "dev (por defecto)" : entorno);
        imprimirConfiguracion("API base URL",      urlBase.isEmpty()  ? "https://serverest.dev" : urlBase);
        imprimirConfiguracion("Tag de filtro",     tagDeEjecucion.isEmpty() ? "(sin filtro — todos los escenarios)" : tagDeEjecucion);
        imprimirConfiguracion("Threads paralelos", String.valueOf(threadsParalelos));
        imprimirCierreSeccion();
    }
}

