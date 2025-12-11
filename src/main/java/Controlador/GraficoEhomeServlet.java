
package Controlador;

import DAO.EhomeDAO;
import Modelo.modeloEhome;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/GraficoEhomeServlet")
public class GraficoEhomeServlet extends HttpServlet {
    EhomeDAO dao = new EhomeDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String region = request.getParameter("region");
        String costoFiltro = request.getParameter("costoFiltro"); // ejemplo: "1", "2", "3"
        String desdeStr = request.getParameter("desde");
        String hastaStr = request.getParameter("hasta");

        double costoMin = 0, costoMax = 10000;
        switch (costoFiltro) {
            case "1": costoMax = 49.99; break;
            case "2": costoMin = 50; costoMax = 99.99; break;
            case "3": costoMin = 100; break;
        }

        Date desde = Date.valueOf(desdeStr);
        Date hasta = Date.valueOf(hastaStr);

        List<modeloEhome> datos = dao.obtenerMaximoPlanPorOperadora(region, desde, hasta, costoMin, costoMax);

        // Convertir a JSON
        StringBuilder json = new StringBuilder("[");
        for (modeloEhome e : datos) {
            json.append("{\"operadora\":\"").append(e.getOperadora()).append("\",")
                .append("\"plan\":").append(e.getPlan()).append("},");
              
        }
        if (json.length() > 1) json.setLength(json.length() - 1); // quitar última coma
        json.append("]");

        response.setContentType("application/json");
        response.getWriter().write(json.toString());
    }
    
}
