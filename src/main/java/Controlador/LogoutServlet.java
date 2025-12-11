package Controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener la sesión, si existe
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();   // Invalida la sesión
        }
        // Redirigir a la página de login
        response.sendRedirect(request.getContextPath() + "/Login.jsp");
    }

    // También permitir logout vía POST si lo prefieres:
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
