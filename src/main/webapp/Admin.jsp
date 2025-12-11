<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="MenuAdmin.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-5">

    <div class="row g-4">
        <!-- Pendientes -->
        <div class="col-md-3">
            <div class="card text-bg-warning shadow h-100">
                <div class="card-body text-center">
                    <i class="bi bi-hourglass-split display-4 mb-2"></i>
                    <h5 class="card-title">Pendientes</h5>
                    <p class="card-text fs-4"><%= request.getAttribute("pendientes") %></p>
                </div>
            </div>
        </div>

        <!-- En proceso -->
        <div class="col-md-3">
            <div class="card text-bg-info shadow h-100">
                <div class="card-body text-center">
                    <i class="bi bi-gear-fill display-4 mb-2"></i>
                    <h5 class="card-title">En Proceso</h5>
                    <p class="card-text fs-4"><%= request.getAttribute("enProceso") %></p>
                </div>
            </div>
        </div>

        <!-- Finalizados -->
        <div class="col-md-3">
            <div class="card text-bg-success shadow h-100">
                <div class="card-body text-center">
                    <i class="bi bi-check2-circle display-4 mb-2"></i>
                    <h5 class="card-title">Finalizados</h5>
                    <p class="card-text fs-4"><%= request.getAttribute("finalizados") %></p>
                </div>
            </div>
        </div>

        <!-- Finalizados mismo día -->
        <div class="col-md-3">
            <div class="card text-bg-primary shadow h-100">
                <div class="card-body text-center">
                    <i class="bi bi-calendar-check-fill display-4 mb-2"></i>
                    <h5 class="card-title">Finalizados Hoy</h5>
                    <p class="card-text fs-4"><%= request.getAttribute("finalizadosHoy") %></p>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
