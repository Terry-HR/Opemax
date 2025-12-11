package DAO;

import Conexion.Conexion;
import Modelo.modeloUsuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public modeloUsuario validarLogin(String correo, String contrasena) {
        modeloUsuario usuario = null;
        String sql = "SELECT * FROM usuario WHERE correo = ? AND contrasena = ?";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo);
            ps.setString(2, contrasena);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                usuario = new modeloUsuario();
                usuario.setIdusuario(rs.getInt("idusuario"));
                usuario.setDni(rs.getInt("dni"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setApellido(rs.getString("apellido"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setContrasena(rs.getString("contrasena"));
                usuario.setRol(rs.getString("rol"));
                usuario.setEstado(rs.getInt("estado"));
            }

        } catch (SQLException e) {
            System.out.println("Error en validarLogin: " + e.getMessage());
        }

        return usuario;
    }

    public boolean existeDni(int dni) {
        String sql = "SELECT dni FROM usuario WHERE dni = ?";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, dni);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.out.println("Error en existeDni: " + e.getMessage());
        }
        return false;
    }

    public boolean existeCorreo(String correo) {
        String sql = "SELECT correo FROM usuario WHERE correo = ?";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, correo);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            System.out.println("Error en existeCorreo: " + e.getMessage());
        }
        return false;
    }

    public boolean registrarUsuario(modeloUsuario usuario) {
        String sql = "INSERT INTO usuario (dni, nombre, apellido, correo, contrasena, rol, estado) VALUES (?, ?, ?, ?, ?, 'USER', 1)";
        try (Connection con = Conexion.ConectarDB();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuario.getDni());
            ps.setString(2, usuario.getNombre());
            ps.setString(3, usuario.getApellido());
            ps.setString(4, usuario.getCorreo());
            ps.setString(5, usuario.getContrasena());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error en registrarUsuario: " + e.getMessage());
        }
        return false;
    }
    public static int getCantidadUsuarios() {
    int total = 0;
    String sql = "SELECT COUNT(*) FROM usuario";
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            total = rs.getInt(1);
        }
    } catch (SQLException e) {
        System.out.println("Error en getCantidadUsuarios: " + e.getMessage());
    }
    return total;
}
 public boolean actualizarSoloCorreo(int idusuario, String correo) {
    String sql = "UPDATE usuario SET correo = ? WHERE idusuario = ?";
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, correo);
        ps.setInt(2, idusuario);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        System.out.println("Error en actualizarSoloCorreo: " + e.getMessage());
        return false;
    }
}

public boolean actualizarCorreoContrasena(int idusuario, String correo, String nuevaContrasena) {
    String sql = "UPDATE usuario SET correo = ?, contrasena = ? WHERE idusuario = ?";
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, correo);
        ps.setString(2, nuevaContrasena);
        ps.setInt(3, idusuario);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        System.out.println("Error en actualizarCorreoContrasena: " + e.getMessage());
        return false;
    }
}
  public modeloUsuario obtenerUsuarioPorId(int idusuario) {
    modeloUsuario u = null;
    String sql = "SELECT * FROM usuario WHERE idusuario = ?";

    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idusuario);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            u = new modeloUsuario();
            u.setIdusuario(rs.getInt("idusuario"));
            u.setDni(rs.getInt("dni"));
            u.setNombre(rs.getString("nombre"));
            u.setApellido(rs.getString("apellido"));
            u.setCorreo(rs.getString("correo"));
            u.setContrasena(rs.getString("contrasena"));
            u.setRol(rs.getString("rol"));
            u.setEstado(rs.getInt("estado"));
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return u;
}
  public List<modeloUsuario> obtenerUsuariosActivos() {
    List<modeloUsuario> lista = new ArrayList<>();
    String sql = "SELECT * FROM usuario WHERE estado = 1";

    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            modeloUsuario u = new modeloUsuario();
            u.setIdusuario(rs.getInt("idusuario"));
            u.setDni(rs.getInt("dni"));
            u.setNombre(rs.getString("nombre"));
            u.setApellido(rs.getString("apellido"));
            u.setCorreo(rs.getString("correo"));
            u.setRol(rs.getString("rol"));
            u.setEstado(rs.getInt("estado"));
            lista.add(u);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return lista;
}

public boolean actualizarUsuario(modeloUsuario usuario) {
    String sql = "UPDATE usuario SET dni = ?, nombre = ?, apellido = ?, correo = ?, rol = ? WHERE idusuario = ?";
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, usuario.getDni());
        ps.setString(2, usuario.getNombre());
        ps.setString(3, usuario.getApellido());
        ps.setString(4, usuario.getCorreo());
        ps.setString(5, usuario.getRol());
        ps.setInt(6, usuario.getIdusuario());

        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

public boolean inactivarUsuario(int idusuario) {
    String sql = "UPDATE usuario SET estado = 0 WHERE idusuario = ?";
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idusuario);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
public List<modeloUsuario> obtenerUsuariosInactivos() {
    List<modeloUsuario> lista = new ArrayList<>();
    String sql = "SELECT * FROM usuario WHERE estado = 0";

    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            modeloUsuario u = new modeloUsuario();
            u.setIdusuario(rs.getInt("idusuario"));
            u.setDni(rs.getInt("dni"));
            u.setNombre(rs.getString("nombre"));
            u.setApellido(rs.getString("apellido"));
            u.setCorreo(rs.getString("correo"));
            u.setRol(rs.getString("rol"));
            u.setEstado(rs.getInt("estado"));
            lista.add(u);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return lista;
}
public boolean activarUsuario(int idusuario) {
    String sql = "UPDATE usuario SET estado = 1 WHERE idusuario = ?";
    try (Connection con = Conexion.ConectarDB();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idusuario);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

}
