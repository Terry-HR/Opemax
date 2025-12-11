package DAO;

import java.sql.*;
import Modelo.modeloValoraciond;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ValoraciondDAO {
    
    private int idvdistribuidor;
    private int idusuario;
    private String distribuidor;
    private int valoracion;

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/opemax_bd", "root", "");
    }

    public boolean yaVotod(int idusuario, String distribuidor) {
        String sql = "SELECT COUNT(*) FROM vdistribuidor WHERE idusuario = ? AND distribuidor = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idusuario);
            ps.setString(2, distribuidor);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean registrarVotod(modeloValoraciond v, String estado) {
    String sql = "INSERT INTO vdistribuidor (idusuario, distribuidor, valoracion, estado) VALUES (?, ?, ?, ?)";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, v.getIdusuario());
        ps.setString(2, v.getDistribuidor());
        ps.setInt(3, v.getValoracion());
        ps.setString(4, estado);

        int filasAfectadas = ps.executeUpdate();
        return filasAfectadas > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
    
    public Map<String, Double> getPromediosd() {
        Map<String, Double> map = new HashMap<>();
        String sql = "SELECT distribuidor, AVG(valoracion) as promediod FROM vdistribuidor GROUP BY distribuidor";
        try (Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("distribuidor"), rs.getDouble("promediod"));
            }
    
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<String, Boolean> getVotosPorUsuariod(int idusuario) {
        Map<String, Boolean> map = new HashMap<>();
        String sql = "SELECT distribuidor FROM vdistribuidor WHERE idusuario = ?";
        try (Connection con = getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idusuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("distribuidor"), true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<String, Integer> getEstadisticasEstado() {
    Map<String, Integer> stats = new HashMap<>();
    String sql = "SELECT valoracion FROM vdistribuidor";
    
    // Inicializar contadores
    int satisfecho = 0;
    int neutral = 0;
    int insatisfecho = 0;
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            int valoracion = rs.getInt("valoracion");
            if(valoracion >= 4) {
                satisfecho++;
            } else if(valoracion <= 2) {
                insatisfecho++;
            } else {
                neutral++;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    stats.put("Satisfecho", satisfecho);
    stats.put("Neutral", neutral);
    stats.put("Insatisfecho", insatisfecho);
    
    return stats;
}
    
    public List<Map<String, String>> getAllRegistros() {
    List<Map<String, String>> registros = new ArrayList<>();
    String sql = "SELECT u.nombre, u.apellido, v.distribuidor, v.valoracion " +
                 "FROM vdistribuidor v JOIN usuario u ON v.idusuario = u.idusuario";
    
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        
        while (rs.next()) {
            Map<String, String> registro = new HashMap<>();
            registro.put("usuario", rs.getString("apellido") + ", " + rs.getString("nombre"));
            registro.put("distribuidor", rs.getString("distribuidor"));
            registro.put("valoracion", String.valueOf(rs.getInt("valoracion")));
            
            // Calcular estado basado en valoración
            int valoracion = rs.getInt("valoracion");
            String estado;
            if(valoracion >= 4) {
                estado = "Satisfecho";
            } else if(valoracion <= 2) {
                estado = "Insatisfecho";
            } else {
                estado = "Neutral";
            }
            registro.put("estado", estado);
            
            registros.add(registro);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return registros;
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
