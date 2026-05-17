/**
 * utils/fabricaDatos.js
 * =============================================================================
 * Patron Screenplay - Capa de Librerias Base (Base Library Layer)
 * Capa: UTILS
 *
 * Responsabilidad UNICA (SRP):
 *   Generar datos de prueba dinamicos, unicos y validos para cada escenario,
 *   evitando colisiones en ejecuciones paralelas.
 *
 * Principios SOLID aplicados:
 *   SRP - solo genera datos, no realiza HTTP ni aserciones.
 *   ISP - expone metodos granulares; los consumidores usan solo lo que necesitan.
 *   OCP - extensible (nuevos tipos = nuevas funciones) sin modificar las existentes.
 *
 * NOTA TECNICA (GraalVM / Karate 1.4.x):
 *   Cada metodo retornado es AUTOCONTENIDO: no depende de variables del scope
 *   exterior (closure). Esto garantiza compatibilidad con el motor GraalVM
 *   Polyglot que usa Karate al invocar funciones via call read().
 *
 * Equivalencia Screenplay: "Ability"
 * =============================================================================
 */
function fn() {
    return {
        // ── Generadores primitivos ────────────────────────────────────────────
        /** Retorna el timestamp actual en milisegundos */
        generarMarcaDeTiempo: function() {
            return new Date().getTime();
        },
        /** Retorna una cadena aleatoria de letras minusculas */
        generarCadenaAleatoria: function(longitud) {
            var caracteres = 'abcdefghijklmnopqrstuvwxyz';
            var resultado  = '';
            for (var i = 0; i < longitud; i++) {
                resultado += caracteres.charAt(Math.floor(Math.random() * caracteres.length));
            }
            return resultado;
        },
        /** Retorna un entero aleatorio entre minimo y maximo (inclusive) */
        generarNumeroAleatorio: function(minimo, maximo) {
            return Math.floor(Math.random() * (maximo - minimo + 1)) + minimo;
        },
        // ── Constructores de usuarios validos ─────────────────────────────────
        /** Usuario generico valido — autocontenido, sin closures */
        usuarioValido: function() {
            var c = 'abcdefghijklmnopqrstuvwxyz';
            var r = '';
            for (var i = 0; i < 4; i++) r += c.charAt(Math.floor(Math.random() * c.length));
            var s = new Date().getTime() + '_' + r;
            return {
                nome:          'UsuarioTest_' + s,
                email:         'user_' + s + '@qa-automatizacion.com',
                password:      'Senha@Test' + (Math.floor(Math.random() * 900) + 100),
                administrador: 'true'
            };
        },
        /** Usuario administrador — autocontenido, sin closures */
        usuarioAdministrador: function() {
            var c = 'abcdefghijklmnopqrstuvwxyz';
            var r = '';
            for (var i = 0; i < 4; i++) r += c.charAt(Math.floor(Math.random() * c.length));
            var s = new Date().getTime() + '_' + r;
            return {
                nome:          'Administrador_' + s,
                email:         'admin_' + s + '@qa-automatizacion.com',
                password:      'Admin@Pass' + (Math.floor(Math.random() * 900) + 100),
                administrador: 'true'
            };
        },
        /** Usuario regular (sin administrador) — autocontenido, sin closures */
        usuarioRegular: function() {
            var c = 'abcdefghijklmnopqrstuvwxyz';
            var r = '';
            for (var i = 0; i < 4; i++) r += c.charAt(Math.floor(Math.random() * c.length));
            var s = new Date().getTime() + '_' + r;
            return {
                nome:          'Regular_' + s,
                email:         'regular_' + s + '@qa-automatizacion.com',
                password:      'Regular@Pass' + (Math.floor(Math.random() * 900) + 100),
                administrador: 'false'
            };
        },
        /** Datos actualizados para escenarios PUT — autocontenido, sin closures */
        usuarioActualizado: function() {
            var c = 'abcdefghijklmnopqrstuvwxyz';
            var r = '';
            for (var i = 0; i < 4; i++) r += c.charAt(Math.floor(Math.random() * c.length));
            var s = 'act_' + new Date().getTime() + '_' + r;
            return {
                nome:          'UsuarioActualizado_' + s,
                email:         'actualizado_' + s + '@qa-automatizacion.com',
                password:      'Updated@Pass' + (Math.floor(Math.random() * 900) + 100),
                administrador: 'false'
            };
        },
        // ── Datos invalidos para casos negativos ──────────────────────────────
        usuariosInvalidos: {
            emailConFormatoInvalido: {
                nome:          'Usuario Email Invalido',
                email:         'email-invalido-sin-arroba',
                password:      'Password@123',
                administrador: 'true'
            },
            nombreVacio: {
                nome:          '',
                email:         'sin_nombre@prueba.com',
                password:      'Password@123',
                administrador: 'true'
            },
            passwordVacio: {
                nome:          'Usuario Sin Password',
                email:         'sin_pass@prueba.com',
                password:      '',
                administrador: 'true'
            },
            emailVacio: {
                nome:          'Usuario Sin Email',
                email:         '',
                password:      'Password@123',
                administrador: 'true'
            },
            administradorConValorInvalido: {
                nome:          'Usuario Admin Invalido',
                email:         'admin_invalido@prueba.com',
                password:      'Password@123',
                administrador: 'quizas'
            }
        },
        // ── Identificadores de prueba ─────────────────────────────────────────
        /** ID de 24 chars que NO existe en ServeRest (ObjectId de MongoDB invalido) */
        idInexistente: function() {
            return '000000000000000000000000';
        }
    };
}