<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="Modelo.modeloDisponibilidad"%>
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
    <title>Gestión de Disponibilidad</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css"> 
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --sidebar-bg: #2c3e50;
            --sidebar-text: #ecf0f1;
            --sidebar-hover: #34495e;
            --sidebar-active: #3498db;
            --primary-color: #3498db;
            --secondary-color: #2c3e50;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
            --light-color: #ecf0f1;
            --dark-color: #34495e;
            --white: #ffffff;
            --gray: #95a5a6;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            background-color: #f5f7fa;
            display: flex;
            min-height: 100vh;
        }
        
        .zqx-sidebar-g76 {
            width: 250px;
            background-color: var(--sidebar-bg);
            color: var(--sidebar-text);
            padding: 20px;
            box-sizing: border-box;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .zqx-userinfo-001 {
            padding: 15px;
            margin-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .zqx-userinfo-001 h5 {
            margin: 0 0 5px 0;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .zqx-userinfo-001 p {
            margin: 0;
            font-size: 0.95rem;
            font-weight: 500;
        }
        
        .zqx-userinfo-001 small {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.8rem;
            color: rgba(255,255,255,0.7);
        }
        
        .zqx-navsection-003 {
            margin-bottom: 20px;
        }
        
        .zqx-navitem-88 {
            margin-bottom: 5px;
        }
        
        .zqx-navlink-xx {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            color: var(--sidebar-text);
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
            gap: 10px;
        }
        
        .zqx-navlink-xx:hover, .zqx-navlink-xx.active {
            background-color: var(--sidebar-hover);
            color: white;
        }
        
        .zqx-navlink-xx i.bi {
            font-size: 1.1rem;
        }
        
        .zqx-togglebtn-tt {
            justify-content: space-between;
        }
        
        .zqx-toggleicon-r {
            transition: transform 0.3s;
        }
        
        .zqx-togglebtn-tt.active .zqx-toggleicon-r {
            transform: rotate(90deg);
        }
        
        .zqx-submenu-yy {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease-out;
            padding-left: 15px;
        }
        
        .zqx-submenu-yy.active {
            max-height: 300px;
        }
        
        .zqx-submenu-yy a {
            padding: 8px 15px;
            font-size: 0.9rem;
        }
        
        .zqx-logoutsection-99 {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 15px;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 30px;
            flex-grow: 1;
            width: calc(100% - 250px);
        }
        
        .header-panel {
            background-color: var(--white);
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-panel h1 {
            margin: 0;
            color: var(--secondary-color);
            font-size: 1.8rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            padding: 10px 20px;
            background-color: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 1em;
            gap: 8px;
        }
        
        .btn:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .kpi-boxes {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .kpi-box {
            background-color: var(--white);
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            text-align: center;
            transition: transform 0.3s;
        }
        
        .kpi-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
        }
        
        .kpi-box h3 {
            margin-top: 0;
            color: var(--gray);
            font-size: 1.1rem;
        }
        
        .kpi-box p {
            font-size: 2.2em;
            font-weight: bold;
            margin: 15px 0 0;
        }
        
        .kpi-box.availability p {
            color: var(--success-color);
        }
        
        .kpi-box.active-time p {
            color: var(--primary-color);
        }
        
        .kpi-box.inactive-time p {
            color: var(--danger-color);
        }
        
        .card {
            background-color: var(--white);
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        
        .card h2 {
            margin-top: 0;
            color: var(--secondary-color);
            font-size: 1.5rem;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark-color);
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
            transition: border 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        th, td {
            border: 1px solid #eee;
            padding: 15px;
            text-align: left;
        }
        
        th {
            background-color: var(--light-color);
            font-weight: 600;
            color: var(--dark-color);
        }
        
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        tr:hover {
            background-color: #f1f1f1;
        }
        
        .activo-true { 
            color: var(--success-color); 
            font-weight: bold;
        }
        
        .activo-false { 
            color: var(--danger-color); 
            font-weight: bold;
        }
        
        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
        }
        
        .chart-container {
            background-color: var(--white);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        
        @media (max-width: 768px) {
            .zqx-sidebar-g76 {
                width: 70px;
                overflow: hidden;
            }
            
            .zqx-userinfo-001 h5 span,
            .zqx-userinfo-001 p,
            .zqx-userinfo-001 small,
            .zqx-navlink-xx span,
            .zqx-toggleicon-r {
                display: none;
            }
            
            .zqx-userinfo-001 h5 {
                justify-content: center;
            }
            
            .zqx-navlink-xx {
                justify-content: center;
            }
            
            .main-content {
                margin-left: 70px;
                width: calc(100% - 70px);
                padding: 15px;
            }
            
            .header-panel {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const toggleButtons = document.querySelectorAll('.zqx-togglebtn-tt');
            
            toggleButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    this.classList.toggle('active');
                    
                    const submenu = this.nextElementSibling;
                    submenu.classList.toggle('active');
                });
            });
        });
    </script>
</head>
<body>
    <div class="main-content">
        <div class="header-panel">
            <h1><i class="bi bi-check-circle-fill"></i> Gestión de Disponibilidad del Servicio</h1>
        </div>

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
            <h2><i class="bi bi-plus-circle-fill"></i> Agregar Nuevo Registro de Disponibilidad</h2>
            <form action="DisponibilidadServlet" method="post">
                <input type="hidden" name="accion" value="agregarDisponibilidad">
                <div class="form-group">
                    <label for="inicio"><i class="bi bi-clock"></i> Inicio:</label>
                    <input type="datetime-local" class="form-control" id="inicio" name="inicio" required>
                </div>
                <div class="form-group">
                    <label for="fin"><i class="bi bi-clock"></i> Fin:</label>
                    <input type="datetime-local" class="form-control" id="fin" name="fin" required>
                </div>
                <div class="form-group">
                    <label for="activo"><i class="bi bi-power"></i> Estado:</label>
                    <select class="form-control" id="activo" name="activo">
                        <option value="true">Activo (Servicio disponible)</option>
                        <option value="false">Inactivo (Servicio no disponible)</option>
                    </select>
                </div>
                <button type="submit" class="btn"><i class="bi bi-save-fill"></i> Guardar Registro</button>
            </form>
        </div>

        <div class="card">
            <h2><i class="bi bi-list-ul"></i> Registros de Disponibilidad</h2>
            <div style="overflow-x: auto;">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Inicio</th>
                            <th>Fin</th>
                            <th>Estado</th>
                            <th>Duración</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<modeloDisponibilidad> disponibilidades = (List<modeloDisponibilidad>) request.getAttribute("disponibilidades");
                            if (disponibilidades != null && !disponibilidades.isEmpty()) {
                                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                                for (modeloDisponibilidad disp : disponibilidades) {
                                    Duration duration = Duration.between(disp.getInicio(), disp.getFin());
                                    long hours = duration.toHours();
                                    long minutes = duration.toMinutes() % 60;
                        %>
                        <tr>
                            <td><%= disp.getIdDisponibilidad() %></td>
                            <td><%= disp.getInicio().format(formatter) %></td>
                            <td><%= disp.getFin().format(formatter) %></td>
                            <td class="<%= disp.isActivo() ? "activo-true" : "activo-false" %>">
                                <i class="bi <%= disp.isActivo() ? "bi-check-circle-fill" : "bi-x-circle-fill" %>"></i>
                                <%= disp.isActivo() ? "Activo" : "Inactivo" %>
                            </td>
                            <td><%= hours %>h <%= minutes %>m</td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="5" style="text-align: center;">No hay registros de disponibilidad.</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>