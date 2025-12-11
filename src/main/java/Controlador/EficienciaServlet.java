package Controlador;

import DAO.EficienciaDAO;
import Modelo.modeloEficiencia;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "EficienciaServlet", urlPatterns = {"/EficienciaServlet"})
public class EficienciaServlet extends HttpServlet {

    private EficienciaDAO eficienciaDAO = new EficienciaDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "listar":
                listarIncidentes(request, response);
                break;
            case "calcularEficiencia":
                calcularEficiencia(request, response);
                break;
            case "reportarIncidente":
                reportarIncidente(request, response);
                break;
            case "resolverIncidente":
                resolverIncidente(request, response);
                break;
            default:
                listarIncidentes(request, response);
                break;
        }
    }

    private void listarIncidentes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<modeloEficiencia> incidentes = eficienciaDAO.obtenerTodosLosIncidentes();
        request.setAttribute("incidentes", incidentes);
        request.getRequestDispatcher("Eficiencia.jsp").forward(request, response);
    }

    private void calcularEficiencia(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String inicioStr = request.getParameter("fechaInicio");
        String finStr = request.getParameter("fechaFin");

        try {
            LocalDateTime fechaInicioPeriodo = LocalDateTime.parse(inicioStr + "T00:00:00");
            LocalDateTime fechaFinPeriodo = LocalDateTime.parse(finStr + "T23:59:59");

            int totalIncidentes = eficienciaDAO.contarTotalIncidentesEnPeriodo(fechaInicioPeriodo, fechaFinPeriodo);
            List<modeloEficiencia> incidentesResueltos = eficienciaDAO.obtenerIncidentesResueltosEnMenosDe24Horas(fechaInicioPeriodo, fechaFinPeriodo);
            int resueltosEn24Horas = incidentesResueltos.size();

            double porcentajeEficiencia = totalIncidentes > 0 ? 
                ((double) resueltosEn24Horas / totalIncidentes) * 100 : 0;

            request.setAttribute("totalIncidentes", totalIncidentes);
            request.setAttribute("resueltosEn24Horas", resueltosEn24Horas);
            request.setAttribute("porcentajeEficiencia", String.format("%.2f", porcentajeEficiencia));
            request.setAttribute("fechaInicioCalculo", inicioStr);
            request.setAttribute("fechaFinCalculo", finStr);

        } catch (Exception e) {
            request.setAttribute("mensajeError", "Error al calcular: " + e.getMessage());
        }
        listarIncidentes(request, response);
    }

    private void reportarIncidente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String descripcion = request.getParameter("descripcion");

            modeloEficiencia nuevoIncidente = new modeloEficiencia();
            nuevoIncidente.setIdUsuario(idUsuario);
            nuevoIncidente.setDescripcion(descripcion);

            if (eficienciaDAO.insertarIncidente(nuevoIncidente)) {
                request.setAttribute("mensajeExito", "Incidente reportado exitosamente.");
            } else {
                request.setAttribute("mensajeError", "Error al reportar el incidente.");
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Error: " + e.getMessage());
        }
        listarIncidentes(request, response);
    }

    private void resolverIncidente(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int idIncidente = Integer.parseInt(request.getParameter("idIncidente"));
            
            modeloEficiencia incidente = new modeloEficiencia();
            incidente.setIdIncidente(idIncidente);
            
            if (eficienciaDAO.actualizarIncidente(incidente)) {
                request.setAttribute("mensajeExito", "Incidente marcado como resuelto.");
            } else {
                request.setAttribute("mensajeError", "Error al resolver el incidente.");
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Error: " + e.getMessage());
        }
        listarIncidentes(request, response);
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

    @Override
    public String getServletInfo() {
        return "Servlet para gestión de eficiencia en atención de incidentes";
    }
}
