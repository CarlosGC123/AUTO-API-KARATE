package com.serverest.modelo;

/**
 * Usuario
 * =============================================================================
 * Modelo de dominio que representa un usuario del sistema ServeRest.
 *
 * Refleja la estructura del recurso /usuarios de la API. Los campos de la API
 * estan en portugues (nome, administrador) por ser de origen brasileno.
 *
 * Principios SOLID aplicados:
 *   SRP - representa exclusivamente el modelo de datos de un usuario.
 *   OCP - extensible sin modificar la clase base.
 * =============================================================================
 */
public class Usuario {

    /** Identificador unico asignado por la base de datos de ServeRest */
    private String identificador;

    /** Nombre completo del usuario (campo 'nome' en la API) */
    private String nombre;

    /** Direccion de correo electronico unica del usuario */
    private String email;

    /** Contrasena de acceso del usuario */
    private String contrasena;

    /** Indica si el usuario es administrador ("true" o "false" como String) */
    private String esAdministrador;

    // ── Constructor sin argumentos (requerido por serializadores JSON) ---------
    public Usuario() {}

    // ── Constructor con todos los campos --------------------------------------
    public Usuario(String nombre, String email, String contrasena, String esAdministrador) {
        this.nombre          = nombre;
        this.email           = email;
        this.contrasena      = contrasena;
        this.esAdministrador = esAdministrador;
    }

    // ── Getters y Setters con nombres semanticos en espanol -------------------

    public String getIdentificador()                         { return identificador; }
    public void   setIdentificador(String identificador)     { this.identificador = identificador; }

    public String getNombre()                                { return nombre; }
    public void   setNombre(String nombre)                   { this.nombre = nombre; }

    public String getEmail()                                 { return email; }
    public void   setEmail(String email)                     { this.email = email; }

    public String getContrasena()                            { return contrasena; }
    public void   setContrasena(String contrasena)           { this.contrasena = contrasena; }

    public String getEsAdministrador()                       { return esAdministrador; }
    public void   setEsAdministrador(String esAdministrador) { this.esAdministrador = esAdministrador; }

    @Override
    public String toString() {
        return "Usuario{id='" + identificador + "', nombre='" + nombre
             + "', email='" + email + "', administrador='" + esAdministrador + "'}";
    }
}

