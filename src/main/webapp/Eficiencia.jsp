<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Modelo.modeloEficiencia"%>
<%@page import="java.time.Duration"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="Modelo.modeloUsuario"%>
<%@include file="Menu.jsp" %>
<%
    if (usuario == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Gestión de Eficiencia (Incidentes)</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #eef2ff;
            --secondary: #3f37c9;
            --success: #4cc9f0;
            --success-dark: #4895ef;
            --danger: #f72585;
            --warning: #f8961e;
            --info: #7209b7;
            --dark: #212529;
            --light: #f8f9fa;
            --gray: #6c757d;
            --gray-light: #e9ecef;
            --white: #ffffff;
            
            --sidebar-width: 280px;
            --sidebar-collapsed: 80px;
            --header-height: 80px;
            --border-radius: 12px;
            --box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            --transition: all 0.3s ease;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f7fb;
            color: var(--dark);
            display: flex;
            min-height: 100vh;
            line-height: 1.6;
        }
        
        /* Sidebar Moderno */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--white);
            box-shadow: var(--box-shadow);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: var(--transition);
            z-index: 1000;
            border-right: 1px solid rgba(0,0,0,0.05);
        }
        
        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--gray-light);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .sidebar-logo {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .sidebar-logo i {
            font-size: 1.5rem;
        }
        
        .user-profile {
            padding: 1.5rem;
            border-bottom: 1px solid var(--gray-light);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-weight: 600;
        }
        
        .user-info h5 {
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
            color: var(--dark);
        }
        
        .user-info p {
            font-size: 0.75rem;
            color: var(--gray);
            margin-bottom: 0;
        }
        
        .sidebar-menu {
            flex-grow: 1;
            overflow-y: auto;
            padding: 1rem 0;
        }
        
        .nav-item {
            margin-bottom: 0.25rem;
        }
        
        .nav-link {
            display: flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            color: var(--gray);
            text-decoration: none;
            transition: var(--transition);
            font-weight: 500;
            border-left: 3px solid transparent;
        }
        
        .nav-link:hover, .nav-link.active {
            color: var(--primary);
            background-color: var(--primary-light);
            border-left-color: var(--primary);
        }
        
        .nav-link i {
            font-size: 1.25rem;
            margin-right: 0.75rem;
            width: 24px;
            text-align: center;
        }
        
        .nav-link .menu-text {
            transition: var(--transition);
        }
        
        .submenu {
            padding-left: 3.25rem;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
        }
        
        .submenu.active {
            max-height: 500px;
        }
        
        .submenu .nav-link {
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
        }
        
        .sidebar-footer {
            padding: 1rem 1.5rem;
            border-top: 1px solid var(--gray-light);
        }
        
        /* Contenido Principal */
        .main-content {
            margin-left: var(--sidebar-width);
            flex-grow: 1;
            transition: var(--transition);
            padding: 2rem;
        }
        
        /* Header */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--gray-light);
        }
        
        .page-title {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .page-title h1 {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--dark);
            margin: 0;
        }
        
        .page-title .icon {
            width: 48px;
            height: 48px;
            border-radius: var(--border-radius);
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 1.5rem;
        }
        
        /* Cards */
        .card {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 2rem;
            border: none;
            overflow: hidden;
        }
        
        .card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--gray-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .card-header h2 {
            font-size: 1.25rem;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        /* Botones */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 500;
            transition: var(--transition);
            cursor: pointer;
            border: none;
            gap: 0.5rem;
            font-size: 0.875rem;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: var(--white);
        }
        
        .btn-primary:hover {
            background-color: var(--secondary);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(67, 97, 238, 0.2);
        }
        
        .btn-success {
            background-color: var(--success-dark);
            color: var(--white);
        }
        
        .btn-success:hover {
            background-color: var(--success);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(72, 149, 239, 0.2);
        }
        
        .btn-warning {
            background-color: var(--warning);
            color: var(--white);
        }
        
        .btn-warning:hover {
            background-color: #e67e22;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(248, 150, 30, 0.2);
        }
        
        /* Formularios */
        .form-group {
            margin-bottom: 1.25rem;
        }
        
        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--gray-light);
            border-radius: var(--border-radius);
            font-size: 0.875rem;
            transition: var(--transition);
        }
        
        .form-control:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.15);
        }
        
        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%236c757d' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 16px 12px;
        }
        
        textarea.form-control {
            min-height: 120px;
        }
        
        /* KPI Boxes (Mantenemos los estilos aunque se eliminen los elementos en el body) */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .kpi-card {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.5rem;
            transition: var(--transition);
        }
        
        .kpi-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .kpi-title {
            font-size: 0.875rem;
            color: var(--gray);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .kpi-value {
            font-size: 2rem;
            font-weight: 700;
            margin: 0;
        }
        
        .kpi-efficiency .kpi-value {
            color: var(--primary);
        }
        
        .kpi-total .kpi-value {
            color: var(--dark);
        }
        
        .kpi-resolved .kpi-value {
            color: var(--success-dark);
        }
        
        /* Tablas */
        .table-responsive {
            overflow-x: auto;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
            background: var(--white);
        }
        
        .table th {
            background-color: var(--primary-light);
            color: var(--primary);
            font-weight: 600;
            padding: 1rem;
            text-align: left;
            border-bottom: 2px solid var(--gray-light);
        }
        
        .table td {
            padding: 1rem;
            border-bottom: 1px solid var(--gray-light);
            vertical-align: middle;
        }
        
        .table tr:last-child td {
            border-bottom: none;
        }
        
        .table tr:hover {
            background-color: rgba(67, 97, 238, 0.05);
        }
        
        /* Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            gap: 0.25rem;
        }
        
        .badge-success {
            background-color: rgba(76, 201, 240, 0.1);
            color: var(--success-dark);
        }
        
        .badge-warning {
            background-color: rgba(248, 150, 30, 0.1);
            color: var(--warning);
        }
        
        /* Alertas */
        .alert {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .alert-success {
            background-color: rgba(76, 201, 240, 0.1);
            color: var(--success-dark);
            border-left: 4px solid var(--success-dark);
        }
        
        .alert-error {
            background-color: rgba(247, 37, 133, 0.1);
            color: var(--danger);
            border-left: 4px solid var(--danger);
        }
        
        /* Gráficos */
        .chart-container {
            position: relative;
            height: 350px;
            margin-bottom: 1.5rem;
        }
        
        /* Grid Layout */
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -0.75rem;
        }
        
        .col-md-6 {
            flex: 0 0 50%;
            max-width: 50%;
            padding: 0 0.75rem;
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                width: var(--sidebar-collapsed);
            }
            
            .sidebar-logo span,
            .user-info,
            .nav-link .menu-text,
            .sidebar-footer .btn-text {
                display: none;
            }
            
            .sidebar-logo,
            .nav-link {
                justify-content: center;
            }
            
            .nav-link i {
                margin-right: 0;
                font-size: 1.5rem;
            }
            
            .main-content {
                margin-left: var(--sidebar-collapsed);
            }
        }
        
        @media (max-width: 768px) {
            .kpi-grid {
                grid-template-columns: 1fr;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .col-md-6 {
                flex: 0 0 100%;
                max-width: 100%;
            }
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Toggle submenus
            const menuToggles = document.querySelectorAll('.nav-link.has-submenu');
            
            menuToggles.forEach(toggle => {
                toggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    const submenu = this.nextElementSibling;
                    submenu.classList.toggle('active');
                    this.classList.toggle('active');
                });
            });
            
            // ELIMINADO: Lógica de inicialización del gráfico de eficiencia
        });
    </script>
