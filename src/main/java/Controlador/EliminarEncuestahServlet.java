package Controlador;

import DAO.EhomeDAO;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/EliminarEncuestahServlet")
public class EliminarEncuestahServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idehome = Integer.parseInt(request.getParameter("idehome"));
        EhomeDAO dao = new EhomeDAO();
        dao.eliminarPorId(idehome);

        response.sendRedirect("MisEncuestas.jsp");
    }
}
