package com.serverest.util;

/**
 * ConstantesPrueba
 * =============================================================================
 * Clase de utilidades: constantes globales del framework de automatizacion.
 *
 * Centraliza los valores fijos compartidos entre runners, configuraciones y
 * cualquier clase Java del framework de pruebas. Evita la dispersion de
 * literales magicos por todo el codigo.
 *
 * Principios SOLID aplicados:
 *   SRP  - solo almacena constantes del framework de automatizacion.
 *   OCP  - agregar una constante no modifica las existentes.
 *   DRY  - cada constante se define una vez y se reutiliza desde aqui.
 * =============================================================================
 */
public final class ConstantesPrueba {

    // ── Constructor privado: clase de utilidad, no instanciable ───────────────
    private ConstantesPrueba() {
        throw new UnsupportedOperationException("Clase de constantes - no instanciable");
    }

    // ── Rutas de recursos del framework (classpath) ───────────────────────────

    /** Ruta a los features de prueba del modulo Usuarios */
    public static final String RUTA_PRUEBAS_USUARIOS = "classpath:features/usuarios";

    /** Ruta a todos los features de prueba (todos los modulos) */
    public static final String RUTA_TODAS_LAS_PRUEBAS = "classpath:features";

    // ── Tags de ejecucion selectiva ───────────────────────────────────────────

    /** Tag para ejecutar solo pruebas de humo */
    public static final String TAG_PRUEBAS_HUMO = "@smoke";

    /** Tag para ejecutar la suite completa de regresion */
    public static final String TAG_REGRESION = "@regression";

    /** Tag del modulo de usuarios */
    public static final String TAG_USUARIOS = "@usuarios";

    // ── Configuracion de ejecucion paralela ───────────────────────────────────

    /** Numero de threads paralelos por defecto */
    public static final int THREADS_POR_DEFECTO = 4;

    // ── Mensajes de log para los corredores ───────────────────────────────────

    /** Prefijo de log para el corredor de pruebas de humo */
    public static final String LOG_CORREDOR_HUMO = "[CORREDOR-HUMO]";

    /** Prefijo de log para el corredor de regresion */
    public static final String LOG_CORREDOR_REGRESION = "[CORREDOR-REGRESION]";

    /** Prefijo de log para el corredor de usuarios */
    public static final String LOG_CORREDOR_USUARIOS = "[CORREDOR-USUARIOS]";
}

