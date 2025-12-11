package Controlador;

import DAO.SenalDAO;
import Modelo.modeloSenal;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "SenalServlet", urlPatterns = {"/SenalServlet"})
public class SenalServlet extends HttpServlet {

    private final SenalDAO senalDAO = new SenalDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion") != null ? request.getParameter("accion") : "listar";
        
        try {
            switch (accion) {
                case "listar":
                    listarRegistros(request, response);
                    break;
                case "calcular":
                    calcularEstadisticas(request, response);
                    break;
                case "agregar":
                    agregarRegistro(request, response);
                    break;
                default:
                    listarRegistros(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Error: " + e.getMessage());
            listarRegistros(request, response);
        }
    }

    private void listarRegistros(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<modeloSenal> registros = senalDAO.obtenerTodos();
        request.setAttribute("registros", registros);
        request.getRequestDispatcher("senal.jsp").forward(request, response);
    }

    private void calcularEstadisticas(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String servicio = request.getParameter("servicio");
    
    try {
        // Obtener todos los registros del servicio seleccionado
        List<modeloSenal> registros = senalDAO.obtenerPorServicio(servicio);
        
        // Reiniciar contadores
        int buena = 0, regular = 0, mala = 0;
        
        // Contar correctamente según la calidad de señal
        for (modeloSenal registro : registros) {
            String calidad = registro.getCalidadSenal();
            if (calidad != null) {
                switch(calidad) {
                    case "Buena": buena++; break;
                    case "Regular": regular++; break;
                    case "Mala": mala++; break;
                }
            }
        }
        
        // Pasar datos a la vista
        request.setAttribute("buena", buena);
        request.setAttribute("regular", regular);
        request.setAttribute("mala", mala);
        request.setAttribute("servicioSeleccionado", servicio);
        
    } catch (Exception e) {
        request.setAttribute("mensajeError", "Error al calcular estadísticas: " + e.getMessage());
        e.printStackTrace();
    }
    listarRegistros(request, response);
}
   
    private void agregarRegistro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            modeloSenal senal = new modeloSenal();
            senal.setIdUsuario(Integer.parseInt(request.getParameter("idUsuario")));
            senal.setServicio(request.getParameter("servicio"));
            senal.setEmpresa(request.getParameter("empresa"));
            senal.setRegion(request.getParameter("region"));
            senal.setValoracion(Integer.parseInt(request.getParameter("valoracion")));
            senal.setFecha(LocalDateTime.now());
            
            if (senalDAO.insertar(senal)) {
                request.setAttribute("mensajeExito", "Reporte agregado correctamente");
            } else {
                request.setAttribute("mensajeError", "No se pudo guardar el reporte");
            }
        } catch (Exception e) {
            request.setAttribute("mensajeError", "Error: " + e.getMessage());
        }
        listarRegistros(request, response);
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