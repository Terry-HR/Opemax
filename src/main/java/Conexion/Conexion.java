package Conexion;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    Connection con;
    static String url = "jdbc:mysql://35.225.253.206:3306/OpeMax_BD";
    static String user = "elrooteano";
    static String pass = "L&S+*TXcc8Z3nFa8";

    public Connection Conectar() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Error de Conexion a Base de Datos : " + e);
        }
        return con;

    }

    public static Connection ConectarDB() {
        Connection conex = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conex = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Error de Conexion a Base de Datos : " + e);
        }
        return conex;

    }
}
