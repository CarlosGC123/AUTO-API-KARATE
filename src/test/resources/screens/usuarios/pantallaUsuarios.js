function fn(configuracion) {
    var base    = configuracion.urlBase;
    var segment = '/usuarios';
    return {
        urlListaUsuarios:    base + segment,
        urlRegistrarUsuario: base + segment,
        urlBaseUsuarios:     base + segment
    };
}