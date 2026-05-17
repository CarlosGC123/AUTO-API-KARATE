# tasks/usuarios/crearNuevoUsuario.feature
# =============================================================================
# Patron Screenplay - Capa de Logica de Negocio (Business Logic Layer)
# Capa: TASKS
#
# Responsabilidad: orquestar el flujo de creacion de un usuario delegando
# la llamada HTTP a la interaction correspondiente. Sin aserciones de negocio.
#
# Principios SOLID:
#   SRP - solo crea el usuario, no valida ni limpia datos.
#   DIP - depende de la interaction registrarUsuario, nunca de HTTP directo.
#
# Variables de entrada requeridas:
#   datosDelNuevoUsuario : objeto { nome, email, password, administrador }
#
# Variables expuestas al llamador:
#   idUsuarioCreado   : ID asignado por la API al nuevo usuario
#   respuestaCreacion : cuerpo de respuesta completo (message + _id)
#
# Equivalencia Screenplay: "Task" - accion de alto nivel del actor.
# =============================================================================
@task
Feature: [TASK] Crear Nuevo Usuario en el Sistema

  Scenario: Registrar usuario y exponer su ID para uso posterior

    # Preparar URL y cuerpo de la solicitud de registro
    * def urlAccion       = pantalla.urlRegistrarUsuario
    * def cuerpoSolicitud = datosDelNuevoUsuario

    # Ejecutar interaction atomica POST /usuarios
    * call read('classpath:interactions/usuarios/registrarUsuario.feature@exitoso')

    # Exponer resultado al contexto llamador
    * def idUsuarioCreado   = response._id
    * def respuestaCreacion = response

    * karate.log('[TASK] Usuario creado. ID:', idUsuarioCreado)