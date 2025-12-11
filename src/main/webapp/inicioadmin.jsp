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

    
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inicio - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  

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
</body>
</html>