package Modelo;

import java.time.LocalDateTime;

public class modeloDisponibilidad {
    private int idDisponibilidad;
    private LocalDateTime inicio;
    private LocalDateTime fin;
    private String estado; 

    public modeloDisponibilidad() {
    }

    public modeloDisponibilidad(int idDisponibilidad, LocalDateTime inicio, LocalDateTime fin, String estado) {
        this.idDisponibilidad = idDisponibilidad;
        this.inicio = inicio;
        this.fin = fin;
        this.estado = estado;
    }

    public int getIdDisponibilidad() {
        return idDisponibilidad;
    }

    public void setIdDisponibilidad(int idDisponibilidad) {
        this.idDisponibilidad = idDisponibilidad;
    }

    public LocalDateTime getInicio() {
        return inicio;
    }

    public void setInicio(LocalDateTime inicio) {
        this.inicio = inicio;
    }

    public LocalDateTime getFin() {
        return fin;
    }

    public void setFin(LocalDateTime fin) {
        this.fin = fin;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public boolean isActivo() {
        return "Activo".equalsIgnoreCase(this.estado);
    }

    @Override
    public String toString() {
        return "modeloDisponibilidad{" +
               "idDisponibilidad=" + idDisponibilidad +
               ", inicio=" + inicio +
               ", fin=" + fin +
               ", estado='" + estado + '\'' +
               '}';
    }
}
