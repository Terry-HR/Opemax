package Controlador;

import DAO.UsuarioDAO;
import Modelo.modeloUsuario;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    UsuarioDAO dao = new UsuarioDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        if (correo == null || correo.isEmpty() || contrasena == null || contrasena.isEmpty()) {
            request.setAttribute("mensaje", "Todos los campos son obligatorios.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        modeloUsuario usuario = dao.validarLogin(correo, contrasena);

        if (usuario == null) {
            request.setAttribute("mensaje", "Correo o contraseña incorrectos.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        } else if (usuario.getEstado() == 0) {
            request.setAttribute("mensaje", "Cuenta suspendida.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            if ("ADMIN".equalsIgnoreCase(usuario.getRol())) {
                response.sendRedirect("DashboardAdmin");
            } else {
                response.sendRedirect("inicio.jsp");
            }
        }
    }
}