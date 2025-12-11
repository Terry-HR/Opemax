
package Modelo;

public class modeloValoracion {
      private int idvoperadora;
    private int idusuario;
    private String operadora;
    private int valoracion;

    public modeloValoracion() {
    }

    public modeloValoracion(int idvoperadora, int idusuario, String operadora, int valoracion) {
        this.idvoperadora = idvoperadora;
        this.idusuario = idusuario;
        this.operadora = operadora;
        this.valoracion = valoracion;
    }

    public int getIdvoperadora() {
        return idvoperadora;
    }

    public void setIdvoperadora(int idvoperadora) {
        this.idvoperadora = idvoperadora;
    }

    public int getIdusuario() {
        return idusuario;
    }

    public void setIdusuario(int idusuario) {
        this.idusuario = idusuario;
    }

    public String getOperadora() {
        return operadora;
    }

    public void setOperadora(String operadora) {
        this.operadora = operadora;
    }

    public int getValoracion() {
        return valoracion;
    }

    public void setValoracion(int valoracion) {
        this.valoracion = valoracion;
    }

   
}
