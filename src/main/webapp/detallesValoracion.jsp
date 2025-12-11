<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.modeloUsuario"%>
<%@page import="DAO.ValoracionDAO, DAO.ValoraciondDAO"%>
<%@page import="java.util.List, java.util.Map, java.util.HashMap"%>
<%@include file="Menu.jsp"%>

<%
    ValoracionDAO vdao = new ValoracionDAO();
    ValoraciondDAO vddao = new ValoraciondDAO();
    
    // Obtener estadísticas de valoraciones
    Map<String, Integer> statsOperadoras = vdao.getEstadisticasEstado();
    Map<String, Integer> statsDistribuidores = vddao.getEstadisticasEstado();
    
    // Obtener todos los registros para las tablas
    List<Map<String, String>> registrosOperadoras = vdao.getAllRegistros();
    List<Map<String, String>> registrosDistribuidores = vddao.getAllRegistros();
    
    // Parámetro para saber qué mostrar
    String tipo = request.getParameter("tipo");
    if(tipo == null) tipo = "operadora";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard de Valoraciones</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4cc9f0;
            --warning-color: #f8961e;
            --danger-color: #f94144;
            --light-bg: #f8f9fa;
            --dark-bg: #212529;
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f5f7fa;
            color: #333;
        }
        
        .main-content {
            padding: 2rem;
            margin-left: 250px;
        }
        
        .header-panel {
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .header-panel h1 {
            color: var(--primary-color);
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            padding: 2rem;
            margin-bottom: 2rem;
            border: none;
        }
        
        .card h2 {
            color: var(--secondary-color);
            margin-bottom: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .filter-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }
        
        .chart-container {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            margin-bottom: 2rem;
            border: 1px solid #e0e0e0;
        }
        
        .chart-container canvas {
            max-height: 300px;
        }
        
        .table-responsive {
            margin-top: 2rem;
        }
        
        .table {
            border-radius: 8px;
            overflow: hidden;
        }
        
        .table thead {
            background-color: var(--primary-color);
            color: white;
        }
        
        .table th {
            font-weight: 500;
        }
        
        .status-badge {
            padding: 0.35rem 0.65rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: capitalize;
        }
        
        .status-satisfecho {
            background-color: rgba(75, 192, 192, 0.2);
            color: #4bc0c0;
        }
        
        .status-neutral {
            background-color: rgba(255, 206, 86, 0.2);
            color: #ffce56;
        }
        
        .status-insatisfecho {
            background-color: rgba(255, 99, 132, 0.2);
            color: #ff6384;
        }
        
        .stats-card {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--primary-color);
        }
        
        .stats-card h3 {
            font-size: 1rem;
            color: #6c757d;
            margin-bottom: 1rem;
        }
        
        .stats-card .stat-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--dark-bg);
        }
        
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--secondary-color);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>
<div class="main-content">
    <div class="header-panel">
        <h1><i class="bi bi-bar-chart-line"></i> Dashboard de Valoraciones</h1>
    </div>

    <div class="filter-buttons mb-4">
        <a href="detallesValoracion.jsp?tipo=operadora" 
           class="btn <%= "operadora".equals(tipo) ? "btn-primary" : "btn-outline-primary" %>">
            <i class="bi bi-building"></i> Operadoras
        </a>
        <a href="detallesValoracion.jsp?tipo=distribuidor" 
           class="btn <%= "distribuidor".equals(tipo) ? "btn-primary" : "btn-outline-primary" %>">
            <i class="bi bi-truck"></i> Distribuidores
        </a>
    </div>

    <% if("operadora".equals(tipo)) { %>
        <div class="card">
            <h2><i class="bi bi-pie-chart"></i> Estadísticas de Operadoras</h2>
            
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="stats-card">
                        <h3><i class="bi bi-emoji-smile"></i> Satisfechos</h3>
                        <div class="stat-value text-success"><%= statsOperadoras.getOrDefault("Satisfecho", 0) %></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card">
                        <h3><i class="bi bi-emoji-neutral"></i> Neutrales</h3>
                        <div class="stat-value text-warning"><%= statsOperadoras.getOrDefault("Neutral", 0) %></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card">
                        <h3><i class="bi bi-emoji-frown"></i> Insatisfechos</h3>
                        <div class="stat-value text-danger"><%= statsOperadoras.getOrDefault("Insatisfecho", 0) %></div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-lg-6">
                    <div class="chart-container">
                        <h3 class="section-title"><i class="bi bi-pie-chart-fill"></i> Distribución</h3>
                        <canvas id="operadorasChart"></canvas>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="chart-container">
                        <h3 class="section-title"><i class="bi bi-bar-chart-fill"></i> Comparación</h3>
                        <canvas id="operadorasBarChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="table-responsive mt-4">
                <h3 class="section-title"><i class="bi bi-table"></i> Registros de Valoraciones</h3>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th><i class="bi bi-person"></i> Usuario</th>
                            <th><i class="bi bi-building"></i> Operadora</th>
                            <th><i class="bi bi-star"></i> Valoración</th>
                            <th><i class="bi bi-info-circle"></i> Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Map<String, String> registro : registrosOperadoras) { 
                            String estadoClass = "";
                            switch(registro.get("estado")) {
                                case "Satisfecho": estadoClass = "status-satisfecho"; break;
                                case "Neutral": estadoClass = "status-neutral"; break;
                                case "Insatisfecho": estadoClass = "status-insatisfecho"; break;
                            }
                        %>
                        <tr>
                            <td><%= registro.get("usuario") %></td>
                            <td><%= registro.get("operadora") %></td>
                            <td>
                                <% int valoracion = Integer.parseInt(registro.get("valoracion")); %>
                                <% for(int i=1; i<=5; i++) { %>
                                    <i class="bi <%= i <= valoracion ? "bi-star-fill text-warning" : "bi-star text-secondary" %>"></i>
                                <% } %>
                            </td>
                            <td><span class="status-badge <%= estadoClass %>"><%= registro.get("estado") %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <script>
            // Gráfico circular para operadoras
            const operadorasCtx = document.getElementById('operadorasChart').getContext('2d');
            new Chart(operadorasCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Satisfecho', 'Neutral', 'Insatisfecho'],
                    datasets: [{
                        data: [
                            <%= statsOperadoras.getOrDefault("Satisfecho", 0) %>,
                            <%= statsOperadoras.getOrDefault("Neutral", 0) %>,
                            <%= statsOperadoras.getOrDefault("Insatisfecho", 0) %>
                        ],
                        backgroundColor: [
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(255, 99, 132, 0.7)'
                        ],
                        borderColor: [
                            'rgba(75, 192, 192, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(255, 99, 132, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom',
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.label || '';
                                    let value = context.raw || 0;
                                    let total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    let percentage = Math.round((value / total) * 100);
                                    return `${label}: ${value} (${percentage}%)`;
                                }
                            }
                        }
                    }
                }
            });
            
            // Gráfico de barras para operadoras
            const operadorasBarCtx = document.getElementById('operadorasBarChart').getContext('2d');
            new Chart(operadorasBarCtx, {
                type: 'bar',
                data: {
                    labels: ['Satisfecho', 'Neutral', 'Insatisfecho'],
                    datasets: [{
                        label: 'Cantidad de Valoraciones',
                        data: [
                            <%= statsOperadoras.getOrDefault("Satisfecho", 0) %>,
                            <%= statsOperadoras.getOrDefault("Neutral", 0) %>,
                            <%= statsOperadoras.getOrDefault("Insatisfecho", 0) %>
                        ],
                        backgroundColor: [
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(255, 99, 132, 0.7)'
                        ],
                        borderColor: [
                            'rgba(75, 192, 192, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(255, 99, 132, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        </script>
    <% } else { %>
        <div class="card">
            <h2><i class="bi bi-pie-chart"></i> Estadísticas de Distribuidores</h2>
            
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="stats-card">
                        <h3><i class="bi bi-emoji-smile"></i> Satisfechos</h3>
                        <div class="stat-value text-success"><%= statsDistribuidores.getOrDefault("Satisfecho", 0) %></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card">
                        <h3><i class="bi bi-emoji-neutral"></i> Neutrales</h3>
                        <div class="stat-value text-warning"><%= statsDistribuidores.getOrDefault("Neutral", 0) %></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stats-card">
                        <h3><i class="bi bi-emoji-frown"></i> Insatisfechos</h3>
                        <div class="stat-value text-danger"><%= statsDistribuidores.getOrDefault("Insatisfecho", 0) %></div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-lg-6">
                    <div class="chart-container">
                        <h3 class="section-title"><i class="bi bi-pie-chart-fill"></i> Distribución</h3>
                        <canvas id="distribuidoresChart"></canvas>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="chart-container">
                        <h3 class="section-title"><i class="bi bi-bar-chart-fill"></i> Comparación</h3>
                        <canvas id="distribuidoresBarChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="table-responsive mt-4">
                <h3 class="section-title"><i class="bi bi-table"></i> Registros de Valoraciones</h3>
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th><i class="bi bi-person"></i> Usuario</th>
                            <th><i class="bi bi-truck"></i> Distribuidor</th>
                            <th><i class="bi bi-star"></i> Valoración</th>
                            <th><i class="bi bi-info-circle"></i> Estado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Map<String, String> registro : registrosDistribuidores) { 
                            String estadoClass = "";
                            switch(registro.get("estado")) {
                                case "Satisfecho": estadoClass = "status-satisfecho"; break;
                                case "Neutral": estadoClass = "status-neutral"; break;
                                case "Insatisfecho": estadoClass = "status-insatisfecho"; break;
                            }
                        %>
                        <tr>
                            <td><%= registro.get("usuario") %></td>
                            <td><%= registro.get("distribuidor") %></td>
                            <td>
                                <% int valoracion = Integer.parseInt(registro.get("valoracion")); %>
                                <% for(int i=1; i<=5; i++) { %>
                                    <i class="bi <%= i <= valoracion ? "bi-star-fill text-warning" : "bi-star text-secondary" %>"></i>
                                <% } %>
                            </td>
                            <td><span class="status-badge <%= estadoClass %>"><%= registro.get("estado") %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <script>
            // Gráfico circular para distribuidores
            const distribuidoresCtx = document.getElementById('distribuidoresChart').getContext('2d');
            new Chart(distribuidoresCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Satisfecho', 'Neutral', 'Insatisfecho'],
                    datasets: [{
                        data: [
                            <%= statsDistribuidores.getOrDefault("Satisfecho", 0) %>,
                            <%= statsDistribuidores.getOrDefault("Neutral", 0) %>,
                            <%= statsDistribuidores.getOrDefault("Insatisfecho", 0) %>
                        ],
                        backgroundColor: [
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(255, 99, 132, 0.7)'
                        ],
                        borderColor: [
                            'rgba(75, 192, 192, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(255, 99, 132, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom',
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.label || '';
                                    let value = context.raw || 0;
                                    let total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    let percentage = Math.round((value / total) * 100);
                                    return `${label}: ${value} (${percentage}%)`;
                                }
                            }
                        }
                    }
                }
            });
            
            // Gráfico de barras para distribuidores
            const distribuidoresBarCtx = document.getElementById('distribuidoresBarChart').getContext('2d');
            new Chart(distribuidoresBarCtx, {
                type: 'bar',
                data: {
                    labels: ['Satisfecho', 'Neutral', 'Insatisfecho'],
                    datasets: [{
                        label: 'Cantidad de Valoraciones',
                        data: [
                            <%= statsDistribuidores.getOrDefault("Satisfecho", 0) %>,
                            <%= statsDistribuidores.getOrDefault("Neutral", 0) %>,
                            <%= statsDistribuidores.getOrDefault("Insatisfecho", 0) %>
                        ],
                        backgroundColor: [
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(255, 206, 86, 0.7)',
                            'rgba(255, 99, 132, 0.7)'
                        ],
                        borderColor: [
                            'rgba(75, 192, 192, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(255, 99, 132, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });
        </script>
    <% } %>
</div>
</body>
</html>
