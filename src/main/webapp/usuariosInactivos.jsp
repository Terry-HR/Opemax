<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<%@ page import="java.util.*, Modelo.modeloUsuario" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="MenuAdmin.jsp" %>

<html>
<head>
    <title>Usuarios Inactivos</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<div class="main-content usuarios-inactivos px-3 pt-4">

    <h2 class="mb-4">Usuarios Inactivos</h2>

    <div class="row mb-3">
        <div class="col-md-12">
            <div class="d-flex justify-content-between align-items-center">
                
                <div class="col-md-4">
                    <input type="text" id="busquedaGlobal" class="form-control" placeholder="Buscar usuarios...">
                </div>
                
                <div class="d-flex">
                </div>
            </div>
        </div>
    </div>

    <table id="tablaUsuarios" class="table table-bordered table-hover">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>DNI</th>
            <th>Nombre</th>
            <th>Apellido</th>
            <th>Correo</th>
            <th>Rol</th>
            <th>Acción</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${listaInactivos}">
            <tr data-id="${u.idusuario}">
                <td>${u.idusuario}</td>
                <td>${u.dni}</td>
                <td>${u.nombre}</td>
                <td>${u.apellido}</td>
                <td>${u.correo}</td>
                <td>${u.rol}</td>
                <td>
                    <button class="btn btn-success btn-sm activar-btn" data-id="${u.idusuario}">Activar</button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        const tabla = $('#tablaUsuarios').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/es-ES.json'
            },
            "dom": 'lrtip' 
        });

        $('#tablaUsuarios').on('click', '.activar-btn', function () {
            const id = $(this).data('id');
            Swal.fire({
                title: '¿Estás seguro?',
                text: "¿Deseas activar este usuario?",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#198754',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Sí, activar'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'UsuariosInactivosServlet?accion=activar&id=' + id;
                }
            });
        });

        $('#busquedaGlobal').on('keyup', function () {
            tabla.search(this.value).draw();
        });
    });
</script>

</body>
</html>