package Modelo;

import java.time.LocalDateTime;

public class modeloSenal {
    private int idSenal;
    private int idUsuario;
    private LocalDateTime fecha;
    private String servicio;
    private String empresa;
    private String region;
    private int valoracion;
    private String calidadSenal;

    public modeloSenal() {}

    // Setters con validación
    public void setServicio(String servicio) {
        if(servicio == null || !(servicio.equals("Movil") || servicio.equals("Hogar"))) {
            throw new IllegalArgumentException("El servicio debe ser 'Movil' o 'Hogar'");
        }
        this.servicio = servicio;
    }

    public void setValoracion(int valoracion) {
    this.valoracion = valoracion;
    this.calidadSenal = calcularCalidad(valoracion);
}

    public void setCalidadSenal(String calidadSenal) {
        if(!calidadSenal.equals("Buena") && !calidadSenal.equals("Regular") && !calidadSenal.equals("Mala")) {
            throw new IllegalArgumentException("Calidad de señal no válida");
        }
        this.calidadSenal = calidadSenal;
    }

    private String calcularCalidad(int valoracion) {
    if (valoracion >= 8) return "Buena";
    if (valoracion >= 5) return "Regular";
    return "Mala";
}

    // Getters
    public int getIdSenal() { return idSenal; }
    public void setIdSenal(int idSenal) { this.idSenal = idSenal; }
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    public LocalDateTime getFecha() { return fecha; }
    public void setFecha(LocalDateTime fecha) { this.fecha = fecha; }
    public String getServicio() { return servicio; }
    public String getEmpresa() { return empresa; }
    public void setEmpresa(String empresa) { this.empresa = empresa; }
    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }
    public int getValoracion() { return valoracion; }
    public String getCalidadSenal() { return calidadSenal; }
}