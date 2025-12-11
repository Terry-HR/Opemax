
package Modelo;


public class modeloReporte {
      private int idreporte;
    private int idusuario;
    private String servicio;
    private String empresa;
    private String reclamo;
    private String fecha_ing;
    private String fecha_fin;
    private int estado;

    public modeloReporte() {
    }

    public modeloReporte(int idreporte, int idusuario, String servicio, String empresa, String reclamo, String fecha_ing, String fecha_fin, int estado) {
        this.idreporte = idreporte;
        this.idusuario = idusuario;
        this.servicio = servicio;
        this.empresa = empresa;
        this.reclamo = reclamo;
        this.fecha_ing = fecha_ing;
        this.fecha_fin = fecha_fin;
        this.estado = estado;
    }

    public int getIdreporte() {
        return idreporte;
    }

    public void setIdreporte(int idreporte) {
        this.idreporte = idreporte;
    }

    public int getIdusuario() {
        return idusuario;
    }

    public void setIdusuario(int idusuario) {
        this.idusuario = idusuario;
    }

    public String getServicio() {
        return servicio;
    }

    public void setServicio(String servicio) {
        this.servicio = servicio;
    }

    public String getEmpresa() {
        return empresa;
    }

    public void setEmpresa(String empresa) {
        this.empresa = empresa;
    }

    public String getReclamo() {
        return reclamo;
    }

    public void setReclamo(String reclamo) {
        this.reclamo = reclamo;
    }

    public String getFecha_ing() {
        return fecha_ing;
    }

    public void setFecha_ing(String fecha_ing) {
        this.fecha_ing = fecha_ing;
    }

    public String getFecha_fin() {
        return fecha_fin;
    }

    public void setFecha_fin(String fecha_fin) {
        this.fecha_fin = fecha_fin;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }
    
}
