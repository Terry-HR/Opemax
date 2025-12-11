package DAO;

import Modelo.modeloSenal;
import Conexion.Conexion;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SenalDAO {
    
    
    public List<modeloSenal> obtenerTodos() {
        List<modeloSenal> registros = new ArrayList<>();
        String sql = "SELECT idsenal, idusuario, fecha, servicio, empresa, region, valoracion, calidad_senal FROM senal ORDER BY fecha DESC";
        
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                modeloSenal s = new modeloSenal();
                s.setIdSenal(rs.getInt("idsenal"));
                s.setIdUsuario(rs.getInt("idusuario"));
                s.setFecha(rs.getTimestamp("fecha").toLocalDateTime());
                s.setServicio(rs.getString("servicio"));
                s.setEmpresa(rs.getString("empresa"));
                s.setRegion(rs.getString("region"));
                s.setValoracion(rs.getInt("valoracion"));
                s.setCalidadSenal(rs.getString("calidad_senal"));
                registros.add(s);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener registros: " + e.getMessage());
        }
        return registros;
    }

    public boolean insertar(modeloSenal senal) throws SQLException {
        String sql = "INSERT INTO senal (idusuario, fecha, servicio, empresa, region, valoracion, calidad_senal) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, senal.getIdUsuario());
            ps.setTimestamp(2, Timestamp.valueOf(senal.getFecha()));
            ps.setString(3, senal.getServicio());
            ps.setString(4, senal.getEmpresa());
            ps.setString(5, senal.getRegion());
            ps.setInt(6, senal.getValoracion());
            ps.setString(7, senal.getCalidadSenal());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        senal.setIdSenal(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;
        }
    }

    public int contarPorCalidad(String servicio, String calidad) throws SQLException {
    String sql = "SELECT COUNT(*) FROM senal WHERE servicio = ? AND calidad_senal = ?";
    
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, servicio);
        ps.setString(2, calidad);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    }
    return 0;
}
    
    public List<modeloSenal> obtenerPorServicio(String servicio) throws SQLException {
    List<modeloSenal> registros = new ArrayList<>();
    String sql = "SELECT idsenal, idusuario, fecha, servicio, empresa, region, valoracion, calidad_senal " +
                 "FROM senal WHERE servicio = ? ORDER BY fecha DESC";
    
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {
        
        ps.setString(1, servicio);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                modeloSenal s = new modeloSenal();
                s.setIdSenal(rs.getInt("idsenal"));
                s.setIdUsuario(rs.getInt("idusuario"));
                s.setFecha(rs.getTimestamp("fecha").toLocalDateTime());
                s.setServicio(rs.getString("servicio"));
                s.setEmpresa(rs.getString("empresa"));
                s.setRegion(rs.getString("region"));
                s.setValoracion(rs.getInt("valoracion"));
                s.setCalidadSenal(rs.getString("calidad_senal")); // Asegúrate que esto se guarda correctamente
                registros.add(s);
            }
        }
    }
    return registros;
}
}
