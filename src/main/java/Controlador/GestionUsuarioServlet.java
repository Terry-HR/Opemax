package Controlador;

import DAO.UsuarioDAO;
import Modelo.modeloUsuario;
import javax.servlet.*;

import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import javax.servlet.annotation.WebServlet;
@WebServlet("/GestionUsuarioServlet")
public class GestionUsuarioServlet extends HttpServlet {

    UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<modeloUsuario> lista = dao.obtenerUsuariosActivos();
        request.setAttribute("usuarios", lista);
        RequestDispatcher dispatcher = request.getRequestDispatcher("usuarios.jsp");
        dispatcher.forward(request, response);
      
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if ("modificar".equals(accion)) {
            modeloUsuario u = new modeloUsuario();
            u.setIdusuario(Integer.parseInt(request.getParameter("idusuario")));
            u.setDni(Integer.parseInt(request.getParameter("dni")));
            u.setNombre(request.getParameter("nombre"));
            u.setApellido(request.getParameter("apellido"));
            u.setCorreo(request.getParameter("correo"));
            u.setRol(request.getParameter("rol"));
            dao.actualizarUsuario(u);
        } else if ("inactivar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("idusuario"));
            dao.inactivarUsuario(id);
        }

        response.sendRedirect("GestionUsuarioServlet");


    }
    
}
