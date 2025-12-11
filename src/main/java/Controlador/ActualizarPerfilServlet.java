package Controlador;

import DAO.UsuarioDAO;
import Modelo.modeloUsuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ActualizarPerfilServlet")
public class ActualizarPerfilServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int idusuario = Integer.parseInt(request.getParameter("idusuario"));
        String nuevoCorreo = request.getParameter("correo");
        String contrasenaActual = request.getParameter("contrasenaActual");
        String nuevaContrasena = request.getParameter("nuevaContrasena");

        HttpSession session = request.getSession();
        modeloUsuario usuario = (modeloUsuario) session.getAttribute("usuario");

        UsuarioDAO dao = new UsuarioDAO();

        if (nuevaContrasena != null && !nuevaContrasena.trim().isEmpty()) {
            if (!usuario.getContrasena().equals(contrasenaActual)) {
                response.sendRedirect("Perfil.jsp?error=contrasena");
                return;
            }
            dao.actualizarCorreoContrasena(idusuario, nuevoCorreo, nuevaContrasena);
            usuario.setContrasena(nuevaContrasena);
        } else {
            dao.actualizarSoloCorreo(idusuario, nuevoCorreo);
        }

        usuario.setCorreo(nuevoCorreo);
        session.setAttribute("usuario", usuario);
        response.sendRedirect("Perfil.jsp?success=true");
    }
}
