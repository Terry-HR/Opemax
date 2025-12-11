package Controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import DAO.ValoracionDAO;
import Modelo.modeloValoracion;
import Modelo.modeloUsuario;

@WebServlet("/VotarServlet")
public class VotarServlet extends HttpServlet {
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
        String operadora = request.getParameter("operadora");
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

        ValoracionDAO dao = new ValoracionDAO();

        if (dao.yaVoto(idUsuario, operadora)) {
            response.sendRedirect("inicio.jsp?error=YaVotaste");
            return;
        }

        modeloValoracion voto = new modeloValoracion();
        voto.setIdusuario(idUsuario);
        voto.setOperadora(operadora);
        voto.setValoracion(valoracion);
        
        // Registrar el voto con el estado calculado
        if (dao.registrarVoto(voto, estado)) {
            response.sendRedirect("inicio.jsp?success=Gracias");
        } else {
            response.sendRedirect("inicio.jsp?error=ErrorVoto");
        }
    }
}
