<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, Modelo.modeloReporte, Modelo.modeloUsuario, DAO.UsuarioDAO"%>
<%@include file="MenuAdmin.jsp" %>
<%
    List<modeloReporte> lista = (List<modeloReporte>) request.getAttribute("lista");
    UsuarioDAO usuarioDAO = new UsuarioDAO();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reclamos en Proceso</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    <style>
        .main-content {
            margin-left: 250px;
            padding: 30px 40px; /* Padding ajustado para un mejor aspecto */
        }

        /* Estilo para el grupo de filtros */
        .filter-group {
            display: flex;
            align-items: flex-end;
            margin-bottom: 20px;
        }
        .filter-group > div {
            margin-right: 15px;
        }
        
        /* Ocultar el panel de detalle inicialmente (si no hay datos), se muestra con JS */
        #detalleReclamo {
            display: none;
            position: sticky;
            top: 20px;
        }
        
        /* Separación entre los botones de la tabla */
        .btn-info-margin {
            margin-right: 5px; 
        }

    </style>
</head>

<body class="bg-light">

<div class="main-content">
    <h2 class="mb-4">Reclamos En Proceso</h2>

    <div class="row">
        <div class="col-md-12">
            <div class="filter-group">
                <div class="col-md-2 p-0">
                    <label for="fechaDesde" class="form-label">Desde:</label>
                    <input type="date" id="fechaDesde" class="form-control">
                </div>
                <div class="col-md-2 p-0">
                    <label for="fechaHasta" class="form-label">Hasta:</label>
                    <input type="date" id="fechaHasta" class="form-control">
                </div>
                <div class="col-md-2 p-0">
                    <button id="filtrarBtn" class="btn btn-primary">Filtrar</button>
                    <button id="limpiarFiltro" class="btn btn-secondary">Limpiar</button>
                </div>
                <%-- Espacio para DataTables, aunque se oculta el length y search --%>
                <div class="col-md-6 p-0" id="dt-controls-top">
                </div>
            </div>
        </div>
    </div>


    <div class="row">
        <div class="col-md-8">
            <table id="tablaReclamos" class="table table-bordered table-hover">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>DNI</th>
                    <th>Servicio</th>
                    <th>Empresa</th>
                    <th>Fecha</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <% for (modeloReporte r : lista) {
                    modeloUsuario u = usuarioDAO.obtenerUsuarioPorId(r.getIdusuario()); %>
                    <tr>
                        <td><%= r.getIdreporte() %></td>
                        <td><%= u.getDni()%></td>
                        <td><%= r.getServicio() %></td>
                        <td><%= r.getEmpresa() %></td>
                        <td><%= r.getFecha_ing() %></td>
                        <td>En Proceso</td>
                        <td>
                            <%-- Botón INFO con margen a la derecha --%>
                            <button class="btn btn-info btn-sm btn-info-detalle btn-info-margin"
                                data-nombre="<%= u.getNombre() %>"
                                data-apellido="<%= u.getApellido() %>"
                                data-dni="<%= u.getDni() %>"
                                data-correo="<%= u.getCorreo() %>"
                                data-servicio="<%= r.getServicio() %>"
                                data-empresa="<%= r.getEmpresa() %>"
                                data-fecha="<%= r.getFecha_ing() %>"
                                data-reclamo="<%= r.getReclamo().replace("\"", "&quot;").replace("\n", "&#10;") %>">
                                Info
                            </button>

                            <%-- Botón Finalizar --%>
                            <button class="btn btn-success btn-sm btn-finalizar"
                                    data-id="<%= r.getIdreporte() %>">
                                Finalizar
                            </button>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="col-md-4" id="detalleReclamo">
            <div class="card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    Detalle del Reclamo
                    <%-- Botón de Cierre (X) --%>
                    <button type="button" class="btn-close btn-close-white" aria-label="Close" onclick="cerrarDetalle()"></button>
                </div>
                <div class="card-body">
                    <h5 class="card-title">Usuario</h5>
                    <p><strong>DNI:</strong> <span id="dni"></span></p>
                    <p><strong>Nombre:</strong> <span id="nombre"></span></p>
                    <p><strong>Correo:</strong> <span id="correo"></span></p>
                    <hr>
                    <h5 class="card-title">Reclamo</h5>
                    <p><strong>Fecha:</strong> <span id="fecha"></span></p>
                    <p><strong>Servicio:</strong> <span id="servicio"></span></p>
                    <p><strong>Empresa:</strong> <span id="empresa"></span></p>
                    <p><strong>Detalle:</strong></p>
                    <textarea id="reclamo" class="form-control" readonly></textarea>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>
    let tabla;

    // Función para cerrar el panel de detalle
    window.cerrarDetalle = function() {
        $('#detalleReclamo').hide();
    };

    $(document).ready(function () {
        tabla = $('#tablaReclamos').DataTable({
            order: [[4, 'desc']],
            language: {
                search: "Buscar:",
                lengthMenu: "Mostrar _MENU_ registros",
                info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
                paginate: {
                    previous: "Anterior",
                    next: "Siguiente"
                }
            },
            // Ocultar 'Mostrar X registros' (l) y 'Buscar' (f)
            dom: 'rtip' 
        });

        // Filtro por fecha (se mantiene la lógica que ya tenías)
        $.fn.dataTable.ext.search.push(function (settings, data) {
            const desde = $('#fechaDesde').val();
            const hasta = $('#fechaHasta').val();
            const fecha = data[4]; // columna Fecha
            
            if (!desde && !hasta) return true;
            
            const fechaD = desde ? new Date(desde) : null;
            const fechaH = hasta ? new Date(hasta) : null;
            const fechaCol = new Date(fecha);

            if (fechaD && fechaCol < fechaD) return false;
            if (fechaH && fechaCol > fechaH) return false;
            
            return true;
        });

        $('#filtrarBtn').on('click', function () {
            tabla.draw();
        });

        $('#limpiarFiltro').on('click', function () {
            $('#fechaDesde').val('');
            $('#fechaHasta').val('');
            tabla.draw();
        });


        // Mostrar detalle
        $('.btn-info-detalle').on('click', function () {
            $('#detalleReclamo').show();
            // Los datos se asignan al panel
            $('#dni').text($(this).data('dni'));
            $('#nombre').text($(this).data('nombre') + ' ' + $(this).data('apellido'));
            $('#correo').text($(this).data('correo'));
            $('#fecha').text($(this).data('fecha'));
            $('#servicio').text($(this).data('servicio'));
            $('#empresa').text($(this).data('empresa'));
            $('#reclamo').val($(this).data('reclamo').replace(/&#10;/g, "\n")); // Reemplazar salto de línea para textarea
        });

        // Confirmar finalizar con SweetAlert2
        $('.btn-finalizar').on('click', function () {
            const id = $(this).data('id');
            Swal.fire({
                title: '¿Estás seguro?',
                text: "¿Deseas finalizar este reclamo? Esto lo marcará como resuelto.",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, finalizar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "ControladorReclamosEnProceso?accion=finalizar&id=" + id;
                }
            });
        });
    });
</script>

</body>
</html>