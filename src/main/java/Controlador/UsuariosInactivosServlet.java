package Controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import DAO.UsuarioDAO;
import Modelo.modeloUsuario;
import java.util.List;
@WebServlet("/UsuariosInactivosServlet")
public class UsuariosInactivosServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if ("activar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            usuarioDAO.activarUsuario(id); // este método lo veremos luego si falta
            response.sendRedirect("UsuariosInactivosServlet");
        } else {
            List<modeloUsuario> lista = usuarioDAO.obtenerUsuariosInactivos();
            request.setAttribute("listaInactivos", lista);
            request.getRequestDispatcher("usuariosInactivos.jsp").forward(request, response);
        }
    }
}
