<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="Modelo.modeloUsuario" %>
<%@ page session="true" %>
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
    <meta charset="UTF-8">
    <title>Perfil de Usuario</title>
    <link rel="stylesheet" href="css/bootstrap.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .main-content {
            margin-left: 250px;
            padding: 2rem;
        }

        .perfil-card {
            background-color: #ffffff;
            border-radius: 1rem;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 2rem;
        }
    </style>
</head>
<body>

<div class="main-content">
    <div class="container perfil-card">
        <h3 class="mb-4 text-primary"><i class="bi bi-person-circle me-2"></i>Mi Perfil</h3>
        <form action="ActualizarPerfilServlet" method="post" onsubmit="return validarFormulario()">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">DNI</label>
                    <input type="text" class="form-control" value="<%= usuario.getDni() %>" readonly>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Nombre</label>
                    <input type="text" class="form-control" value="<%= usuario.getNombre() %>" readonly>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Apellido</label>
                    <input type="text" class="form-control" value="<%= usuario.getApellido() %>" readonly>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Correo</label>
                    <input type="email" class="form-control" value="<%= usuario.getCorreo() %>" readonly>
                </div>
            </div>

            <hr>
            <h5 class="text-secondary mb-3"><i class="bi bi-lock-fill me-2"></i>Cambiar Contraseña</h5>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Contraseña Actual</label>
                    <input type="password" class="form-control" name="contrasenaActual" id="contrasenaActual">
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Nueva Contraseña</label>
                    <input type="password" class="form-control" name="nuevaContrasena" id="nuevaContrasena">
                    <div class="form-text">Mínimo 8 caracteres, 1 mayúscula, 1 número y 1 símbolo</div>
                </div>
            </div>

            <hr>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Rol</label>
                    <input type="text" class="form-control" value="<%= usuario.getRol() %>" readonly>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Estado</label>
                    <input type="text" class="form-control" value="<%= usuario.getEstado() == 1 ? "Activo" : "Inactivo" %>" readonly>
                </div>
            </div>

            <input type="hidden" name="idusuario" value="<%= usuario.getIdusuario() %>">
            <div class="text-end">
                <button type="submit" class="btn btn-primary mt-3">Guardar Cambios</button>
            </div>
        </form>
    </div>
</div>

<script>
    function validarFormulario() {
        const actual = document.getElementById("contrasenaActual").value;
        const nueva = document.getElementById("nuevaContrasena").value;

        if (nueva.length > 0 && actual.length === 0) {
            Swal.fire('Advertencia', 'Debes ingresar tu contraseña actual para cambiarla.', 'warning');
            return false;
        }

        if (nueva.length > 0) {
            const regex = /^(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
            if (!regex.test(nueva)) {
                Swal.fire('Error', 'La nueva contraseña no cumple con los requisitos.', 'error');
                return false;
            }
        }
        return true;
    }
</script>

<%-- Alertas desde parámetros --%>
<%
    String error = request.getParameter("error");
    String success = request.getParameter("success");

    if ("contrasena".equals(error)) {
%>
    <script>
        Swal.fire('Error', 'La contraseña actual es incorrecta.', 'error');
    </script>
<%
    } else if ("true".equals(success)) {
%>
    <script>
        Swal.fire('Éxito', 'Tu perfil fue actualizado.', 'success');
    </script>
<%
    }
%>
</body>
</html>
