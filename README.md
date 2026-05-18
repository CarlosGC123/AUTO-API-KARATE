# AUTO-API-KARATE — ServeRest API Automation

Suite de pruebas automatizadas para la [API de ServeRest](https://serverest.dev) construida con **Karate DSL + JUnit 5 + Maven**.

---

## Equivalencias con Serenity BDD

| Serenity BDD                              | Karate DSL (este proyecto)                         |
|-------------------------------------------|----------------------------------------------------|
| `serenity.conf` / `serenity.properties`   | `src/test/java/karate-config.js`                   |
| `@RunWith(CucumberWithSerenity.class)`    | `@Karate.Test` en `CucumberTestSuite.java`         |
| `CucumberTestSuite` (runner unico)        | `CucumberTestSuite.java` (runner unico)            |
| `@CucumberOptions(tags = {"@smoke"})`     | `-Dkarate.options=--tags @smoke`                   |
| `environments { dev { ... } }`            | `mapaDeEntornos` en `karate-config.js`             |
| `target/site/serenity/index.html`         | `target/karate-reports/karate-summary.html`        |
| `-Denvironment=staging`                   | `-P staging` (perfil Maven de entorno)             |
| Run Configuration: `mvn clean verify`     | Run Configuration: `clean verify` en IntelliJ      |

---

## Arquitectura del framework

```
src/test/java/
  karate-config.js                         <- configuracion global (equivale a serenity.conf)
  com/serverest/automation/
    runners/
      CucumberTestSuite.java               <- UNICO runner (equivale a CucumberTestSuite de Serenity)

src/test/resources/
  features/                                <- escenarios Gherkin (.feature)
    usuarios/
      registrarUsuario.feature
      obtenerUsuarios.feature
      obtenerUsuarioPorId.feature
      actualizarUsuario.feature
      eliminarUsuario.feature
      crudUsuarioE2E.feature
  interactions/                            <- llamadas HTTP reutilizables
  questions/                               <- validaciones reutilizables
  tasks/                                   <- flujos de negocio (login, crear usuario, etc.)
  schemas/                                 <- esquemas JSON para validacion
  data/                                    <- datos de prueba
  utils/
    fabricaDatos.js                        <- generador de datos dinamicos
    mensajes.js                            <- mensajes esperados de la API
```

---

## Runner unico — CucumberTestSuite.java

Solo existe **un** corredor de pruebas: `CucumberTestSuite.java`.

- **El entorno** se controla con el perfil Maven (`-P dev`, `-P staging`, `-P prod`)  
  que activa la entrada correspondiente en `karate-config.js` (`mapaDeEntornos`).
- **Los tags** se controlan con `-Dkarate.options=--tags @X`  
  que `CucumberTestSuite` recibe como propiedad de sistema y Karate aplica automaticamente.
- Sin parametros: se ejecutan **todos** los features.

> El runner no se modifica nunca para cambiar entorno o tags.

---

## Run Configurations (JetBrains / IntelliJ IDEA)

Ubicacion: `.idea/runConfigurations/`  
Se cargan automaticamente en el desplegable superior de IntelliJ (sin necesidad de importar manualmente).

### Por entorno (goal: `clean verify`)

| Configuracion              | Entorno  | Tags       | Equivalente Maven                              |
|----------------------------|----------|------------|------------------------------------------------|
| `DEV · Todos los tests`    | dev      | (todos)    | `mvn clean verify -P dev`                      |
| `STAGING · Todos los tests`| staging  | (todos)    | `mvn clean verify -P staging`                  |
| `PROD · Todos los tests`   | prod     | (todos)    | `mvn clean verify -P prod`                     |

### Por entorno + tag (goal: `clean verify` + `-Dkarate.options`)

| Configuracion              | Entorno  | Tags        | Equivalente Maven                                                        |
|----------------------------|----------|-------------|--------------------------------------------------------------------------|
| `DEV · Smoke`              | dev      | @smoke      | `mvn clean verify -P dev -Dkarate.options=--tags @smoke`                 |
| `DEV · Regression`         | dev      | @regression | `mvn clean verify -P dev -Dkarate.options=--tags @regression`            |
| `DEV · E2E`                | dev      | @e2e        | `mvn clean verify -P dev -Dkarate.options=--tags @e2e`                   |
| `STAGING · Smoke`          | staging  | @smoke      | `mvn clean verify -P staging -Dkarate.options=--tags @smoke`             |
| `STAGING · Regression`     | staging  | @regression | `mvn clean verify -P staging -Dkarate.options=--tags @regression`        |

### Como funciona el flujo

```
Run Config                        pom.xml                       CucumberTestSuite
-P staging         -->   karate.env = staging      -->   karate-config.js: urlBase staging
-Dkarate.options   -->   systemProperty karate.options  -->  Karate filtra por tag
clean verify       -->   maven-surefire-plugin      -->   ejecuta CucumberTestSuite
```

---

## Comandos Maven (equivalentes a las Run Configurations)

```bash
# Solo entorno
mvn clean verify -P dev
mvn clean verify -P staging
mvn clean verify -P prod

# Entorno + tag
mvn clean verify -P dev -Dkarate.options=--tags\ @smoke
mvn clean verify -P staging -Dkarate.options=--tags\ @regression

# Paralelo
mvn clean verify -P dev -Dthreads=8

# Debug secuencial
mvn clean verify -P dev -Dkarate.options=--tags\ @e2e -Dthreads=1
```

---

## Entornos

Definidos en `karate-config.js` → objeto `mapaDeEntornos`:

| Entorno   | Activacion    | URL base              |
|-----------|---------------|-----------------------|
| `dev`     | `-P dev`      | https://serverest.dev |
| `staging` | `-P staging`  | https://serverest.dev |
| `prod`    | `-P prod`     | https://serverest.dev |

Para agregar un entorno: agregar entrada en `mapaDeEntornos` y crear un perfil Maven en `pom.xml`.

---

## Tags disponibles

| Tag           | Descripcion                                        |
|---------------|----------------------------------------------------|
| `@smoke`      | Pruebas de humo — happy path de cada endpoint      |
| `@regression` | Suite completa de regresion — todos los casos      |
| `@e2e`        | Flujos end-to-end — CRUD completo                  |
| `@usuarios`   | Modulo de gestion de usuarios                      |

---

## Reportes

| Reporte                                           | Descripcion                            |
|---------------------------------------------------|----------------------------------------|
| `target/karate-reports/karate-summary.html`       | Resumen general (equivale a Serenity)  |
| `target/karate-reports/features.*.html`           | Detalle por feature                    |
| `target/karate-reports/karate-timeline.html`      | Linea de tiempo de ejecucion paralela  |
| `target/karate-reports/karate-tags.html`          | Resumen por tags                       |
| `target/surefire-reports/*.txt`                   | Log de salida del runner               |

---

## Estado de la suite

| Configuracion         | Tests | Pasados | Fallidos |
|-----------------------|-------|---------|----------|
| DEV · Smoke           | 6     | 6       | 0        |
| DEV · Regression      | 42    | 42      | 0        |
