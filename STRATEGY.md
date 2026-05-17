# Informe de Estrategia de Automatización
## ServeRest API — Suite de Pruebas con Karate DSL

---

## 1. Resumen Ejecutivo

Este informe documenta la estrategia, arquitectura y patrones aplicados en la construcción del framework de automatización para la API de Usuarios de ServeRest, desarrollado como reto técnico para Senior QA Automation Engineer. El framework cubre el 100% de los criterios de aceptación definidos en la historia de usuario, con 39+ escenarios distribuidos entre casos positivos, negativos, y flujos de integración end-to-end.

---

## 2. Análisis de la API Bajo Prueba

### Sistema bajo prueba (SUT)
- **API**: ServeRest REST API — https://serverest.dev/
- **Módulo**: Usuarios (`/usuarios`)
- **Operaciones**: CRUD completo (GET, POST, PUT, DELETE)
- **Autenticación**: No requerida para el módulo de usuarios

### Observaciones del análisis exploratorio
1. La API sigue el estilo REST pero con algunas particularidades:
   - El campo `administrador` acepta strings `"true"`/`"false"`, no booleanos JSON.
   - `PUT` implementa semántica de **upsert**: si el ID no existe, crea el recurso con un nuevo ID y retorna 201.
   - `DELETE` de un recurso inexistente retorna **200** (no 404), con mensaje `"Nenhum registro excluído"`.
2. No existe aislamiento de datos entre usuarios de la API: el entorno es compartido y global.
3. Los IDs son strings alfanuméricos generados por el backend (MongoDB ObjectId format).

---

## 3. Estrategia de Pruebas

### 3.1 Niveles de Testing

Se implementó una pirámide de testing con tres niveles:

```
        /\
       /E2E\          Flujos de integración completos
      /------\
     /  REG   \       Regresión: positivos + negativos por endpoint
    /----------\
   /   SMOKE    \     Humo: verificación básica de disponibilidad
  /--------------\
```

| Nivel      | Tag         | Propósito                                    | Frecuencia recomendada     |
|------------|-------------|----------------------------------------------|----------------------------|
| Smoke      | `@smoke`    | Verificar que la API responde correctamente  | Cada commit / PR            |
| Regression | `@regression` | Cobertura completa de escenarios           | Cada merge a develop/main   |
| E2E        | `@e2e`      | Validar flujos de negocio de punta a punta   | Nightly builds / pre-release|

### 3.2 Tipos de Pruebas Implementados

| Tipo                     | Descripción                                                          |
|--------------------------|----------------------------------------------------------------------|
| **Funcional positivo**   | Operaciones CRUD con datos válidos, verificando respuestas correctas |
| **Funcional negativo**   | Entradas inválidas, recursos inexistentes, duplicados               |
| **Contract Testing**     | Validación de esquemas JSON en todas las respuestas                  |
| **Data-driven testing**  | `Scenario Outline` con múltiples conjuntos de datos de entrada       |
| **Integration testing**  | Flujos E2E que encadenan múltiples llamadas API                      |

---

## 4. Patrones de Diseño Aplicados

### 4.1 Patrón Screenplay (adaptado a Karate DSL)

El patrón Screenplay, recomendado por el ISTQB TAE v2.0, estructura las pruebas en términos de actores y sus interacciones con el sistema. La adaptación a Karate DSL es la siguiente:

| Concepto original   | Implementación en Karate                          | Archivo                          |
|---------------------|---------------------------------------------------|----------------------------------|
| Actor               | Escenario Karate (el sujeto que ejecuta)          | `*.feature` (Background actor)   |
| Ability             | Capacidad de generar datos de prueba              | `helpers/dataFactory.js`         |
| Task                | Callable feature (acción de negocio compuesta)    | `libraries/usuariosApi.feature`  |
| Interaction         | Llamada HTTP atómica a un endpoint                | Scenarios en `usuariosApi.feature`|
| Question            | Aserción `match` sobre la respuesta               | Steps `Then match` en features   |
| Stage/Context       | Configuración global de entorno                   | `karate-config.js`               |

### 4.2 Separación en Tres Capas (TAE v2.0 — Testware Layers)

```
Capa 3 — Test Scripts:   Escenarios BDD de negocio (legibles por stakeholders)
Capa 2 — Business Logic: Callable features que encapsulan interacciones con la API
Capa 1 — Base Library:   Config, datos, schemas — infraestructura del framework
```

**Beneficio**: Un cambio en la URL base o en la estructura del request body solo requiere modificar la Capa 1 o 2, sin tocar los guiones de prueba.

### 4.3 Factory Method para Datos de Prueba

