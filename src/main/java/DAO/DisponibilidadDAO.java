package DAO;

import Modelo.modeloDisponibilidad;
import Conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class DisponibilidadDAO {

    public List<modeloDisponibilidad> obtenerTodasLasDisponibilidades() {
        List<modeloDisponibilidad> disponibilidades = new ArrayList<>();
        String sql = "SELECT iddisponibilidad, inicio, fin, estado FROM disponibilidad ORDER BY inicio ASC";

        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                modeloDisponibilidad disp = new modeloDisponibilidad();
                disp.setIdDisponibilidad(rs.getInt("iddisponibilidad"));
                disp.setInicio(rs.getTimestamp("inicio").toLocalDateTime());
                disp.setFin(rs.getTimestamp("fin").toLocalDateTime());
                disp.setEstado(rs.getString("estado"));
                disponibilidades.add(disp);
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener disponibilidades: " + e.getMessage());
            e.printStackTrace();
        }
        return disponibilidades;
    }

    public boolean insertarDisponibilidad(modeloDisponibilidad disp) {
        String sql = "INSERT INTO disponibilidad (inicio, fin, estado) VALUES (?, ?, ?)";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(disp.getInicio()));
            ps.setTimestamp(2, Timestamp.valueOf(disp.getFin()));
            ps.setString(3, disp.getEstado());

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (SQLException e) {
            System.err.println("Error al insertar disponibilidad: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<modeloDisponibilidad> obtenerDisponibilidadPorRango(
            LocalDateTime fechaInicio, LocalDateTime fechaFin) {
        List<modeloDisponibilidad> disponibilidades = new ArrayList<>();
        String sql = "SELECT iddisponibilidad, inicio, fin, estado FROM disponibilidad " +
                     "WHERE inicio >= ? AND fin <= ? ORDER BY inicio ASC";

        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setTimestamp(1, Timestamp.valueOf(fechaInicio));
            ps.setTimestamp(2, Timestamp.valueOf(fechaFin));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    modeloDisponibilidad disp = new modeloDisponibilidad();
                    disp.setIdDisponibilidad(rs.getInt("iddisponibilidad"));
                    disp.setInicio(rs.getTimestamp("inicio").toLocalDateTime());
                    disp.setFin(rs.getTimestamp("fin").toLocalDateTime());
                    disp.setEstado(rs.getString("estado"));
                    disponibilidades.add(disp);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener disponibilidad por rango: " + e.getMessage());
            e.printStackTrace();
        }
        return disponibilidades;
    }
}
