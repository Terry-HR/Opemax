package Controlador;

import DAO.ReporteDAO;
import DAO.UsuarioDAO;
import Modelo.modeloReporte;
import Modelo.modeloUsuario;
import Controlador.GeneradorPDF;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ControladorReporte")
public class ControladorReporte extends HttpServlet{
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String accion = request.getParameter("accion");
    ReporteDAO reporteDAO = new ReporteDAO();
    UsuarioDAO usuarioDAO = new UsuarioDAO();

    if ("verDetalle".equals(accion)) {
        int id = Integer.parseInt(request.getParameter("idreporte"));
        modeloReporte reporte = reporteDAO.obtenerPorId(id);
        modeloUsuario usuario = usuarioDAO.obtenerUsuarioPorId(reporte.getIdusuario());

        request.setAttribute("reporteSeleccionado", reporte);
        request.setAttribute("usuarioSeleccionado", usuario);
        request.getRequestDispatcher("reclamosPendientes.jsp").forward(request, response);

} else if ("actualizarEstado".equals(accion)) {
    int id = Integer.parseInt(request.getParameter("idreporte"));
    reporteDAO.actualizarEstado(id, 2); // Cambiar a estado 2

    // Redirige a la página para actualizar la tabla
    response.sendRedirect("reclamosPendientes.jsp");

} else if ("generarPDF".equals(accion)) {
    int id = Integer.parseInt(request.getParameter("idreporte"));
    modeloReporte reporte = reporteDAO.obtenerPorId(id);
    modeloUsuario usuario = usuarioDAO.obtenerUsuarioPorId(reporte.getIdusuario());

    // Genera el PDF directamente
    GeneradorPDF.generarPDF(reporte, usuario, getServletContext().getRealPath("/imagenes/pc.png"), response);
}

}

}