La clase `dataFactory.js` implementa el patrón **Factory Method** para la generación de datos:

- `validUser()` → Usuario genérico válido con datos dinámicos únicos
- `adminUser()` → Usuario con `administrador: "true"`  
- `regularUser()` → Usuario con `administrador: "false"`
- `updatedUser()` → Datos para operación de actualización
- `invalidUsers.*` → Variantes con datos inválidos para casos negativos
- `nonExistentId()` → ID con formato válido pero que no existe en el sistema

**Ventaja**: Elimina la dependencia de fixtures estáticos que podrían fallar por email duplicado entre ejecuciones.

---

## 5. Decisiones Técnicas Clave

### 5.1 Variantes `*Raw` en la librería API

Los escenarios de librería con sufijo `Raw` (ej: `postUsuarioRaw`, `putUsuarioRaw`) no incluyen aserción de status code. Esto permite que los tests negativos reciban respuestas de error (4xx) sin que Karate lance una excepción automática, manteniendo el flujo del test bajo control explícito del escenario.

### 5.2 Cleanup al final de cada escenario

Dado que la API de ServeRest es un entorno compartido (sin aislamiento de datos por sesión), cada escenario que crea usuarios los elimina al final. Esto garantiza:
- **Idempotencia**: Los tests producen el mismo resultado en cada ejecución.
- **No-interferencia**: Los tests no se afectan mutuamente en ejecución paralela.
- **Unicidad de email**: Al eliminar usuarios, sus emails quedan disponibles nuevamente.

### 5.3 Datos dinámicos vs. estáticos

| Situación                             | Enfoque aplicado         |
|---------------------------------------|--------------------------|
| Tests de creación (POST/PUT)          | `dataFactory.js` dinámico |
| Tests de Scenario Outline             | Datos inline en Examples  |
| Mensajes de respuesta esperados        | `testData.json` estático  |
| Validación de esquemas JSON           | Archivos `schemas/*.json` |

### 5.4 Upsert en PUT

ServeRest implementa PUT como upsert. El TC-PUT-003 documenta y verifica este comportamiento, que es parte del contrato de la API y debe ser conocido por el equipo.

---

## 6. Cobertura y Métricas

### Distribución de escenarios

| Categoría             | Cantidad | % del total |
|-----------------------|----------|-------------|
| Casos positivos       | 21       | ~54%        |
| Casos negativos       | 17+      | ~44%        |
| Flujos E2E            | 2        | ~5%         |
| **Total**             | **39+**  | **100%**    |

### Cobertura de endpoints

| Endpoint                    | HTTP Methods cubiertos | Códigos de estado validados |
|-----------------------------|------------------------|-----------------------------|
| `/usuarios`                 | GET, POST              | 200, 201, 400               |
| `/usuarios/{id}`            | GET, PUT, DELETE       | 200, 201, 400               |
| Parámetros de query         | `nome`, `email`        | 200 (con/sin resultados)    |

---

## 7. Riesgos y Mitigaciones

| Riesgo                                          | Probabilidad | Impacto | Mitigación                                           |
|-------------------------------------------------|:------------:|:-------:|------------------------------------------------------|
| API compartida — contaminación de datos          | Alta         | Medio   | Cleanup en cada escenario; datos únicos por timestamp|
| Inestabilidad del entorno ServeRest              | Media        | Alto    | Retry configurable en Karate; timeouts explícitos    |
| Cambio de contrato en la API (breaking changes) | Baja         | Alto    | Contract testing con JSON Schema en cada respuesta   |
| Emails duplicados en paralelo                   | Media        | Alto    | Factory genera timestamp + random para garantizar unicidad |
| Latencia de red en CI/CD                        | Media        | Medio   | Timeouts generosos por entorno en `karate-config.js` |

---

## 8. Recomendaciones de Mejora Continua

1. **Mock Server**: Integrar WireMock o Karate mock server para pruebas offline y cobertura de escenarios de timeout/error de red.
2. **Allure Reports**: Integrar el plugin de Allure para reportes más ricos con historial de tendencias.
3. **Autenticación**: Cuando la API implemente autenticación (tokens JWT), extender `karate-config.js` con la obtención automática de tokens.
4. **Test de Carga**: Karate tiene soporte nativo de Gatling para performance testing reutilizando los mismos feature files.
5. **Data Provider externo**: Para suites de mayor escala, externalizar los datos de prueba a archivos CSV o una base de datos de fixtures.

---

*Documento elaborado como parte del reto técnico de Senior QA Automation Engineer.*  
*Principios ISTQB Test Automation Engineer v2.0 aplicados.*
