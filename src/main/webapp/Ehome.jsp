<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.modeloUsuario"%>
<%@page session="true"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Encuesta Hogar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>

<!-- Sidebar / Menu -->
<%@include file="Menu.jsp" %>

<!-- Contenido principal -->
<div class="main-content">
    <% if (request.getAttribute("mensaje") != null) { %>
        <div class="alert alert-<%= request.getAttribute("tipo") %> alert-dismissible fade show" role="alert">
            <%= request.getAttribute("mensaje") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow rounded">
                <div class="card-body">
                    <h4 class="card-title text-center text-primary mb-4">Encuesta de Internet Hogar</h4>

                    <form action="GuardarEhomeServlet" method="post">
                        <div class="mb-3">
                            <label class="form-label">Fecha</label>
                            <input type="text" class="form-control" name="fecha" value="<%= java.time.LocalDate.now() %>" readonly>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">¿Cuál es la empresa que te distribuye internet?</label>
                            <select class="form-select" name="operadora" required>
                                <option value="">Seleccione</option>
                                <option value="Claro">Claro</option>
                                <option value="Movistar">Movistar</option>
                                <option value="Bitel">Bitel</option>
                                <option value="WIN">WIN</option>
                                <option value="WOW">WOW</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">¿En qué región te encuentras?</label>
                            <select class="form-select" name="region" required>
                                <option value="">Seleccione</option>
                                <option value="Amazonas">Amazonas</option>
                                <option value="Ancash">Áncash</option>
                                <option value="Apurimac">Apurímac</option>
                                <option value="Arequipa">Arequipa</option>
                                <option value="Ayacucho">Ayacucho</option>
                                <option value="Cajamarca">Cajamarca</option>
                                <option value="Callao">Callao</option>
                                <option value="Cusco">Cusco</option>
                                <option value="Huancavelica">Huancavelica</option>
                                <option value="Huanuco">Huánuco</option>
                                <option value="Ica">Ica</option>
                                <option value="Junin">Junín</option>
                                <option value="La Libertad">La Libertad</option>
                                <option value="Lambayeque">Lambayeque</option>
                                <option value="Lima">Lima</option>
                                <option value="Loreto">Loreto</option>
                                <option value="Madre de Dios">Madre de Dios</option>
                                <option value="Moquegua">Moquegua</option>
                                <option value="Pasco">Pasco</option>
                                <option value="Piura">Piura</option>
                                <option value="Puno">Puno</option>
                                <option value="San Martin">San Martín</option>
                                <option value="Tacna">Tacna</option>
                                <option value="Tumbes">Tumbes</option>
                                <option value="Ucayali">Ucayali</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">¿Qué plan tienes contratado en MBs?</label>
                            <input type="number" step="0.01" min="0" name="plan" placeholder="0.00" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">¿Cuántas MBs recibes del modem actualmente?</label>
                            <small class="d-block mb-1">Puedes comprobarlo en <a href="https://www.speedtest.net/es" target="_blank">SpeedTest</a></small>
                            <input type="number" step="0.01" min="0" name="mbsreci" placeholder="0.00" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">¿Cuál es el precio de tu plan contratado en S/.?</label>
                            <input type="number" step="0.01" min="0" name="costo" placeholder="0.00" class="form-control" required>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Enviar Encuesta</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
