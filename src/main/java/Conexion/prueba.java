package Conexion;

import java.sql.Connection;

public class prueba {
    public static void main(String[] args) {
        Conexion conexion = new Conexion();
        Connection con = conexion.ConectarDB();

        if (con != null) {
            System.out.println("✅ Conexión exitosa a la base de datos.");
        } else {
            System.out.println("❌ No se pudo conectar a la base de datos.");
        }
    }
}
