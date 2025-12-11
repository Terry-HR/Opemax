package Modelo;

import java.time.LocalDateTime;
import java.time.Duration;

public class modeloEficiencia { 
    private int idIncidente;
    private int idUsuario;
    private String descripcion;
    private LocalDateTime fechaApertura;
    private LocalDateTime fechaResolucion;
    private String estado;

    public modeloEficiencia() {
    }

    public modeloEficiencia(int idIncidente, int idUsuario, String descripcion,
                          LocalDateTime fechaApertura, LocalDateTime fechaResolucion, String estado) {
        this.idIncidente = idIncidente;
        this.idUsuario = idUsuario;
        this.descripcion = descripcion;
        this.fechaApertura = fechaApertura;
        this.fechaResolucion = fechaResolucion;
        this.estado = estado;
    }

    public int getIdIncidente() {
        return idIncidente;
    }

    public void setIdIncidente(int idIncidente) {
        this.idIncidente = idIncidente;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public LocalDateTime getFechaApertura() {
        return fechaApertura;
    }

    public void setFechaApertura(LocalDateTime fechaApertura) {
        this.fechaApertura = fechaApertura;
    }

    public LocalDateTime getFechaResolucion() {
        return fechaResolucion;
    }

    public void setFechaResolucion(LocalDateTime fechaResolucion) {
        this.fechaResolucion = fechaResolucion;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public boolean isResuelto() {
        return "Resuelto".equalsIgnoreCase(this.estado);
    }

    public long getDuracionEnMinutos() {
        if (fechaApertura != null && fechaResolucion != null) {
            return Duration.between(fechaApertura, fechaResolucion).toMinutes();
        }
        return -1;
    }

    @Override
    public String toString() {
        return "modeloEficiencia{" +
               "idIncidente=" + idIncidente +
               ", idUsuario=" + idUsuario +
               ", descripcion='" + descripcion + '\'' +
               ", fechaApertura=" + fechaApertura +
               ", fechaResolucion=" + fechaResolucion +
               ", estado='" + estado + '\'' +
               '}';
    }
}
