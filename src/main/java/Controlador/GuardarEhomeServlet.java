package Controlador;

import DAO.EhomeDAO;
import Modelo.modeloEhome;
import Modelo.modeloUsuario;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/GuardarEhomeServlet")
public class GuardarEhomeServlet extends HttpServlet {

    EhomeDAO dao = new EhomeDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        modeloUsuario usuario = (modeloUsuario) request.getSession().getAttribute("usuario");
        if (usuario == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        try {
            modeloEhome em = new modeloEhome();
            em.setIdusuario(usuario.getIdusuario());
            em.setFecha(Date.valueOf(LocalDate.now()));
            em.setOperadora(request.getParameter("operadora"));
            em.setRegion(request.getParameter("region"));
            em.setPlan(Double.parseDouble(request.getParameter("plan")));
            em.setMbsreci(Double.parseDouble(request.getParameter("mbsreci")));
            em.setCosto(Double.parseDouble(request.getParameter("costo")));

            boolean exito = dao.registrarEhome(em);

            if (exito) {
                request.setAttribute("mensaje", "Encuesta guardada correctamente.");
                request.setAttribute("tipo", "success");
            } else {
                request.setAttribute("mensaje", "Error al guardar encuesta.");
                request.setAttribute("tipo", "danger");
            }

        } catch (Exception e) {
            request.setAttribute("mensaje", "Error al procesar datos del formulario.");
            request.setAttribute("tipo", "danger");
        }

        request.getRequestDispatcher("Ehome.jsp").forward(request, response);
    }
}