</head>
<body>
    <main class="main-content">
        <header class="page-header">
            <div class="page-title">
                <div class="icon">
                    <i class="bi bi-clock"></i>
                </div>
                <h1>Gestión de Eficiencia (Incidentes)</h1>
            </div>
        </header>
        
        <%-- Mensajes de éxito o error --%>
        <% if (request.getAttribute("mensajeExito") != null) { %>
            <div class="alert alert-success">
                <i class="bi bi-check-circle-fill"></i> <%= request.getAttribute("mensajeExito") %>
            </div>
        <% } %>
        <% if (request.getAttribute("mensajeError") != null) { %>
            <div class="alert alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i> <%= request.getAttribute("mensajeError") %>
            </div>
        <% } %>
        
        <div class="card">
            <div class="card-header">
                <h2><i class="bi bi-plus-circle"></i> Reportar Nuevo Incidente</h2>
            </div>
            <div class="card-body">
                <form action="EficienciaServlet" method="post">
                    <input type="hidden" name="accion" value="reportarIncidente">
                    <div class="form-group">
                        <label for="idUsuario" class="form-label">
                            <i class="bi bi-person-badge"></i> ID de Usuario
                        </label>
                        <input type="number" class="form-control" id="idUsuario" name="idUsuario" required min="1" value="23">
                    </div>
                    <div class="form-group">
                        <label for="descripcion" class="form-label">
                            <i class="bi bi-card-text"></i> Descripción del Incidente
                        </label>
                        <textarea class="form-control" id="descripcion" name="descripcion" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-success">
                        <i class="bi bi-send"></i> Reportar Incidente
                    </button>
                </form>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                <h2><i class="bi bi-list-ul"></i> Listado de Incidentes</h2>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID Incidente</th>
                                <th>ID Usuario</th>
                                <th>Descripción</th>
                                <th>Fecha Apertura</th>
                                <th>Fecha Resolución</th>
                                <th>Duración</th>
                                <th>Estado</th>
                                <th>Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<modeloEficiencia> incidentes = (List<modeloEficiencia>) request.getAttribute("incidentes");
                                if (incidentes != null && !incidentes.isEmpty()) {
                                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                                    for (modeloEficiencia inc : incidentes) {
                                        String duracionStr = "N/A";
                                        if (inc.getFechaResolucion() != null) {
                                            Duration duration = Duration.between(inc.getFechaApertura(), inc.getFechaResolucion());
                                            long hours = duration.toHours();
                                            long minutes = duration.toMinutes() % 60;
                                            duracionStr = hours + "h " + minutes + "m";
                                        }
                            %>
                            <tr>
                                <td><%= inc.getIdIncidente() %></td>
                                <td><%= inc.getIdUsuario() %></td>
                                <td><%= inc.getDescripcion() %></td>
                                <td><%= inc.getFechaApertura().format(formatter) %></td>
                                <td><%= inc.getFechaResolucion() != null ? inc.getFechaResolucion().format(formatter) : "N/A" %></td>
                                <td><%= duracionStr %></td>
                                <td>
                                    <span class="badge <%= inc.getEstado().equalsIgnoreCase("Resuelto") ? "badge-success" : "badge-warning" %>">
                                        <i class="bi <%= inc.getEstado().equalsIgnoreCase("Resuelto") ? "bi-check-circle" : "bi-clock-history" %>"></i>
                                        <%= inc.getEstado() %>
                                    </span>
                                </td>
                                <td>
                                    <% if (!inc.getEstado().equalsIgnoreCase("Resuelto")) { %>
                                    <form action="EficienciaServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="accion" value="resolverIncidente">
                                        <input type="hidden" name="idIncidente" value="<%= inc.getIdIncidente() %>">
                                        <button type="submit" class="btn btn-warning">
                                            <i class="bi bi-check-circle"></i> Marcar como Resuelto
                                        </button>
                                    </form>
                                    <% } else { %>
                                    <span class="badge badge-success">
                                        <i class="bi bi-check-circle"></i> Resuelto
                                    </span>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">
                                    No hay incidentes registrados.
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</body>
</html>