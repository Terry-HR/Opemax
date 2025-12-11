package Controlador;

import DAO.ReporteDAO;
import DAO.UsuarioDAO;
import Modelo.modeloReporte;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ControladorReclamosEnProceso")
public class ControladorReclamosEnProceso extends HttpServlet {

    ReporteDAO reporteDAO = new ReporteDAO();
    UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String accion = request.getParameter("accion");
        if ("finalizar".equals(accion)) {
            int idreporte = Integer.parseInt(request.getParameter("id"));
            reporteDAO.finalizarReporte(idreporte);
            response.sendRedirect("ControladorReclamosEnProceso");
            return;
        }

        // Mostrar tabla
        List<modeloReporte> reportes = reporteDAO.listarEnProceso();
        request.setAttribute("lista", reportes);
        request.getRequestDispatcher("vistaReclamosEnProceso.jsp").forward(request, response);
    }
}