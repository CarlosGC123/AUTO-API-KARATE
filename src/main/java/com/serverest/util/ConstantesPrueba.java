package com.serverest.util;

/**
 * ConstantesPrueba
 * =============================================================================
 * Constantes globales del framework de automatizacion.
 *
 * Centraliza los valores fijos compartidos entre el runner y la configuracion.
 * Evita literales magicos dispersos en el codigo.
 *
 * SRP  - solo almacena constantes del framework de pruebas.
 * OCP  - agregar una constante no modifica las existentes.
 * DRY  - cada constante se define una sola vez y se reutiliza desde aqui.
 * =============================================================================
 */
public final class ConstantesPrueba {

    private ConstantesPrueba() {
        throw new UnsupportedOperationException("Clase de constantes - no instanciable");
    }

    /** Ruta classpath raiz de todos los features (todos los modulos) */
    public static final String RUTA_TODAS_LAS_PRUEBAS = "classpath:features";

    /** Numero de threads paralelos por defecto */
    public static final int THREADS_POR_DEFECTO = 4;
}
