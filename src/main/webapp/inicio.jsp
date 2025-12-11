<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@page import="Modelo.modeloUsuario"%>
<%@page import="DAO.UsuarioDAO, DAO.EmovilDAO, DAO.EhomeDAO, DAO.ValoracionDAO,DAO.ValoraciondDAO"%>
<%@page import="java.util.Map"%>
<%@include file="Menu.jsp"%>

<%
    int totalUsuarios = UsuarioDAO.getCantidadUsuarios();
    int totalMovil = EmovilDAO.getTotalEncuestas();
    int totalHogar = EhomeDAO.getTotalEncuestas();
    int respuestasMovil = EmovilDAO.getTotalPorUsuario(usuario.getIdusuario());
    int respuestasHogar = EhomeDAO.getTotalPorUsuario(usuario.getIdusuario());
    int totalUsuario = respuestasMovil + respuestasHogar;

    ValoracionDAO vdao = new ValoracionDAO();
    Map<String, Double> promedios = vdao.getPromedios();
    Map<String, Boolean> votosUsuario = vdao.getVotosPorUsuario(usuario.getIdusuario());
    String[] operadoras = {"Claro", "Movistar", "Bitel", "Entel"};
    
    ValoraciondDAO vddao = new ValoraciondDAO();
    Map<String, Double> promediosd = vddao.getPromediosd();
    Map<String, Boolean> votosUsuariod = vddao.getVotosPorUsuariod(usuario.getIdusuario());
    String[] distribuidor = {"Win","WOW", "Claro", "Movistar", "Bitel", "Entel"};
    
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inicio - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    .main-content {
        margin-left: 280px;
    }
    .card {
        border-radius: 15px;
        transition: all 0.3s ease-in-out;
    }

    .card:hover {
        transform: scale(1.02);
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
    }

    .info-card {
        background: linear-gradient(135deg, #e3f2fd, #ffffff);
        border-left: 5px solid #2196f3;
    }

    .valoracion-card img {
        height: 80px;
        object-fit: contain;
    }

     .star-rating {
        direction: rtl;
        display: inline-flex;
        gap: 5px;
    }

    .star-rating input[type="radio"] {
        display: none; /* Oculta los puntos */
    }

    .star-icon {
        font-size: 1.5rem;
        color: #ccc;
        transition: color 0.2s;
    }

    .star-rating input[type="radio"]:checked ~ label .star-icon {
        color: #f8d01d;
    }

    .star-rating label:hover ~ label .star-icon,
    .star-rating label:hover .star-icon {
        color: #f8d01d;
    }

    .star-icon {
        font-size: 1.5rem;
        color: #ccc;
        transition: color 0.2s;
    }

    input[type="radio"]:checked ~ label .star-icon {
        color: #f8d01d;
    }

    label:hover ~ label .star-icon,
    label:hover .star-icon {
        color: #f8d01d;
    }
</style>

<div class="main-content container py-4">

    <!-- TARJETAS RESUMEN -->
    <div class="row dashboard-row text-center mb-4">
        <div class="col-md-4">
            <div class="card info-card shadow p-4">
                <h5><i class="bi bi-people-fill text-primary me-2"></i>Usuarios </h5>
                <h2 class="text-dark"><%= totalUsuarios %></h2>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card info-card shadow p-4">
                <h5><i class="bi bi-phone-fill text-success me-2"></i>Encuestas Móvil</h5>
                <h2 class="text-dark"><%= totalMovil %></h2>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card info-card shadow p-4">
                <h5><i class="bi bi-house-door-fill text-warning me-2"></i>Encuestas Hogar</h5>
                <h2 class="text-dark"><%= totalHogar %></h2>
            </div>
        </div>
    </div>

    <!-- ENCUESTAS POR USUARIO -->
    <div class="card shadow p-4 mb-4 bg-white">
        <h4 class="mb-3 text-primary">
            <i class="bi bi-person-badge-fill me-2"></i>
            Encuestas Respondidas por <%= usuario.getApellido() %>, <%= usuario.getNombre() %>
        </h4>
        <p><i class="bi bi-phone-fill text-success me-1"></i><strong>Móvil:</strong> <%= respuestasMovil %></p>
        <p><i class="bi bi-house-door-fill text-warning me-1"></i><strong>Hogar:</strong> <%= respuestasHogar %></p>
        <p><i class="bi bi-clipboard-data text-dark me-1"></i><strong>Total:</strong> <%= totalUsuario %></p>
    </div>

    <!-- VALORACIÓN OPERADORAS -->
    <div class="card shadow p-4 mb-4 bg-light">
        <h4 class="mb-4 text-primary">
            <i class="bi bi-star-fill me-2"></i>Califica a tu Operadora
        </h4>
        <div class="row">
            <% for (String op : operadoras) {
                Double promedio = promedios.getOrDefault(op, 0.0);
                boolean yaVoto = votosUsuario.getOrDefault(op, false);
            %>
            <div class="col-md-4">
                <div class="card valoracion-card text-center mb-4 p-3">
                    <img src="imagenes/<%= op.toLowerCase() %>.png" alt="<%= op %>" class="mb-2">
                    <h5><%= op %></h5>

                    <% if (!yaVoto) { %>
                    <form action="VotarServlet" method="post">
                        <input type="hidden" name="operadora" value="<%= op %>">
                        <div class="star-rating mb-2">
                            <% for (int i = 5; i >= 1; i--) { %>
                                <input type="radio" id="op-<%= op + i %>" name="valoracion" value="<%= i %>" required>
                                <label for="op-<%= op + i %>">
                                    <i class="bi bi-star-fill star-icon"></i>
                                </label>
                            <% } %>
                        </div>
                        <button class="btn btn-outline-primary btn-sm">Votar</button>
                    </form>
                    <% } else { %>
                    <p class="text-success mt-2">
                        <i class="bi bi-check-circle-fill"></i> Ya votaste
                    </p>
                    <% } %>
                    <p class="mt-2 mb-0">Promedio: 
                        <strong><%= String.format("%.2f", promedio) %></strong> 
                        <i class="bi bi-star-fill text-warning"></i>
                    </p>
                </div>
            </div>
            <% } %>
        </div>
    </div>

    <!-- VALORACIÓN DISTRIBUIDORES -->
    <div class="card shadow p-4 bg-light">
        <h4 class="mb-4 text-primary">
            <i class="bi bi-wifi me-2"></i>Califica a tu Distribuidor de Internet
        </h4>
        <div class="row">
            <% for (String ds : distribuidor) {
                Double promediod = promediosd.getOrDefault(ds, 0.0);
                boolean yaVotod = votosUsuariod.getOrDefault(ds, false);
            %>
            <div class="col-md-4">
                <div class="card valoracion-card text-center mb-4 p-3">
                    <img src="imagenes/<%= ds.toLowerCase() %>.png" alt="<%= ds %>" class="mb-2">
                    <h5><%= ds %></h5>

                    <% if (!yaVotod) { %>
                    <form action="VotardServlet" method="post">
                        <input type="hidden" name="distribuidor" value="<%= ds %>">
                        <div class="star-rating mb-2">
                            <% for (int i = 5; i >= 1; i--) { %>
                                <input type="radio" id="dist-<%= ds + i %>" name="valoracion" value="<%= i %>" required>
                                <label for="dist-<%= ds + i %>">
                                    <i class="bi bi-star-fill star-icon"></i>
                                </label>
                            <% } %>
                        </div>
                        <button class="btn btn-outline-primary btn-sm">Votar</button>
                    </form>
                    <% } else { %>
                    <p class="text-success mt-2">
                        <i class="bi bi-check-circle-fill"></i> Ya votaste
                    </p>
                    <% } %>
                    <p class="mt-2 mb-0">Promedio: 
                        <strong><%= String.format("%.2f", promediod) %></strong> 
                        <i class="bi bi-star-fill text-warning"></i>
                    </p>
                </div>
            </div>
            <% } %>
        </div>
    </div>

</div>
<div class="text-center mt-2 mb-4" 
     style="margin-left: 280px; width: calc(100% - 280px); box-sizing: border-box;">
            <a href="detallesValoracion.jsp" class="btn btn-info">
            <i class="bi bi-graph-up"></i> Ver Detalles de Valoraciones
        </a>
    </div>
</body>
</html>