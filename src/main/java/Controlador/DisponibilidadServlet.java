package Controlador;

import DAO.DisponibilidadDAO;
import Modelo.modeloDisponibilidad;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.Duration;

@WebServlet(name = "DisponibilidadServlet", urlPatterns = {"/DisponibilidadServlet"})
public class DisponibilidadServlet extends HttpServlet {

    private DisponibilidadDAO disponibilidadDAO = new DisponibilidadDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "listar":
                listarDisponibilidades(request, response);
                break;
            case "calcularDisponibilidad":
                calcularDisponibilidad(request, response);
                break;
            case "agregarDisponibilidad":
                agregarDisponibilidad(request, response);
                break;
            default:
                listarDisponibilidades(request, response);
                break;
        }
    }

    private void listarDisponibilidades(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<modeloDisponibilidad> disponibilidades = disponibilidadDAO.obtenerTodasLasDisponibilidades();
        request.setAttribute("disponibilidades", disponibilidades);
        request.getRequestDispatcher("Disponibilidad.jsp").forward(request, response);
    }

    private void calcularDisponibilidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String inicioStr = request.getParameter("fechaInicio");
        String finStr = request.getParameter("fechaFin");

        try {
            LocalDateTime fechaInicioPeriodo = LocalDateTime.parse(inicioStr + "T00:00:00");
            LocalDateTime fechaFinPeriodo = LocalDateTime.parse(finStr + "T23:59:59");

            List<modeloDisponibilidad> periodos = disponibilidadDAO.obtenerDisponibilidadPorRango(
                fechaInicioPeriodo, fechaFinPeriodo);

            Duration totalTiempo = Duration.ZERO;
            Duration tiempoInactividad = Duration.ZERO;

            for (modeloDisponibilidad p : periodos) {
                Duration duracionPeriodo = Duration.between(p.getInicio(), p.getFin());
                totalTiempo = totalTiempo.plus(duracionPeriodo);
                if ("Inactivo".equalsIgnoreCase(p.getEstado())) {
                    tiempoInactividad = tiempoInactividad.plus(duracionPeriodo);
                }
            }

            long totalMinutos = totalTiempo.toMinutes();
            long inactividadMinutos = tiempoInactividad.toMinutes();
            double porcentajeDisponibilidad = totalMinutos > 0 ? 
                ((double) (totalMinutos - inactividadMinutos) / totalMinutos) * 100 : 0;

            request.setAttribute("totalMinutos", totalMinutos);
            request.setAttribute("inactividadMinutos", inactividadMinutos);
            request.setAttribute("porcentajeDisponibilidad", String.format("%.2f", porcentajeDisponibilidad));
            request.setAttribute("fechaInicioCalculo", inicioStr);
            request.setAttribute("fechaFinCalculo", finStr);

        } catch (Exception e) {
            request.setAttribute("mensajeError", "Error al calcular: " + e.getMessage());
        }
        listarDisponibilidades(request, response);
    }

    private void agregarDisponibilidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            LocalDateTime inicio = LocalDateTime.parse(request.getParameter("inicio"));
            LocalDateTime fin = LocalDateTime.parse(request.getParameter("fin"));
            String estado = "true".equals(request.getParameter("activo")) ? "Activo" : "Inactivo";

            modeloDisponibilidad nueva = new modeloDisponibilidad();
            nueva.setInicio(inicio);
            nueva.setFin(fin);
            nueva.setEstado(estado);

            if (disponibilidadDAO.insertarDisponibilidad(nueva)) {
                request.setAttribute("mensajeExito", "Registro agregado exitosamente");
            } else {
                request.setAttribute("mensajeError", "Error al agregar registro");
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Error: " + e.getMessage());
        }
        listarDisponibilidades(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
