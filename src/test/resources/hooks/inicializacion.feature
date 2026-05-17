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
    # -- Fabrica de datos dinamicos de prueba ---------------------------------
    # Genera datos unicos por escenario (timestamp + aleatorio) evitando
    # colisiones en ejecucion paralela.
    * def fabricaDatos = call read('classpath:utils/fabricaDatos.js')
    # -- Constructor de cuerpos de solicitud HTTP -----------------------------
    # Permite armar payloads desde parametros de Scenario Outline.
    * def constructorCuerpo = call read('classpath:utils/constructorCuerpo.js')
    # -- Datos de prueba estaticos --------------------------------------------
    # JSON con mensajes esperados de la API y usuarios de referencia.
    * def datosPrueba = read('classpath:data/datosPrueba.json')
    * def mensajes    = datosPrueba.mensajesEsperados
    # -- Pantalla de Usuarios: URLs centralizadas (Screen / Page Object) ------
    # Ningun otra capa construye URLs directamente.
    * def pantalla = call read('classpath:screens/usuarios/pantallaUsuarios.js') { urlBase: '#(baseUrl)' }
    # -- Cabeceras HTTP comunes -----------------------------------------------
    * def cabeceras = commonHeaders
    # -- Esquemas JSON para validacion de contratos (Contract Testing) --------
    # Cargados desde schemas/ en formato Karate DSL nativo (#string, #number).
    * def esquemaListaUsuarios   = read('classpath:schemas/esquemaListaUsuarios.json')
    * def esquemaUsuario         = read('classpath:schemas/esquemaUsuario.json')
    * def esquemaCrearUsuario    = read('classpath:schemas/esquemaCrearUsuario.json')
    * def esquemaMensaje         = read('classpath:schemas/esquemaMensaje.json')
    * def esquemaErrorValidacion = read('classpath:schemas/esquemaErrorValidacion.json')
    * karate.log('[HOOK] Contexto inicializado. Entorno: ' + environment + ' | URL: ' + baseUrl)