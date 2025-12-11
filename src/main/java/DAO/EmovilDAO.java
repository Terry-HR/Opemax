package DAO;

import Conexion.Conexion;
import Modelo.modeloEmovil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmovilDAO {

    // Registrar nueva encuesta
    public boolean registrarEmovil(modeloEmovil e) {
        String sql = "INSERT INTO emovil (idusuario, fecha, operadora, region, plan, mbsreci, costo) VALUES (?, ?, ?, ?, ?, ?, ?)";
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

    // Total encuestas (general)
    public static int getTotalEncuestas() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM emovil";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error en getTotalEncuestas (emovil): " + e.getMessage());
        }
        return total;
    }

    // Total por usuario
    public static int getTotalPorUsuario(int idusuario) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM emovil WHERE idusuario = ?";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idusuario);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Error en getTotalPorUsuario (emovil): " + e.getMessage());
        }
        return total;
    }

    // ✅ NUEVO: Listar encuestas por usuario
    public List<modeloEmovil> listarPorUsuario(int idusuario) {
        List<modeloEmovil> lista = new ArrayList<>();
        String sql = "SELECT * FROM emovil WHERE idusuario = ? ORDER BY fecha DESC";

        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idusuario);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                modeloEmovil e = new modeloEmovil();
                e.setIdemovil(rs.getInt("idemovil"));
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

    // ✅ NUEVO: Eliminar encuesta por ID
    public boolean eliminarPorId(int idemovil) {
        String sql = "DELETE FROM emovil WHERE idemovil = ?";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idemovil);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error al eliminar encuesta: " + e.getMessage());
            return false;
        }
    }
        
public List<modeloEmovil> obtenerMaximoPlanPorOperadora(String region, Date desde, Date hasta, double costoMin, double costoMax) {
    List<modeloEmovil> lista = new ArrayList<>();
    String sql = "SELECT operadora, MAX(plan) as plan_max " +
             "FROM emovil " +
             "WHERE region = ? AND fecha BETWEEN ? AND ? AND costo BETWEEN ? AND ? " +
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
            modeloEmovil e = new modeloEmovil();
            e.setOperadora(rs.getString("operadora"));
            e.setPlan(rs.getDouble("plan_max"));
            lista.add(e);
        }

    } catch (Exception e) {
        System.out.println("Error en obtenerMaximoPlanPorOperadora: " + e.getMessage());
    }

    return lista;
}


}
