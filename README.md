# AUTO-API-KARATE

## Tabla de Contenidos

1. [Tecnologías y Versiones](#tecnologías-y-versiones)  
2. [Arquitectura del Framework](#arquitectura-del-framework)  
3. [Estructura del Proyecto](#estructura-del-proyecto)  
4. [Prerrequisitos](#prerrequisitos)  
5. [Configuración del Entorno](#configuración-del-entorno)  
6. [Ejecución de Pruebas](#ejecución-de-pruebas)  
7. [Cobertura de Pruebas](#cobertura-de-pruebas)  
8. [Reportes](#reportes)  
9. [Estrategia de Automatización](#estrategia-de-automatización)  
10. [Pipeline CI/CD](#pipeline-cicd)  

---

## Tecnologías y Versiones

| Tecnología        | Versión   | Propósito                              |
|-------------------|-----------|----------------------------------------|
| **Java**          | 11+       | Plataforma de ejecución                |
| **Maven**         | 3.8+      | Gestión de dependencias y build        |
| **Karate DSL**    | 1.4.1     | Framework de pruebas API               |
| **JUnit 5**       | 5.10.1    | Test runner y reporting                |
| **Logback**       | 1.4.11    | Logging estructurado                   |

---

## Arquitectura del Framework

El framework implementa una arquitectura de **tres capas** inspirada en el patrón **Screenplay** (ISTQB TAE v2.0), garantizando separación de responsabilidades, reutilización y mantenibilidad:

```
┌─────────────────────────────────────────────────────────────────┐
│  CAPA 3 — GUIONES DE PRUEBA (Test Script Layer)                 │
│  features/usuarios/*.feature                                     │
│  → Escenarios de negocio legibles (BDD)                         │
│  → Actores: Administrador del sistema                           │
│  → Sin lógica técnica directa                                   │
├─────────────────────────────────────────────────────────────────┤
│  CAPA 2 — LÓGICA DE NEGOCIO (Business Logic / Task Layer)       │
│  libraries/usuariosApi.feature                                   │
│  → Interacciones atómicas con la API (callable features)        │
│  → Encapsula URLs, métodos HTTP y aserciones básicas            │
│  → Reusables desde cualquier guión de prueba                    │
├─────────────────────────────────────────────────────────────────┤
│  CAPA 1 — LIBRERÍAS BASE (Base Library Layer)                   │
│  karate-config.js       → Configuración de entornos (Stage)     │
│  helpers/dataFactory.js → Fábrica de datos de prueba (Ability)  │
│  data/testData.json     → Datos estáticos (Test Data)           │
│  schemas/*.json         → Esquemas JSON de validación           │
└─────────────────────────────────────────────────────────────────┘
```

### Equivalencia con el Patrón Screenplay

| Concepto Screenplay | Implementación en Karate              |
|---------------------|---------------------------------------|
| **Actor**           | Test scenario (el "quién")            |
| **Ability**         | `dataFactory.js` (datos disponibles)  |
| **Task**            | Callable features en `libraries/`     |
| **Interaction**     | Llamadas HTTP atómicas por endpoint   |
| **Question**        | Aserciones `match` en feature files   |
| **Stage**           | `karate-config.js` (contexto global)  |

---

## Estructura del Proyecto

```
auto-api-karate/
│
├── pom.xml                                   # Configuración Maven y dependencias
│
└── src/test/
    ├── java/
    │   ├── karate-config.js                  # [CAPA 1] Configuración global de entornos
    │   └── com/serverest/automation/
    │       └── runners/
    │           ├── UsuariosRunner.java        # Runner suite completa de usuarios
    │           ├── SmokeTestRunner.java       # Runner pruebas de humo (@smoke)
    │           └── RegressionTestRunner.java  # Runner regresión completa (@regression)
    │
    └── resources/
        │
        ├── helpers/
        │   └── dataFactory.js                # [CAPA 1] Fábrica de datos dinámicos
        │
        ├── data/
        │   └── testData.json                 # [CAPA 1] Datos de prueba estáticos
        │
        ├── schemas/                          # [CAPA 1] Esquemas JSON (contract testing)
        │   ├── usuariosListSchema.json        # Esquema GET /usuarios
        │   ├── usuarioSchema.json             # Esquema GET /usuarios/{id}
        │   ├── usuarioCreateSchema.json       # Esquema POST /usuarios (201)
        │   ├── messageSchema.json             # Esquema respuestas con mensaje
        │   └── errorValidationSchema.json     # Esquema errores 400
        │
        ├── libraries/
        │   └── usuariosApi.feature           # [CAPA 2] Librería API (callable features)
        │
        ├── features/
        │   └── usuarios/                     # [CAPA 3] Guiones de prueba
        │       ├── getUsuarios.feature        # GET /usuarios — 7 escenarios
        │       ├── postUsuario.feature        # POST /usuarios — 10 escenarios
        │       ├── getUsuarioById.feature     # GET /usuarios/{id} — 6 escenarios
        │       ├── putUsuario.feature         # PUT /usuarios/{id} — 7 escenarios
        │       ├── deleteUsuario.feature      # DELETE /usuarios/{id} — 7 escenarios
        │       └── crudUsuarioE2E.feature     # Flujo E2E completo — 2 escenarios
        │
        └── logback-test.xml                  # Configuración de logging
```

---

## Prerrequisitos

- **Java JDK 11** o superior  
  ```bash
  java -version
  # java version "11.x.x" or higher
  ```

- **Apache Maven 3.8+**  
  ```bash
  mvn -version
  # Apache Maven 3.8.x or higher
  ```

- **Conexión a Internet** para acceder a `https://serverest.dev`

---

## Configuración del Entorno

### 1. Clonar el repositorio

```bash
git clone https://github.com/TU_USUARIO/auto-api-karate.git
cd auto-api-karate
```

### 2. Instalar dependencias

```bash
mvn dependency:resolve
```

### 3. Verificar la configuración

El archivo `src/test/java/karate-config.js` contiene la configuración de entornos:

| Entorno    | URL Base                    | Activación                     |
|------------|-----------------------------|--------------------------------|
| `dev`      | `https://serverest.dev`     | Por defecto (sin `-Dkarate.env`) |
| `staging`  | `https://serverest.dev`     | `-Dkarate.env=staging`         |
| `prod`     | `https://serverest.dev`     | `-Dkarate.env=prod`            |

---

## Ejecución de Pruebas

### Ejecutar todos los tests

```bash
mvn test
```

### Ejecutar suite completa de Usuarios

```bash
mvn test -Dtest=UsuariosRunner
```

### Ejecutar solo pruebas de humo (Smoke Tests)

```bash
# Opción 1: Runner dedicado
mvn test -Dtest=SmokeTestRunner

# Opción 2: Perfil Maven
mvn test -P smoke
```

### Ejecutar suite de regresión completa

```bash
# Opción 1: Runner dedicado  
mvn test -Dtest=RegressionTestRunner

# Opción 2: Perfil Maven
mvn test -P regression
```

### Ejecutar por endpoint específico (tags)

```bash
# Solo GET de usuarios
mvn test -Dkarate.options="--tags @get"

# Solo POST
mvn test -Dkarate.options="--tags @post"

# Solo PUT
mvn test -Dkarate.options="--tags @put"

# Solo DELETE
mvn test -Dkarate.options="--tags @delete"

# Solo flujos E2E
mvn test -Dkarate.options="--tags @e2e"
```

### Ejecutar un test case específico por ID

```bash
# Ejemplo: ejecutar solo TC-POST-001
mvn test -Dkarate.options="--tags @TC-POST-001"
```

### Ejecutar con entorno específico

```bash
# Entorno staging
mvn test -Dkarate.env=staging

# Entorno prod (solo GETs, sin SSL strict)
mvn test -Dkarate.env=prod -Dtest=SmokeTestRunner
```

### Ejecución paralela

La ejecución paralela está habilitada por defecto con 4 threads. Para modificar:

```bash
mvn test -Dthreads=2
mvn test -Dthreads=8
```

---

## Cobertura de Pruebas

### Resumen de Escenarios por Endpoint

| Feature File            | Endpoint              | Positivos | Negativos | Total |
|-------------------------|-----------------------|-----------|-----------|-------|
| `getUsuarios.feature`   | `GET /usuarios`       | 7         | 0         | 7     |
| `postUsuario.feature`   | `POST /usuarios`      | 3         | 7         | 10    |
| `getUsuarioById.feature`| `GET /usuarios/{id}`  | 3         | 3         | 6     |
| `putUsuario.feature`    | `PUT /usuarios/{id}`  | 3         | 4 (+2 outline) | 7+ |
| `deleteUsuario.feature` | `DELETE /usuarios/{id}` | 3       | 3         | 7     |
| `crudUsuarioE2E.feature`| Flujo CRUD completo   | 2         | 0         | 2     |
| **TOTAL**               |                       | **21**    | **17+**   | **39+**|

### Tags disponibles

| Tag            | Descripción                                              |
|----------------|----------------------------------------------------------|
| `@smoke`       | Pruebas de humo — verificación básica de cada endpoint   |
| `@regression`  | Suite completa de regresión                              |
| `@e2e`         | Flujos de integración end-to-end                         |
| `@usuarios`    | Todas las pruebas del módulo de usuarios                 |
| `@get`         | Pruebas de operaciones GET                               |
| `@post`        | Pruebas de operaciones POST                              |
| `@put`         | Pruebas de operaciones PUT                               |
| `@delete`      | Pruebas de operaciones DELETE                            |
| `@TC-XXX-NNN`  | Identificador único de caso de prueba                    |

### Criterios de Aceptación Cubiertos

| Criterio de Aceptación                                 | Feature File           | Tests       |
|--------------------------------------------------------|------------------------|-------------|
| ✅ Se puede obtener lista de todos los usuarios         | `getUsuarios`          | TC-GET-001 a 007 |
| ✅ Se puede registrar nuevo usuario con datos válidos   | `postUsuario`          | TC-POST-001 a 003 |
| ✅ Se puede buscar usuario por ID                       | `getUsuarioById`       | TC-GETID-001 a 003 |
| ✅ Se puede actualizar información de usuario           | `putUsuario`           | TC-PUT-001 a 003 |
| ✅ Se puede eliminar un usuario del sistema             | `deleteUsuario`        | TC-DEL-001 a 003 |
| ✅ Flujo CRUD completo integrado                        | `crudUsuarioE2E`       | TC-E2E-001 a 002 |

---

## Reportes

Karate genera reportes automáticamente tras cada ejecución:

### Reporte HTML de Karate

```
target/karate-reports/
├── karate-summary.html      # Resumen ejecutivo con gráficos
├── karate-timeline.html     # Línea de tiempo de ejecución paralela
└── features/                # Reporte detallado por feature file
```

Para abrir el reporte:

```bash
# Windows
start target\karate-reports\karate-summary.html

# Linux/macOS
open target/karate-reports/karate-summary.html
```

### Logs de ejecución

```
target/logs/
└── automation.log           # Log completo de la ejecución
```

---

## Estrategia de Automatización

### Principios aplicados (ISTQB TAE v2.0)

1. **Separación de capas**: Configuración, lógica de negocio y guiones de prueba en capas independientes.  
2. **Datos de prueba independientes**: Cada escenario genera sus propios datos únicos via `dataFactory.js`, evitando colisiones en ejecución paralela.  
3. **Contract Testing via JSON Schema**: Todas las respuestas se validan contra esquemas JSON, detectando cambios en el contrato de la API.  
4. **Cleanup explícito**: Cada escenario elimina los datos que crea, garantizando idempotencia y no-interferencia.  
5. **Ejecución paralela**: Los tests son independientes entre sí y se ejecutan en paralelo por defecto.  
6. **Pirámide de testing**: Smoke → Regression → E2E, con ejecución selectiva por entorno y pipeline.

### Patrones utilizados

| Patrón                   | Implementación                                              |
|--------------------------|-------------------------------------------------------------|
| **Screenplay**           | Actores, Tareas (callable features), Habilidades (data factory) |
| **Page Object** (API)    | `libraries/usuariosApi.feature` encapsula endpoints         |
| **Factory Method**       | `dataFactory.js` genera objetos de prueba únicos            |
| **Test Data Builder**    | Métodos especializados: `adminUser()`, `regularUser()`, etc. |
| **Fluent Interface**     | Encadenamiento de llamadas Karate DSL                       |
| **Arrange-Act-Assert**   | Background (arrange) → When call (act) → Then match (assert) |

### Decisiones de diseño

- **Callable features vs. steps inline**: Las llamadas HTTP están en `libraries/` para evitar duplicación y facilitar cambios de URL en un solo lugar.
- **`*Raw` variants**: Los scenarios de librería con sufijo `Raw` no asertan el status code, permitiendo que los tests negativos validen el error sin excepción.
- **Datos dinámicos**: Se usa timestamp + random string para garantizar unicidad sin depender de una base de datos externa de fixtures.
- **`administrador` como string**: ServeRest espera los valores `"true"` / `"false"` como strings, no como booleanos JSON.

---

## Pipeline CI/CD

### GitHub Actions (ejemplo de configuración)

```yaml
# .github/workflows/api-tests.yml
name: API Tests — ServeRest

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 6 * * *'   # Ejecución diaria a las 6 AM UTC

jobs:
  smoke-tests:
    name: Smoke Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'
      - name: Run Smoke Tests
        run: mvn test -Dtest=SmokeTestRunner -Dkarate.env=dev
      - name: Upload Karate Report
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: karate-smoke-report
          path: target/karate-reports/

  regression-tests:
    name: Regression Tests
    runs-on: ubuntu-latest
    needs: smoke-tests
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'temurin'
      - name: Run Regression Tests
        run: mvn test -Dtest=RegressionTestRunner -Dthreads=4
      - name: Upload Karate Report
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: karate-regression-report
          path: target/karate-reports/
```

---

## Autor

Desarrollado como reto técnico para la posición de **Senior QA Automation Engineer**.  
Certificación: **ISTQB Certified Test Automation Engineer v2.0**

---

*Documentación generada para el proyecto `auto-api-karate` — ServeRest API Test Automation Framework*
