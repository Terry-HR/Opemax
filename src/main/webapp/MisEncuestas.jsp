<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="Modelo.modeloEmovil"%>
<%@page import="DAO.EmovilDAO"%>
<%@page import="Modelo.modeloEhome"%>
<%@page import="DAO.EhomeDAO"%>
<%@page import="Modelo.modeloUsuario"%>
<%@page session="true"%>
<%@include file="Menu.jsp"%>

<%
    EmovilDAO dao = new EmovilDAO();
    List<modeloEmovil> lista = dao.listarPorUsuario(usuario.getIdusuario());
    
    EhomeDAO daoh = new EhomeDAO();
    List<modeloEhome> listah = daoh.listarPorUsuario(usuario.getIdusuario());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mis Encuestas</title>
    <link href="css/bootstrap.css" rel="stylesheet"> 
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/datetime/1.4.1/css/dataTables.dateTime.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/datetime/1.4.1/js/dataTables.dateTime.min.js"></script>
    
    <!-- ESTILO PARA EL CONTENEDOR PRINCIPAL -->
    <style>
        .main-content {
            margin-left: 280px;
            padding: 20px;
            transition: margin-left 0.3s ease;
        }
        
        /* Para hacerlo responsive */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <!-- CONTENEDOR PRINCIPAL CON LA CLASE -->
    <div class="main-content">
        <div class="container">
            <h2 class="mb-4">Gestionar tus respuestas Internet Móvil</h2>

            <div class="mb-3">
                <label>Fecha:</label>
                <input type="text" id="fechaMovil" class="form-control d-inline-block w-auto">
                <label class="ms-3">Operadora:</label>
                <input type="text" id="operadoraMovil" class="form-control d-inline-block w-auto">
                <button id="limpiarMovil" class="btn btn-secondary btn-sm ms-3">Limpiar filtros</button>
            </div>

            <table id="tablaMovil" class="table table-striped table-bordered">
                <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Fecha</th>
                        <th>Operadora</th>
                        <th>Región</th>
                        <th>Plan</th>
                        <th>MBs</th>
                        <th>Costo</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                <% for (modeloEmovil e : lista) { %>
                    <tr>
                        <td><%= e.getIdemovil() %></td>
                        <td><%= e.getFecha() %></td>
                        <td><%= e.getOperadora() %></td>
                        <td><%= e.getRegion() %></td>
                        <td><%= e.getPlan() %></td>
                        <td><%= e.getMbsreci() %></td>
                        <td><%= e.getCosto() %></td>
                        <td>
                            <button class="btn btn-sm btn-danger eliminar-btn" data-id="<%= e.getIdemovil() %>">Eliminar</button>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <form id="eliminarForm" method="post" action="EliminarEncuestaServlet" style="display:none;">
            <input type="hidden" name="idemovil" id="idemovilHidden">
        </form>

        <div class="container">
            <h2 class="mb-4">Gestiona tus respuestas Internet Hogar</h2>

            <div class="mb-3">
                <label>Fecha:</label>
                <input type="text" id="fechaHogar" class="form-control d-inline-block w-auto">
                <label class="ms-3">Distribuidor:</label>
                <input type="text" id="distribuidorHogar" class="form-control d-inline-block w-auto">
                <button id="limpiarHogar" class="btn btn-secondary btn-sm ms-3">Limpiar filtros</button>
            </div>

            <table id="tablaHogar" class="table table-striped table-bordered">
                <thead class="table-primary">
                    <tr>
                        <th>ID</th>
                        <th>Fecha</th>
                        <th>Distribuidor</th>
                        <th>Región</th>
                        <th>Plan</th>
                        <th>MBs</th>
                        <th>Costo</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                <% for (modeloEhome e : listah) { %>
                    <tr>
                        <td><%= e.getIdehome() %></td>
                        <td><%= e.getFecha() %></td>
                        <td><%= e.getOperadora() %></td>
                        <td><%= e.getRegion() %></td>
                        <td><%= e.getPlan() %></td>
                        <td><%= e.getMbsreci() %></td>
                        <td><%= e.getCosto() %></td>
                        <td>
                            <button class="btn btn-sm btn-danger eliminarh-btn" data-id="<%= e.getIdehome() %>">Eliminar</button>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <form id="eliminarhForm" method="post" action="EliminarEncuestahServlet" style="display:none;">
            <input type="hidden" name="idehome" id="idehomeHidden">
        </form>
    </div> <!-- Cierre del div main-content -->

    <script>
        $(document).ready(function () {
            var tablaMovil = $('#tablaMovil').DataTable({
                language: {
                    search: "Buscar:",
                    zeroRecords: "No se encontraron resultados",
                    info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
                    lengthMenu: "Mostrar _MENU_ registros",
                    paginate: { next: "Siguiente", previous: "Anterior" }
                },
                order: [[1, 'desc']]
            });

            var tablaHogar = $('#tablaHogar').DataTable({
                language: {
                    search: "Buscar:",
                    zeroRecords: "No se encontraron resultados",
                    info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
                    lengthMenu: "Mostrar _MENU_ registros",
                    paginate: { next: "Siguiente", previous: "Anterior" }
                },
                order: [[1, 'desc']]
            });

            new DateTime($('#fechaMovil')[0], { format: 'YYYY-MM-DD' });
            new DateTime($('#fechaHogar')[0], { format: 'YYYY-MM-DD' });

            $('#fechaMovil').on('change', function () {
                tablaMovil.column(1).search(this.value).draw();
            });
            $('#operadoraMovil').on('keyup', function () {
                tablaMovil.column(2).search(this.value).draw();
            });
            $('#limpiarMovil').click(function () {
                $('#fechaMovil, #operadoraMovil').val('');
                tablaMovil.columns().search('').draw();
            });

            $('#fechaHogar').on('change', function () {
                tablaHogar.column(1).search(this.value).draw();
            });
            $('#distribuidorHogar').on('keyup', function () {
                tablaHogar.column(2).search(this.value).draw();
            });
            $('#limpiarHogar').click(function () {
                $('#fechaHogar, #distribuidorHogar').val('');
                tablaHogar.columns().search('').draw();
            });
        });

        document.querySelectorAll('.eliminar-btn').forEach(button => {
            button.addEventListener('click', function () {
                const id = this.getAttribute('data-id');
                Swal.fire({
                    title: '¿Estás seguro?',
                    text: 'Esta acción no se puede deshacer.',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Sí, eliminar',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById('idemovilHidden').value = id;
                        document.getElementById('eliminarForm').submit();
                    }
                });
            });
        });

        document.querySelectorAll('.eliminarh-btn').forEach(button => {
            button.addEventListener('click', function () {
                const id = this.getAttribute('data-id');
                Swal.fire({
                    title: '¿Estás seguro?',
                    text: 'Esta acción no se puede deshacer.',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: 'Sí, eliminar',
                    cancelButtonText: 'Cancelar'
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.getElementById('idehomeHidden').value = id;
                        document.getElementById('eliminarhForm').submit();
                    }
                });
            });
        });
    </script>

</body>
</html>
