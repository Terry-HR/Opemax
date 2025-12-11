
package Modelo;

import java.sql.Date;

public class modeloEmovil {
    private int idemovil;
    private int idusuario;
    private Date fecha;
    private String operadora;
    private String region;
    private double plan;
    private double mbsreci;
    private double costo;

    public modeloEmovil() {
    }

    public modeloEmovil(int idemovil, int idusuario, Date fecha, String operadora, String region, double plan, double mbsreci, double costo) {
        this.idemovil = idemovil;
        this.idusuario = idusuario;
        this.fecha = fecha;
        this.operadora = operadora;
        this.region = region;
        this.plan = plan;
        this.mbsreci = mbsreci;
        this.costo = costo;
    }

    public int getIdemovil() {
        return idemovil;
    }

    public void setIdemovil(int idemovil) {
        this.idemovil = idemovil;
    }

    public int getIdusuario() {
        return idusuario;
    }

    public void setIdusuario(int idusuario) {
        this.idusuario = idusuario;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getOperadora() {
        return operadora;
    }

    public void setOperadora(String operadora) {
        this.operadora = operadora;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public double getPlan() {
        return plan;
    }

    public void setPlan(double plan) {
        this.plan = plan;
    }

    public double getMbsreci() {
        return mbsreci;
    }

    public void setMbsreci(double mbsreci) {
        this.mbsreci = mbsreci;
    }

    public double getCosto() {
        return costo;
    }

    public void setCosto(double costo) {
        this.costo = costo;
    }
    
}