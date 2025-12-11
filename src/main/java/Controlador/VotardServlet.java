package Controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import DAO.ValoraciondDAO;
import Modelo.modeloValoraciond;
import Modelo.modeloUsuario;

@WebServlet("/VotardServlet")
public class VotardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        modeloUsuario usuario = (modeloUsuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        int idUsuario = usuario.getIdusuario();
        String distribuidor = request.getParameter("distribuidor");
        int valoracion = Integer.parseInt(request.getParameter("valoracion"));
        
        // Determinar el estado basado en la valoración
        String estado;
        if (valoracion >= 4) {
            estado = "Satisfecho";
        } else if (valoracion <= 2) {
            estado = "Insatisfecho";
        } else {
            estado = "Neutral";
        }

        ValoraciondDAO dao = new ValoraciondDAO();

        if (dao.yaVotod(idUsuario, distribuidor)) {
            response.sendRedirect("inicio.jsp?error=YaVotaste");
            return;
        }

        modeloValoraciond votod = new modeloValoraciond();
        votod.setIdusuario(idUsuario);
        votod.setDistribuidor(distribuidor);
        votod.setValoracion(valoracion);
        
        // Registrar el voto con el estado calculado
        if (dao.registrarVotod(votod, estado)) {
            response.sendRedirect("inicio.jsp?success=Gracias");
        } else {
            response.sendRedirect("inicio.jsp?error=ErrorVoto");
        }
    }
}
