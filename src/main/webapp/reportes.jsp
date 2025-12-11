<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.modeloReporte" %>
<%@ page import="Modelo.modeloUsuario" %>
<%@ include file="Menu.jsp" %>
<%
 
    if (usuario == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Reportes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .main-content {
            margin-left: 250px;
            padding: 2rem;
        }

        .carrusel {
            display: flex;
            overflow-x: auto;
            gap: 1rem;
            padding-bottom: 1rem;
            scroll-snap-type: x mandatory;
        }

        .carrusel::-webkit-scrollbar {
            height: 6px;
        }

        .carrusel::-webkit-scrollbar-thumb {
            background: #ccc;
            border-radius: 3px;
        }

        .carrusel .card {
            flex: 0 0 auto;
            width: 300px;
            scroll-snap-align: start;
        }
        
        .estado-badge {
            font-size: 0.8rem;
            padding: 0.3rem 0.6rem;
        }
        
        .table-responsive {
            max-height: 500px;
            overflow-y: auto;
        }
        
        .pdf-button {
            background: linear-gradient(135deg, #dc3545, #c82333);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }
        
        .pdf-button:hover {
            background: linear-gradient(135deg, #c82333, #a71e2a);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            color: white;
        }
    </style>
</head>
<body>
<div class="main-content">
    <%-- ALERTAS --%>
    <%
        String mensaje = (String) request.getAttribute("mensaje");
        String mensajeParam = request.getParameter("mensaje");
        
        if ("ok".equals(mensaje)) {
    %>
    <script>
        Swal.fire("Reclamo Enviado", "Tu reclamo se ha registrado correctamente", "success");
    </script>
    <% } else if ("error".equals(mensaje)) { %>
    <script>
        Swal.fire("Error", "No se pudo registrar tu reclamo", "error");
    </script>
    <% } else if ("errorPDF".equals(mensajeParam)) { %>
    <script>
        Swal.fire("Error", "No se pudo generar el PDF", "error");
    </script>
    <% } %>

    <div class="container-fluid py-4">
        <div class="row">
            <!-- Formulario -->
            <div class="col-lg-6">
                <h2 class="mb-4">Registrar Reclamo</h2>
                <form action="ReporteServlet" method="post">
                    <div class="mb-3">
                        <label class="form-label">Servicio:</label>
                        <select id="servicio" name="servicio" onchange="actualizarEmpresas()" class="form-select" required>
                            <option value="">Seleccione...</option>
                            <option value="Movil">Movil</option>
                            <option value="Hogar">Hogar</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Empresa:</label>
                        <select id="empresa" name="empresa" class="form-select" required>
                            <option value="">Seleccione empresa...</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Reclamo (máx. 500 caracteres):</label>
                        <textarea name="reclamo" id="reclamo" class="form-control" maxlength="500" rows="5" required></textarea>
                        <div class="form-text"><span id="contador">0</span>/500 caracteres</div>
                    </div>

                    <button type="submit" class="btn btn-primary">Enviar Reclamo</button>
                </form>
            </div>

            <!-- Dashboard -->
            <div class="col-lg-6">
                <h3 class="mb-3">Estado del Reclamo</h3>
                <div class="row text-center mb-4">
                    <div class="col-md-4">
                        <div class="border rounded p-3 bg-light">
                            <h4><i class="bi bi-clock-history text-danger"></i> <%= request.getAttribute("pendientes") != null ? request.getAttribute("pendientes") : "0" %></h4>
                            <p>Pendientes</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="border rounded p-3 bg-light">
                            <h4><i class="bi bi-hourglass-split text-warning"></i> <%= request.getAttribute("enProceso") != null ? request.getAttribute("enProceso") : "0" %></h4>
                            <p>En Proceso</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="border rounded p-3 bg-light">
                            <h4><i class="bi bi-check-circle-fill text-success"></i> <%= request.getAttribute("finalizados") != null ? request.getAttribute("finalizados") : "0" %></h4>
                            <p>Finalizados</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lista de Registros de Reclamos -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3 class="mb-0">Lista de Registros de Reclamos</h3>
                    <%
                        List<modeloReporte> reportes = (List<modeloReporte>) request.getAttribute("reportes");
                        if (reportes != null && !reportes.isEmpty()) {
                    %>
                    <a href="ReporteServlet?action=generarPDFTodos" class="btn pdf-button" target="_blank">
                        <i class="bi bi-file-earmark-pdf me-2"></i>Descargar PDF de Todos los Reclamos
                    </a>
                    <% } %>
                </div>
                
                <%
                    if (reportes != null && !reportes.isEmpty()) {
                %>
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Servicio</th>
                                <th>Empresa</th>
                                <th>Reclamo</th>
                                <th>Fecha Ingreso</th>
                                <th>Fecha Fin</th>
                                <th>Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (modeloReporte r : reportes) {
                                    String estadoTexto = "";
                                    String badgeClass = "";
                                    
                                    switch (r.getEstado()) {
                                        case 1: 
                                            estadoTexto = "Pendiente";
                                            badgeClass = "bg-danger";
                                            break;
                                        case 2: 
                                            estadoTexto = "En Proceso";
                                            badgeClass = "bg-warning";
                                            break;
                                        case 3: 
                                            estadoTexto = "Finalizado";
                                            badgeClass = "bg-success";
                                            break;
                                        default: 
                                            estadoTexto = "Desconocido";
                                            badgeClass = "bg-secondary";
                                    }
                            %>
                            <tr>
                                <td><%= r.getIdreporte() %></td>
                                <td><%= r.getServicio() %></td>
                                <td><%= r.getEmpresa() %></td>
                                <td>
                                    <span title="<%= r.getReclamo() %>">
                                        <%
                                            String reclamo = r.getReclamo();
                                            if (reclamo.length() > 50) {
                                                out.print(reclamo.substring(0, 50) + "...");
                                            } else {
                                                out.print(reclamo);
                                            }
                                        %>
                                    </span>
                                </td>
                                <td><%= r.getFecha_ing() %></td>
                                <td><%= (r.getFecha_fin() != null ? r.getFecha_fin() : "N/A") %></td>
                                <td>
                                    <span class="badge <%= badgeClass %> estado-badge"><%= estadoTexto %></span>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="alert alert-info text-center">
                    <i class="bi bi-info-circle me-2"></i>
                    No tienes reportes registrados aún. Usa el formulario arriba para registrar tu primer reclamo.
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
    const empresas = {
        Movil: ["Claro", "Movistar", "Bitel", "Entel"],
        Hogar: ["Claro", "Movistar", "Bitel", "Entel", "WIN", "WOW"]
    };

    function actualizarEmpresas() {
        const servicio = document.getElementById("servicio").value;
        const empresa = document.getElementById("empresa");
        empresa.innerHTML = "";

        const opcionDefault = document.createElement("option");
        opcionDefault.value = "";
        opcionDefault.textContent = "Seleccione empresa...";
        empresa.appendChild(opcionDefault);

        if (empresas[servicio]) {
            empresas[servicio].forEach(e => {
                const opt = document.createElement("option");
                opt.value = e;
                opt.textContent = e;
                empresa.appendChild(opt);
            });
        }
    }

    document.getElementById("reclamo").addEventListener("input", function () {
        document.getElementById("contador").textContent = this.value.length;
    });
</script>
</body>
</html>