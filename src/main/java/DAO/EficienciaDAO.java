package DAO;

import Modelo.modeloEficiencia;
import Conexion.Conexion;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class EficienciaDAO {

    public List<modeloEficiencia> obtenerTodosLosIncidentes() {
        List<modeloEficiencia> incidentes = new ArrayList<>();
        String sql = "SELECT idincidente, idusuario, descripcion, fecha_apertura, fecha_resolucion, estado FROM incidentes ORDER BY fecha_apertura ASC";

        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                modeloEficiencia inc = new modeloEficiencia();
                inc.setIdIncidente(rs.getInt("idincidente"));
                inc.setIdUsuario(rs.getInt("idusuario"));
                inc.setDescripcion(rs.getString("descripcion"));
                inc.setFechaApertura(rs.getTimestamp("fecha_apertura").toLocalDateTime());
                
                Timestamp fechaResolucion = rs.getTimestamp("fecha_resolucion");
                if (fechaResolucion != null) {
                    inc.setFechaResolucion(fechaResolucion.toLocalDateTime());
                }
                
                inc.setEstado(rs.getString("estado"));
                incidentes.add(inc);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener incidentes: " + e.getMessage());
            e.printStackTrace();
        }
        return incidentes;
    }

    public boolean insertarIncidente(modeloEficiencia inc) {
        String sql = "INSERT INTO incidentes (idusuario, descripcion, fecha_apertura, estado) VALUES (?, ?, ?, 'Pendiente')";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, inc.getIdUsuario());
            ps.setString(2, inc.getDescripcion());
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));

            int filasAfectadas = ps.executeUpdate();
            
            if (filasAfectadas > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        inc.setIdIncidente(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Error al insertar incidente: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarIncidente(modeloEficiencia inc) {
        String sql = "UPDATE incidentes SET fecha_resolucion = ?, estado = 'Resuelto' WHERE idincidente = ?";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(2, inc.getIdIncidente());

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar incidente: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<modeloEficiencia> obtenerIncidentesResueltosEnMenosDe24Horas(
            LocalDateTime fechaInicioPeriodo, LocalDateTime fechaFinPeriodo) {
        List<modeloEficiencia> incidentesFiltrados = new ArrayList<>();
        String sql = "SELECT idincidente, idusuario, descripcion, fecha_apertura, fecha_resolucion, estado FROM incidentes " +
                     "WHERE estado = 'Resuelto' " +
                     "AND fecha_apertura >= ? AND fecha_apertura <= ? " +
                     "AND TIMESTAMPDIFF(HOUR, fecha_apertura, fecha_resolucion) < 24";

        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(fechaInicioPeriodo));
            ps.setTimestamp(2, Timestamp.valueOf(fechaFinPeriodo));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    modeloEficiencia inc = new modeloEficiencia();
                    inc.setIdIncidente(rs.getInt("idincidente"));
                    inc.setIdUsuario(rs.getInt("idusuario"));
                    inc.setDescripcion(rs.getString("descripcion"));
                    inc.setFechaApertura(rs.getTimestamp("fecha_apertura").toLocalDateTime());
                    inc.setFechaResolucion(rs.getTimestamp("fecha_resolucion").toLocalDateTime());
                    inc.setEstado(rs.getString("estado"));
                    incidentesFiltrados.add(inc);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener incidentes resueltos en < 24h: " + e.getMessage());
            e.printStackTrace();
        }
        return incidentesFiltrados;
    }

    public int contarTotalIncidentesEnPeriodo(LocalDateTime fechaInicioPeriodo, LocalDateTime fechaFinPeriodo) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM incidentes WHERE fecha_apertura >= ? AND fecha_apertura <= ?";

        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(fechaInicioPeriodo));
            ps.setTimestamp(2, Timestamp.valueOf(fechaFinPeriodo));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al contar total de incidentes: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }
}
