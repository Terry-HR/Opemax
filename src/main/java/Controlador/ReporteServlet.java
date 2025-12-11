package Controlador;

import DAO.ReporteDAO;
import Modelo.modeloReporte;
import Modelo.modeloUsuario;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ReporteServlet")
public class ReporteServlet extends HttpServlet {

    ReporteDAO dao = new ReporteDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        modeloUsuario usuario = (modeloUsuario) request.getSession().getAttribute("usuario");

        // Verificar si es una solicitud de PDF
        String action = request.getParameter("action");
        if ("generarPDFTodos".equals(action)) {
            generarPDFTodosReportes(usuario, response);
            return;
        }

        boolean exito = false;
        if (usuario != null) {
            String servicio = request.getParameter("servicio");
            String empresa = request.getParameter("empresa");
            String reclamo = request.getParameter("reclamo");

            modeloReporte r = new modeloReporte();
            r.setIdusuario(usuario.getIdusuario());
            r.setServicio(servicio);
            r.setEmpresa(empresa);
            r.setReclamo(reclamo);

            exito = dao.insertarReporte(r);
        }

        request.setAttribute("mensaje", exito ? "ok" : "error");
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        modeloUsuario usuario = (modeloUsuario) request.getSession().getAttribute("usuario");

        // Verificar si es una solicitud de PDF desde GET
        String action = request.getParameter("action");
        if ("generarPDFTodos".equals(action)) {
            generarPDFTodosReportes(usuario, response);
            return;
        }

        if (usuario != null) {
            List<modeloReporte> reportes = dao.listarPorUsuario(usuario.getIdusuario());
            int pendientes = dao.contarPorEstado(usuario.getIdusuario(), 1);
            int enProceso = dao.contarPorEstado(usuario.getIdusuario(), 2);
            int finalizados = dao.contarPorEstado(usuario.getIdusuario(), 3);

            request.setAttribute("reportes", reportes);
            request.setAttribute("pendientes", pendientes);
            request.setAttribute("enProceso", enProceso);
            request.setAttribute("finalizados", finalizados);

            request.getRequestDispatcher("reportes.jsp").forward(request, response);
        } else {
            response.sendRedirect("Login.jsp");
        }
    }

    private void generarPDFTodosReportes(modeloUsuario usuario, HttpServletResponse response) {
        System.out.println("=== INICIANDO GENERACIÓN PDF ===");
        
        if (usuario != null) {
            List<modeloReporte> reportes = dao.listarPorUsuario(usuario.getIdusuario());
            System.out.println("Número de reportes encontrados: " + (reportes != null ? reportes.size() : 0));
            
            // Ruta de la imagen - ajusta según tu estructura de proyecto
            String rutaImagen = getServletContext().getRealPath("/img/logo.png");
            System.out.println("Ruta de imagen: " + rutaImagen);
            
            // Si no existe la imagen, mostrar mensaje pero continuar
            if (rutaImagen == null || !new java.io.File(rutaImagen).exists()) {
                System.out.println("Logo no encontrado en: " + rutaImagen);
            } else {
                System.out.println("Logo encontrado");
            }
            
            try {
                // Limpiar response antes de generar PDF
                response.reset();
                GeneradorPDF.generarPDFTodosReportes(reportes, usuario, rutaImagen, response);
                System.out.println("PDF generado exitosamente");
                return; // Importante: salir después de generar el PDF
            } catch (Exception e) {
                System.out.println("Error al generar PDF: " + e.getMessage());
                e.printStackTrace();
                
                // Redirigir a la página de reportes con mensaje de error
                try {
                    response.sendRedirect("ReporteServlet?mensaje=errorPDF");
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
        } else {
            System.out.println("Usuario es NULL");
            try {
                response.sendRedirect("Login.jsp");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        System.out.println("=== FIN GENERACIÓN PDF ===");
    }
}