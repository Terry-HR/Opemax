<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@ page import="java.util.*,Modelo.*,DAO.*" %>
<%@include file="MenuAdmin.jsp" %>
<%
    ReporteDAO reporteDAO = new ReporteDAO();
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    List<modeloReporte> reportes = reporteDAO.listarPorEstado(1);
    modeloReporte seleccionado = (modeloReporte) request.getAttribute("reporteSeleccionado");
    
    modeloUsuario usuarioDetalle = null;
    if (seleccionado != null) {
        usuarioDetalle = usuarioDAO.obtenerUsuarioPorId(seleccionado.getIdusuario());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reclamos Pendientes</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="css/menu-estilo.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .main-content {
            margin-left: 250px;
            padding: 30px 40px;
        }
        .filter-group {
            display: flex;
            align-items: flex-end;
            margin-bottom: 20px;
        }
        .filter-group > div {
            margin-right: 15px;
        }
        /* Estilo para separar los botones 'Info' y 'En Proceso' */
        .form-info-margin {
            margin-right: 5px; 
        }
        /* Estilo para el panel de detalle, inicialmente oculto si no hay selección */
        #detalleReclamoPanel {
            /* Inicialmente oculto si no hay selección al cargar */
            display: <%= (seleccionado != null) ? "block" : "none" %>;
        }
    </style>
</head>
<body>

<div class="main-content">
    <h2 class="mb-4">Reclamos Pendientes</h2>

    <div class="row">
        <div class="col-md-12">
            <div class="filter-group">
                <div class="col-md-2 p-0">
                    <label for="fechaInicio" class="form-label">Desde:</label>
                    <input type="date" id="fechaInicio" class="form-control">
                </div>
                <div class="col-md-2 p-0">
                    <label for="fechaFin" class="form-label">Hasta:</label>
                    <input type="date" id="fechaFin" class="form-control">
                </div>
                <div class="col-md-2 p-0">
                    <button id="filtrarBtn" class="btn btn-primary">Filtrar</button>
                    <button id="limpiarFiltro" class="btn btn-secondary">Limpiar</button>
                </div>
                <div class="col-md-6 p-0" id="dt-controls-top">
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <table id="tablaReportes" class="table table-bordered table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Fecha</th>
                        <th>DNI</th>
                        <th>Servicio</th>
                        <th>Empresa</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (modeloReporte r : reportes) {
                            modeloUsuario u = usuarioDAO.obtenerUsuarioPorId(r.getIdusuario());%>
                        <tr>
                            <td><%= r.getIdreporte() %></td>
                            <td><%= r.getFecha_ing() %></td>
                            <td><%= u.getDni()%> </td>
                            <td><%= r.getServicio() %></td>
                            <td><%= r.getEmpresa() %></td>
                            <td>Pendiente</td>
                            <td>
                                <%-- AJUSTE 2: Aplicamos la clase de margen al formulario de Info --%>
                                <form method="post" action="ControladorReporte" style="display:inline;" class="form-info-margin">
                                    <input type="hidden" name="accion" value="verDetalle">
                                    <input type="hidden" name="idreporte" value="<%= r.getIdreporte() %>">
                                    <button type="submit" class="btn btn-info btn-sm">Info</button>
                                </form>
                                <button type="button" class="btn btn-warning btn-sm enProcesoBtn" data-id="<%= r.getIdreporte() %>">En Proceso</button>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="col-md-4" id="detalleReclamoPanel">
            <% if (seleccionado != null && usuarioDetalle != null) { %>
            <div class="card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    Detalle del Reclamo
                    <button type="button" class="btn-close btn-close-white" aria-label="Close" onclick="cerrarDetalle()"></button>
                </div>
                <div class="card-body">
                    <h5 class="card-title">Usuario</h5>
                    <p><strong>DNI:</strong> <%= usuarioDetalle.getDni() %></p>
                    <p><strong>Nombre:</strong> <%= usuarioDetalle.getNombre() %></p>
                    <p><strong>Apellido:</strong> <%= usuarioDetalle.getApellido() %></p>
                    <p><strong>Correo:</strong> <%= usuarioDetalle.getCorreo() %></p>
                    <hr>
                    <h5 class="card-title">Reclamo</h5>
                    <p><strong>Fecha:</strong> <%= seleccionado.getFecha_ing() %></p>
                    <p><strong>Servicio:</strong> <%= seleccionado.getServicio() %></p>
                    <p><strong>Empresa:</strong> <%= seleccionado.getEmpresa() %></p>
                    <p><strong>Reclamo:</strong></p>
                    <textarea class="form-control" readonly><%= seleccionado.getReclamo() %></textarea>
                </div>
            </div>
            <% } else { %>
                <div class="alert alert-info text-center">
                    <i class="fas fa-info-circle me-2"></i> Selecciona un reclamo para ver el detalle.
                </div>
            <% } %>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let tabla;

    // Función para cerrar el panel de detalle
    window.cerrarDetalle = function() {
        $('#detalleReclamoPanel').hide();
    };
    
    $(document).ready(function () {
        tabla = $('#tablaReportes').DataTable({
            order: [[1, 'desc']],
            language: {
                search: "Buscar:",
                lengthMenu: "Mostrar _MENU_ registros",
                info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
                paginate: {
                    previous: "Anterior",
                    next: "Siguiente"
                }
            },
            // Se mantiene dom: 'rtip' para ocultar los controles Buscar/Mostrar
            dom: 'rtip' 
        });

        // Este bloque asegura que el panel se muestre si el servidor devolvió un 'seleccionado'
        if (<%= (seleccionado != null) ? "true" : "false" %>) {
             $('#detalleReclamoPanel').show();
        }

        $(document).on('click', '.enProcesoBtn', function () {
            const id = $(this).data('id');
            Swal.fire({
                title: '¿Estás seguro?',
                text: '¿Deseas cambiar el estado a EN PROCESO?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Sí, cambiar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    const form = $('<form>', {
                        method: 'post',
                        action: 'ControladorReporte'
                    });
                    form.append($('<input>', {type: 'hidden', name: 'accion', value: 'actualizarEstado'}));
                    form.append($('<input>', {type: 'hidden', name: 'idreporte', value: id}));
                    $('body').append(form);
                    form.submit();
                }
            });
        });

        $.fn.dataTable.ext.search.push(
            function(settings, data, dataIndex) {
                const inicio = $('#fechaInicio').val();
                const fin = $('#fechaFin').val();
                const fechaColumna = data[1];

                if (!inicio && !fin) return true;
                
                const fecha = new Date(fechaColumna);
                const desde = inicio ? new Date(inicio) : null;
                const hasta = fin ? new Date(fin) : null;

                if (desde && fecha < desde) return false;
                if (hasta && fecha > hasta) return false;

                return true;
            }
        );

        $('#filtrarBtn').click(function () {
            tabla.draw();
        });

        $('#limpiarFiltro').click(function () {
            $('#fechaInicio').val('');
            $('#fechaFin').val('');
            tabla.draw();
        });
    });
</script>

</body>
</html>
