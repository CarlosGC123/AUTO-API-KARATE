# AUTO-API-KARATE

> Suite de pruebas automatizadas para la [API REST de ServeRest](https://serverest.dev), construida con **Karate DSL 1.4.1 + JUnit 5 + Maven**.  
> Aplica el patrón **Screenplay** como arquitectura base y los principios **SOLID / DRY**.

---

## Tabla de contenidos

1. [Requisitos previos](#1-requisitos-previos)
2. [Instalación](#2-instalación)
3. [Estructura del proyecto](#3-estructura-del-proyecto)
4. [Cómo funciona Karate DSL](#4-cómo-funciona-karate-dsl)
5. [Arquitectura — Patrón Screenplay](#5-arquitectura--patrón-screenplay)
6. [Configuración de entornos](#6-configuración-de-entornos)
7. [Etiquetas (tags) disponibles](#7-etiquetas-tags-disponibles)
8. [Ejecución](#8-ejecución)
9. [Run Configurations en IntelliJ IDEA](#9-run-configurations-en-intellij-idea)
10. [Reportes](#10-reportes)
11. [Estado de la suite](#11-estado-de-la-suite)
12. [Equivalencias con Serenity BDD](#12-equivalencias-con-serenity-bdd)

---

## 1. Requisitos previos

| Herramienta | Versión mínima | Descarga |
|---|---|---|
| **Java JDK** | 11 (recomendado: 21 LTS) | [Amazon Corretto](https://aws.amazon.com/corretto/) · [Adoptium](https://adoptium.net/) |
| **Apache Maven** | 3.8+ | [maven.apache.org](https://maven.apache.org/download.cgi) |
| **IntelliJ IDEA** | 2023+ (Community o Ultimate) | [jetbrains.com/idea](https://www.jetbrains.com/idea/download/) |
| **Plugin Karate** *(opcional)* | última versión | IntelliJ → *Settings > Plugins* → buscar **"Karate"** |
| **Git** | cualquiera | [git-scm.com](https://git-scm.com/) |

> **Nota sobre el plugin de Karate:** sin él, IntelliJ marca los pasos en naranja porque el plugin de Cucumber busca métodos Java `@Given/@When/@Then` que no existen en Karate (Karate tiene su propio intérprete). Los tests funcionan igual — es un falso positivo visual. Instalar el plugin de Karate elimina las advertencias.

### Verificar instalación

```bash
java -version    # debe mostrar 11 o superior
mvn -version     # debe mostrar 3.8 o superior
```

---

## 2. Instalación

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd auto-api-karate

# 2. Descargar dependencias (solo la primera vez)
mvn clean install -DskipTests

# 3. Verificar que todo compila
mvn compile
```

> Maven descarga automáticamente Karate DSL, JUnit 5 y Logback desde Maven Central. No se requiere ninguna instalación adicional.

---

## 3. Estructura del proyecto

```
auto-api-karate/
├── pom.xml                                     ← dependencias, plugins y perfiles Maven
├── src/
│   ├── main/
│   │   └── java/com/serverest/util/
│   │       ├── ConstantesPrueba.java            ← constantes globales (ruta features, threads)
│   │       └── FormatoConsola.java              ← utilidad de output formateado en consola
│   └── test/
│       ├── java/
│       │   ├── karate-config.js                 ← configuración central (equivale a serenity.conf)
│       │   └── com/serverest/automation/runners/
│       │       └── CucumberTestSuite.java        ← ÚNICO runner JUnit 5
│       └── resources/
│           ├── features/                         ← ✅ TESTS EJECUTABLES (Gherkin + Karate DSL)
│           │   └── usuarios/
│           │       ├── registrarUsuario.feature
│           │       ├── obtenerUsuarios.feature
│           │       ├── obtenerUsuarioPorId.feature
│           │       ├── actualizarUsuario.feature
│           │       ├── eliminarUsuario.feature
│           │       └── crudUsuarioE2E.feature
│           ├── hooks/                            ← setup del contexto (BeforeEach)
│           │   └── inicializacion.feature
│           ├── tasks/                            ← acciones de negocio reutilizables
│           │   └── usuarios/
│           ├── interactions/                     ← llamadas HTTP reutilizables (GET/POST/PUT/DELETE)
│           │   └── usuarios/
│           ├── questions/                        ← validaciones y asserts reutilizables
│           ├── screens/                          ← endpoints y datos de cada módulo
│           │   └── usuarios/pantallaUsuarios.js
│           ├── schemas/                          ← esquemas JSON para validación de estructura
│           ├── data/
│           │   └── datosPrueba.json              ← mensajes esperados de la API
│           └── utils/
│               ├── fabricaDatos.js               ← generador de datos dinámicos (nombres, emails)
│               └── constructorCuerpo.js          ← constructores de request body
```

---

## 4. Cómo funciona Karate DSL

A diferencia de **Cucumber puro**, Karate **no necesita clases Java** para los pasos. El lenguaje de scripting está integrado directamente en los archivos `.feature`:

```gherkin
# Esto ES el código — no hay un @Given/@When/@Then en Java detrás
* url pantalla.urlBaseUsuarios
* request constructorCuerpo.cuerpoDesdeColumnas(nombre, email, password, administrador)
* method post
* status 201
* match response == esquemaCrearUsuario
```

Los archivos `.feature` cumplen **dos roles**:

| Rol | Carpeta | Descripción |
|---|---|---|
| **Test ejecutable** | `features/` | Karate los corre directamente; tienen etiquetas `@smoke`, `@regression`, etc. |
| **Subrutina reutilizable** | `hooks/` `tasks/` `interactions/` `questions/` | Se invocan con `call read('classpath:...')` desde otros features — equivalen a métodos o funciones. |

### Referencia rápida de comandos Karate

| Comando | Descripción |
|---|---|
| `* def variable = valor` | Declarar una variable |
| `* read('classpath:archivo.json')` | Cargar un archivo (JSON, JS, XML, texto) |
| `* call read('classpath:x.feature')` | Ejecutar una subrutina (feature o JS) |
| `* callonce read(...)` | Igual que `call` pero ejecuta una sola vez por suite |
| `* url 'https://...'` | Establecer la URL base del request |
| `* path '/segmento', variable` | Agregar segmentos a la URL |
| `* headers { ... }` | Agregar headers HTTP |
| `* request { ... }` | Definir el body del request |
| `* method post` | Disparar la llamada HTTP (get/post/put/delete/patch) |
| `* status 201` | Assert del código de respuesta HTTP |
| `* match response == esquema` | Assert del contenido o estructura de la respuesta |
| `* match response.campo == '#string'` | Fuzzy matcher: `#string` `#number` `#boolean` `#notnull` `#array` |
| `* print 'mensaje:', variable` | Imprimir en consola |

---

## 5. Arquitectura — Patrón Screenplay

El proyecto sigue el patrón **Screenplay** adaptado a Karate DSL:

```
features/usuarios/registrarUsuario.feature   ← ESCENARIO (orquesta el flujo)
    │
    ├── call hooks/inicializacion.feature     ← carga variables globales (BeforeEach)
    │
    ├── call tasks/crearNuevoUsuario.feature  ← TASK: acción de negocio de alto nivel
    │       └── call interactions/registrarUsuario.feature  ← INTERACTION: HTTP POST /usuarios
    │
    └── call questions/verificarEsquemaUsuario.feature ← QUESTION: valida la respuesta
```

| Capa | Carpeta | Responsabilidad única |
|---|---|---|
| **Escenarios** | `features/` | Orquestar el flujo, etiquetar con tags |
| **Tasks** | `tasks/` | Acciones de negocio de alto nivel |
| **Interactions** | `interactions/` | Una llamada HTTP concreta |
| **Questions** | `questions/` | Un assert sobre la respuesta |
| **Screens** | `screens/` | URLs y datos del módulo |
| **Hooks** | `hooks/` | Setup/teardown compartido |
| **Utils** | `utils/` | Funciones JavaScript auxiliares |

> Cada capa tiene **una única responsabilidad** (SRP). Si cambia un endpoint, solo se toca `interactions/`. Si cambia una validación, solo se toca `questions/`.

---

## 6. Configuración de entornos

Los entornos se definen en `karate-config.js` → objeto `mapaDeEntornos` y se activan con perfiles Maven (`-P`):

| Entorno | Perfil Maven | URL base | Timeout conexión | Timeout respuesta |
|---|---|---|---|---|
| `dev` *(defecto)* | `-P dev` | https://serverest.dev | 5 000 ms | 10 000 ms |
| `staging` | `-P staging` | https://serverest.dev | 8 000 ms | 15 000 ms |
| `prod` | `-P prod` | https://serverest.dev | 10 000 ms | 20 000 ms |

Para **agregar un nuevo entorno**: añadir una entrada en `mapaDeEntornos` en `karate-config.js` y crear el perfil correspondiente en `pom.xml`.

---

## 7. Etiquetas (tags) disponibles

Los tags filtran qué escenarios se ejecutan. Se activan combinando un perfil de entorno con un perfil de tag:

| Tag | Perfil Maven | Escenarios incluidos |
|---|---|---|
| `@smoke` | `-P smoke` | Happy path de cada endpoint — ejecución rápida |
| `@regression` | `-P regression` | Suite completa de regresión |
| `@e2e` | `-P e2e` | Flujos CRUD end-to-end |
| `@usuarios` | `-P usuarios` | Solo el módulo de usuarios |
| *(sin tag)* | *(sin perfil de tag)* | Todos los features |

---

## 8. Ejecución

### Desde la terminal (Maven)

```bash
# ── Todos los tests en DEV ──────────────────────────────────────────────────
mvn clean verify -P dev

# ── Por entorno + suite ─────────────────────────────────────────────────────
mvn clean verify -P dev,smoke
mvn clean verify -P dev,regression
mvn clean verify -P dev,e2e
mvn clean verify -P staging,smoke
mvn clean verify -P prod,smoke

# ── Controlar paralelismo (por defecto: 4 hilos) ────────────────────────────
mvn clean verify -P dev,regression -Dthreads=8    # más rápido
mvn clean verify -P dev,regression -Dthreads=1    # secuencial (ideal para debug)
```

> **`clean verify`** compila el proyecto, ejecuta los tests y genera los reportes HTML en `target/karate-reports/`.

### Desde IntelliJ IDEA

Ver la sección [Run Configurations](#9-run-configurations-en-intellij-idea).

---

## 9. Run Configurations en IntelliJ IDEA

Las configuraciones están en `.idea/workspace.xml` y se cargan **automáticamente** en el desplegable superior de IntelliJ — no es necesario importar nada manualmente.

| Configuración | Perfiles activos | Equivalente Maven |
|---|---|---|
| `DEV · Todos` | `dev` | `mvn clean verify -P dev` |
| `DEV · Smoke` | `dev, smoke` | `mvn clean verify -P dev,smoke` |
| `DEV · Regression` | `dev, regression` | `mvn clean verify -P dev,regression` |
| `DEV · E2E` | `dev, e2e` | `mvn clean verify -P dev,e2e` |
| `STAGING · Todos` | `staging` | `mvn clean verify -P staging` |
| `STAGING · Smoke` | `staging, smoke` | `mvn clean verify -P staging,smoke` |
| `STAGING · Regression` | `staging, regression` | `mvn clean verify -P staging,regression` |
| `PROD · Smoke` | `prod, smoke` | `mvn clean verify -P prod,smoke` |

---

## 10. Reportes

Tras cada ejecución, Karate genera reportes HTML en `target/karate-reports/`:

| Archivo | Descripción |
|---|---|
| `karate-summary.html` | **Reporte principal** — resumen ejecutivo con todos los resultados |
| `karate-tags.html` | Resultados agrupados por tag |
| `karate-timeline.html` | Línea de tiempo de ejecución paralela (útil para optimizar hilos) |
| `features.usuarios.*.html` | Detalle completo de cada feature (request, response, asserts) |

> Abrir directamente en el navegador — no requiere servidor.

---

## 11. Estado de la suite

| Configuración | Escenarios | ✅ Pasados | ❌ Fallidos |
|---|---|---|---|
| DEV · Smoke | 6 | 6 | 0 |
| DEV · Regression | 42 | 42 | 0 |

---

## 12. Equivalencias con Serenity BDD

Para equipos que vienen de Serenity BDD:

| Serenity BDD | Karate DSL (este proyecto) |
|---|---|
| `serenity.conf` / `serenity.properties` | `src/test/java/karate-config.js` |
| `environments { dev { ... } }` | `mapaDeEntornos` en `karate-config.js` |
| `-Denvironment=staging` | `-P staging` (perfil Maven) |
| `@RunWith(CucumberWithSerenity.class)` | `@Karate.Test` en `CucumberTestSuite.java` |
| `@CucumberOptions(tags = {"@smoke"})` | `-P smoke` (perfil Maven) |
| Paso Java `@Given/@When/@Then` | Palabra clave Karate: `url`, `method`, `match`, `call`... |
| `target/site/serenity/index.html` | `target/karate-reports/karate-summary.html` |
| Screenplay `Task` / `Interaction` / `Question` | Carpetas `tasks/` / `interactions/` / `questions/` |

---

*Construido con [Karate DSL](https://karatelabs.github.io/karate/) · Probado contra [ServeRest API](https://serverest.dev)*
