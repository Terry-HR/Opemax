package DAO;

import Conexion.Conexion;
import Modelo.modeloReporte;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReporteDAO {

    public boolean insertarReporte(modeloReporte r) {
        String sql = "INSERT INTO reportes (idusuario, servicio, empresa, reclamo, fecha_ing, estado) VALUES (?, ?, ?, ?, CURDATE(), 1)";
        try (Connection con = Conexion.ConectarDB(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, r.getIdusuario());
            ps.setString(2, r.getServicio());
            ps.setString(3, r.getEmpresa());
            ps.setString(4, r.getReclamo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error al insertar reporte: " + e.getMessage());
        }
        return false;
    }

    public List<modeloReporte> listarPorUsuario(int idusuario) {
        List<modeloReporte> lista = new ArrayList<>();
        String sql = "SELECT * FROM reportes WHERE idusuario = ? ORDER BY fecha_ing DESC";

        try (Connection con = Conexion.ConectarDB(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idusuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                modeloReporte r = new modeloReporte();
                r.setIdreporte(rs.getInt("idreporte"));
                r.setIdusuario(rs.getInt("idusuario"));
                r.setServicio(rs.getString("servicio"));
                r.setEmpresa(rs.getString("empresa"));
                r.setReclamo(rs.getString("reclamo"));
                r.setFecha_ing(rs.getString("fecha_ing"));
                r.setFecha_fin(rs.getString("fecha_fin"));
                r.setEstado(rs.getInt("estado"));
                lista.add(r);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar reportes: " + e.getMessage());
        }

        return lista;
    }

    public int contarPorEstado(int idusuario, int estado) {
        String sql = "SELECT COUNT(*) FROM reportes WHERE idusuario = ? AND estado = ?";
        try (Connection con = Conexion.ConectarDB(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idusuario);
            ps.setInt(2, estado);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("Error al contar reportes: " + e.getMessage());
        }
        return 0;
    }
    public boolean cambiarEstado(int idreporte, int nuevoEstado) {
    String sql = "UPDATE reportes SET estado = ? WHERE idreporte = ?";
    try (Connection con = Conexion.ConectarDB(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, nuevoEstado);
        ps.setInt(2, idreporte);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
public modeloReporte obtenerPorId(int idreporte) {
    modeloReporte r = null;
    String sql = "SELECT * FROM reportes WHERE idreporte = ?";
    try (Connection con = Conexion.ConectarDB(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idreporte);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            r = new modeloReporte(
                rs.getInt("idreporte"),
                rs.getInt("idusuario"),
                rs.getString("servicio"),
                rs.getString("empresa"),
                rs.getString("reclamo"),
                rs.getString("fecha_ing"),
                rs.getString("fecha_fin"),
                rs.getInt("estado")
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return r;
}

public boolean actualizarEstado(int idreporte, int nuevoEstado) {
    String sql = "UPDATE reportes SET estado = ? WHERE idreporte = ?";
    try (Connection con = Conexion.ConectarDB(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, nuevoEstado);
        ps.setInt(2, idreporte);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

public List<modeloReporte> listarPorEstado(int estado) {
    List<modeloReporte> lista = new ArrayList<>();
    String sql = "SELECT * FROM reportes WHERE estado = ?";
    try (Connection con = Conexion.ConectarDB(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, estado);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            modeloReporte r = new modeloReporte(
                rs.getInt("idreporte"),
                rs.getInt("idusuario"),
                rs.getString("servicio"),
                rs.getString("empresa"),
                rs.getString("reclamo"),
                rs.getString("fecha_ing"),
                rs.getString("fecha_fin"),
                rs.getInt("estado")
            );
            lista.add(r);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return lista;
}
public List<modeloReporte> listarEnProceso() {
    List<modeloReporte> lista = new ArrayList<>();
    String sql = "SELECT * FROM reportes WHERE estado = 2 ORDER BY fecha_ing DESC";

    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            modeloReporte r = new modeloReporte();
            r.setIdreporte(rs.getInt("idreporte"));
            r.setIdusuario(rs.getInt("idusuario"));
            r.setServicio(rs.getString("servicio"));
            r.setEmpresa(rs.getString("empresa"));
            r.setReclamo(rs.getString("reclamo"));
            r.setFecha_ing(rs.getString("fecha_ing"));
            r.setFecha_fin(rs.getString("fecha_fin"));
            r.setEstado(rs.getInt("estado"));
            lista.add(r);
        }

    } catch (SQLException e) {
        System.out.println("Error al listar reportes en proceso: " + e.getMessage());
    }

    return lista;
}
public boolean finalizarReporte(int idreporte) {
    String sql = "UPDATE reportes SET estado = 3, fecha_fin = CURDATE() WHERE idreporte = ?";
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idreporte);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        System.out.println("Error al finalizar reporte: " + e.getMessage());
    }
    return false;
}
// Total por estado (sin filtrar por usuario)
public int contarPorEstadoGlobal(int estado) {
    String sql = "SELECT COUNT(*) FROM reportes WHERE estado = ?";
    try (Connection con = Conexion.ConectarDB(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, estado);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

// Reportes finalizados el mismo día que ingresaron
public int contarFinalizadosMismoDia() {
    String sql = "SELECT COUNT(*) FROM reportes WHERE estado = 3 AND fecha_ing = fecha_fin";
    try (Connection con = Conexion.ConectarDB(); PreparedStatement ps = con.prepareStatement(sql)) {
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

}
