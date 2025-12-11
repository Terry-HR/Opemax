package DAO;

import Conexion.Conexion;
import Modelo.modeloEhome;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class EhomeDAO {

    public boolean registrarEhome(modeloEhome e) {
        String sql = "INSERT INTO ehome (idusuario, fecha, operadora, region, plan, mbsreci, costo) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, e.getIdusuario());
            ps.setDate(2, e.getFecha());
            ps.setString(3, e.getOperadora());
            ps.setString(4, e.getRegion());
            ps.setDouble(5, e.getPlan());
            ps.setDouble(6, e.getMbsreci());
            ps.setDouble(7, e.getCosto());

            return ps.executeUpdate() > 0;

        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }
    public static int getTotalEncuestas() {
    int total = 0;
    String sql = "SELECT COUNT(*) FROM ehome";
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            total = rs.getInt(1);
        }
    } catch (Exception e) {
        System.out.println("Error en getTotalEncuestas (ehome): " + e.getMessage());
    }
    return total;
}

public static int getTotalPorUsuario(int idusuario) {
    int total = 0;
    String sql = "SELECT COUNT(*) FROM ehome WHERE idusuario = ?";
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idusuario);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            total = rs.getInt(1);
        }
    } catch (Exception e) {
        System.out.println("Error en getTotalPorUsuario (ehome): " + e.getMessage());
    }
    return total;
}

    // ✅ NUEVO: Listar encuestas por usuario
    public List<modeloEhome> listarPorUsuario(int idusuario) {
        List<modeloEhome> lista = new ArrayList<>();
        String sql = "SELECT * FROM ehome WHERE idusuario = ? ORDER BY fecha DESC";

        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idusuario);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                modeloEhome e = new modeloEhome();
                e.setIdehome(rs.getInt("idehome"));
                e.setIdusuario(rs.getInt("idusuario"));
                e.setFecha(rs.getDate("fecha"));
                e.setOperadora(rs.getString("operadora"));
                e.setRegion(rs.getString("region"));
                e.setPlan(rs.getDouble("plan"));
                e.setMbsreci(rs.getDouble("mbsreci"));
                e.setCosto(rs.getDouble("costo"));
                lista.add(e);
            }

        } catch (Exception e) {
            System.out.println("Error en listarPorUsuario: " + e.getMessage());
        }

        return lista;
    }

    
    public boolean eliminarPorId(int idehome) {
        String sql = "DELETE FROM ehome WHERE idehome = ?";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idehome);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error al eliminar encuesta: " + e.getMessage());
            return false;
        }
    }
    public List<modeloEhome> obtenerMaximoPlanPorOperadora(String region, Date desde, Date hasta, double costoMin, double costoMax) {
    List<modeloEhome> lista = new ArrayList<>();
    String sql = "SELECT operadora, MAX(plan) AS max_plan, costo " +
                 "FROM ehome WHERE region = ? AND fecha BETWEEN ? AND ? AND costo BETWEEN ? AND ? " +
                 "GROUP BY operadora";

    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, region);
        ps.setDate(2, desde);
        ps.setDate(3, hasta);
        ps.setDouble(4, costoMin);
        ps.setDouble(5, costoMax);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            modeloEhome e = new modeloEhome();
            e.setOperadora(rs.getString("operadora"));
            e.setPlan(rs.getDouble("max_plan"));
            lista.add(e);
        }

    } catch (Exception e) {
        System.out.println("Error en obtenerMaximoPlanPorOperadora: " + e.getMessage());
    }

    return lista;
}


}