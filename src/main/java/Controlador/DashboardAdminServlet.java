
package Controlador;

import DAO.ReporteDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DashboardAdmin")
public class DashboardAdminServlet extends HttpServlet {
    private ReporteDAO dao = new ReporteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int pendientes = dao.contarPorEstadoGlobal(1);
        int enProceso = dao.contarPorEstadoGlobal(2);
        int finalizados = dao.contarPorEstadoGlobal(3);
        int finalizadosMismoDia = dao.contarFinalizadosMismoDia();

        req.setAttribute("pendientes", pendientes);
        req.setAttribute("enProceso", enProceso);
        req.setAttribute("finalizados", finalizados);
        req.setAttribute("finalizadosHoy", finalizadosMismoDia);

        req.getRequestDispatcher("Admin.jsp").forward(req, resp);
    }
}
