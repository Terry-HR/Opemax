package Controlador;

import DAO.EmovilDAO;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/EliminarEncuestaServlet")
public class EliminarEncuestaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idemovil = Integer.parseInt(request.getParameter("idemovil"));
        EmovilDAO dao = new EmovilDAO();
        dao.eliminarPorId(idemovil);

        response.sendRedirect("MisEncuestas.jsp");
    }
}
