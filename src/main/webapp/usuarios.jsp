<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.modeloUsuario" %>
<%@include file="MenuAdmin.jsp" %>

<%
    List<modeloUsuario> usuarios = (List<modeloUsuario>) request.getAttribute("usuarios");
    
    modeloUsuario seleccionado = null;
    if (request.getParameter("editarId") != null) {
        int idEditar = Integer.parseInt(request.getParameter("editarId"));
        for (modeloUsuario u : usuarios) {
            if (u.getIdusuario() == idEditar) {
                seleccionado = u;
                break;
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Gestión de Usuarios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="css/menu-estilo.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
</head>
<body>
    <div class="main-content">

        <h2 class="mb-4">Gestión de Usuarios</h2>

        <div class="row mb-3">
            <div class="col-md-12">
                <div class="d-flex justify-content-between align-items-center">
                    
                    <div class="col-md-4">
                        <input type="text" id="busquedaGlobal" class="form-control" placeholder="Buscar usuarios...">
                    </div>
                    
                    <div class="d-flex">
                        <button class="btn btn-primary me-2" onclick="abrirModalNuevo()">
                            <i class="fas fa-plus"></i> + Nuevo
                        </button>
                        
                        <button class="btn btn-secondary me-2" id="btnEditar" disabled onclick="iniciarEdicion()">
                            <i class="fas fa-edit"></i> Editar
                        </button>
                        
                        <button class="btn btn-danger" id="btnBorrar" disabled onclick="confirmarInactivar()">
                            <i class="fas fa-trash-alt"></i> Borrar
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">

                <table class="table table-bordered table-hover" id="tablaUsuarios">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>DNI</th>
                            <th>Nombre</th>
                            <th>Apellido</th>
                            <th>Correo</th>
                            <th>Rol</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% for (modeloUsuario u : usuarios) { %>
                        <tr class="fila-usuario"
                            data-id="<%= u.getIdusuario() %>"
                            data-dni="<%= u.getDni() %>"
                            data-nombre="<%= u.getNombre() %>"
                            data-apellido="<%= u.getApellido() %>"
                            data-correo="<%= u.getCorreo() %>"
                            data-rol="<%= u.getRol() %>">
                            <td><%= u.getIdusuario() %></td>
                            <td><%= u.getDni() %></td>
                            <td><%= u.getNombre() %></td>
                            <td><%= u.getApellido() %></td>
                            <td><%= u.getCorreo() %></td>
                            <td><%= u.getRol() %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div> <div class="modal fade" id="modalUsuario" tabindex="-1" aria-labelledby="modalUsuarioLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="modalUsuarioLabel"></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <form id="formUsuario" method="post" action="GestionUsuarioServlet">
        <div class="modal-body">
            <input type="hidden" name="accion" id="modalAccion">
            <input type="hidden" name="idusuario" id="modalIdUsuario">
            
            <div class="mb-2">
                <label>DNI</label>
                <input type="number" class="form-control" name="dni" id="modalDni" required>
            </div>
            <div class="mb-2">
                <label>Nombre</label>
                <input type="text" class="form-control" name="nombre" id="modalNombre" required>
            </div>
            <div class="mb-2">
                <label>Apellido</label>
                <input type="text" class="form-control" name="apellido" id="modalApellido" required>
            </div>
            <div class="mb-2">
                <label>Correo</label>
                <input type="email" class="form-control" name="correo" id="modalCorreo" required>
            </div>
            <div class="mb-2">
                <label>Rol</label>
                <select class="form-select" name="rol" id="modalRol" required>
                    <option value="ADMIN">ADMIN</option>
                    <option value="USER">USER</option>
                </select>
            </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
          <button type="submit" class="btn btn-primary" id="btnGuardarModal">Guardar</button>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let tabla;
    let usuarioSeleccionado = null;

    $(document).ready(function () {
        tabla = $('#tablaUsuarios').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
            },
            "dom": 'lrtip' 
        });

        $('#tablaUsuarios tbody').on('click', 'tr', function () {
            // Deseleccionar si ya estaba seleccionado
            if ($(this).hasClass('table-primary')) {
                $(this).removeClass('table-primary');
                usuarioSeleccionado = null;
                $('#btnEditar').prop('disabled', true);
                $('#btnBorrar').prop('disabled', true);
            } else {
                tabla.$('tr.table-primary').removeClass('table-primary');
                $(this).addClass('table-primary');
                
                usuarioSeleccionado = {
                    id: $(this).attr('data-id'),
                    dni: $(this).attr('data-dni'),
                    nombre: $(this).attr('data-nombre'),
                    apellido: $(this).attr('data-apellido'),
                    correo: $(this).attr('data-correo'),
                    rol: $(this).attr('data-rol')
                };

                $('#btnEditar').prop('disabled', false);
                $('#btnBorrar').prop('disabled', false);
            }
        });
        
        $('#busquedaGlobal').on('keyup', function () {
             tabla.search(this.value).draw();
        });

        window.abrirModalNuevo = function() {
            $('#modalUsuarioLabel').text('Crear Nuevo Usuario');
            $('#modalAccion').val('crear'); // Acción para tu Servlet
            $('#modalIdUsuario').val('');
            $('#formUsuario')[0].reset(); // Limpiar el formulario
            
            new bootstrap.Modal(document.getElementById('modalUsuario')).show();
        };

        window.iniciarEdicion = function() {
            if (!usuarioSeleccionado) {
                Swal.fire('Atención', 'Selecciona un usuario para editar.', 'warning');
                return;
            }
            
            $('#modalUsuarioLabel').text('Modificar Usuario: ' + usuarioSeleccionado.nombre);
            $('#modalAccion').val('modificar');
            $('#modalIdUsuario').val(usuarioSeleccionado.id);
            $('#modalDni').val(usuarioSeleccionado.dni);
            $('#modalNombre').val(usuarioSeleccionado.nombre);
            $('#modalApellido').val(usuarioSeleccionado.apellido);
            $('#modalCorreo').val(usuarioSeleccionado.correo);
            $('#modalRol').val(usuarioSeleccionado.rol);
            
            new bootstrap.Modal(document.getElementById('modalUsuario')).show();
        };

        window.confirmarInactivar = function() {
            if (!usuarioSeleccionado) {
                Swal.fire('Atención', 'Selecciona un usuario para inactivar.', 'warning');
                return;
            }
            
            Swal.fire({
                title: '¿Estás seguro?',
                text: 'El usuario ' + usuarioSeleccionado.nombre + ' será inactivado.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, Inactivar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    const form = $('<form>', {
                        method: 'POST',
                        action: 'GestionUsuarioServlet'
                    }).append(
                        $('<input>', { type: 'hidden', name: 'idusuario', value: usuarioSeleccionado.id }),
                        $('<input>', { type: 'hidden', name: 'accion', value: 'inactivar' })
                    );
                    $('body').append(form);
                    form.submit();
                }
            });
        };
        
        $('#formUsuario').on('submit', function (e) {
            e.preventDefault();
            let form = this;
            let accion = $('#modalAccion').val();
            let titulo = (accion === 'modificar') ? '¿Guardar cambios?' : '¿Confirmar nuevo usuario?';
            
            Swal.fire({
                title: titulo,
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Sí, guardar',
                cancelButtonText: 'Cancelar'
            }).then((result) => {
                if (result.isConfirmed) {
                    form.submit();
                }
            });
        });
    });
</script>
</body>
</html>