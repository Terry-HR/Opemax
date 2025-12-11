
package Modelo;

public class modeloValoraciond {
       private int idvdistribuidor;
    private int idusuario;
    private String distribuidor;
    private int valoracion;

    public modeloValoraciond() {
    }

    public modeloValoraciond(int idvdistribuidor, int idusuario, String distribuidor, int valoracion) {
        this.idvdistribuidor = idvdistribuidor;
        this.idusuario = idusuario;
        this.distribuidor = distribuidor;
        this.valoracion = valoracion;
    }

    public int getIdvdistribuidor() {
        return idvdistribuidor;
    }

    public void setIdvdistribuidor(int idvdistribuidor) {
        this.idvdistribuidor = idvdistribuidor;
    }

    public int getIdusuario() {
        return idusuario;
    }

    public void setIdusuario(int idusuario) {
        this.idusuario = idusuario;
    }

    public String getDistribuidor() {
        return distribuidor;
    }

    public void setDistribuidor(String distribuidor) {
        this.distribuidor = distribuidor;
    }

    public int getValoracion() {
        return valoracion;
    }

    public void setValoracion(int valoracion) {
        this.valoracion = valoracion;
    }

 
    
}
