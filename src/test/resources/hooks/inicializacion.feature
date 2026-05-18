# hooks/inicializacion.feature
# =============================================================================
# Patron Screenplay - Capa de Librerias Base (Base Library Layer)
# Capa: HOOKS
#
# Responsabilidad UNICA (SRP):
#   Centralizar la inicializacion compartida por TODOS los escenarios.
#   Cada feature de prueba llama este hook en su Background con una sola
#   linea, eliminando la duplicacion del setup (principio DRY).
#
# Principios SOLID aplicados:
#   SRP - unica responsabilidad: inicializar el contexto de prueba.
#   DRY - el Background se define aqui una vez; ningun feature lo repite.
#   DIP - los features dependen de esta abstraccion, nunca de rutas concretas.
#
# Equivalencia Screenplay: "Before Hook" - preparacion del Stage/escenario.
# =============================================================================
@hook
Feature: [HOOK] Inicializacion del Contexto de Prueba
  Scenario: Cargar todos los recursos compartidos del framework
    * def fabricaDatos      = call read('classpath:utils/fabricaDatos.js')
    * def constructorCuerpo = call read('classpath:utils/constructorCuerpo.js')
    * def mensajes          = read('classpath:data/datosPrueba.json').mensajesEsperados
    * def pantalla          = call read('classpath:screens/usuarios/pantallaUsuarios.js') { urlBase: '#(baseUrl)' }
    * def cabeceras         = commonHeaders
    * def esquemaListaUsuarios = read('classpath:schemas/esquemaListaUsuarios.json')
    * def esquemaUsuario       = read('classpath:schemas/esquemaUsuario.json')
    * def esquemaCrearUsuario  = read('classpath:schemas/esquemaCrearUsuario.json')
    * def esquemaMensaje       = read('classpath:schemas/esquemaMensaje.json')
    * karate.log('[HOOK] Contexto listo. Entorno: ' + environment + ' | URL: ' + baseUrl)
