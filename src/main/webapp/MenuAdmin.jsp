<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.modeloUsuario"%>
<%@page session="true"%>
<%
    modeloUsuario usuario = (modeloUsuario) session.getAttribute("usuario");
    if (usuario == null || !"ADMIN".equalsIgnoreCase(usuario.getRol())) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="css/menu-estilo.css">

<div class="zqx-sidebar-g76">
    <div>
        <div class="zqx-userinfo-001">
            <h5><i class="bi bi-person-circle"></i> Bienvenido</h5>
            <p><%= usuario.getApellido() %>, <%= usuario.getNombre() %></p>
            <small><i class="bi bi-shield-lock-fill"></i> <%= usuario.getRol() %></small>
        </div>

        <div class="zqx-navsection-003">
            <div class="zqx-navitem-88">
                <a href="DashboardAdmin" class="zqx-navlink-xx">
                    <i class="bi bi-house-fill"></i> Inicio
                </a>
            </div>
            <div class="zqx-navitem-88">
                <a href="inicio.jsp" class="zqx-navlink-xx">
                    <i class="bi bi-house-fill"></i> Inicio Usuarios
                </a>
            </div>
             <div class="zqx-navitem-88">
                <a href="#" class="zqx-navlink-xx zqx-togglebtn-tt">
                    <i class="bi bi-people-fill"></i> Usuarios
                    <i class="bi bi-chevron-right zqx-toggleicon-r"></i>
                </a>
                <div class="zqx-submenu-yy">
                    <a href="GestionUsuarioServlet" class="zqx-navlink-xx">Usuarios Activos</a>
                    <a href="UsuariosInactivosServlet" class="zqx-navlink-xx">Usuarios Suspendidos</a>
                </div>
            </div>
            <div class="zqx-navitem-88">
                <a href="#" class="zqx-navlink-xx zqx-togglebtn-tt">
                    <i class="bi bi-clipboard-check-fill"></i> Reclamos
                    <i class="bi bi-chevron-right zqx-toggleicon-r"></i>
                </a>
                <div class="zqx-submenu-yy">
                    <a href="reclamosPendientes.jsp" class="zqx-navlink-xx">Reclamos Pendientes</a>
                    <a href="ControladorReclamosEnProceso" class="zqx-navlink-xx">Reclamos En proceso</a>
                </div>
            </div>
            
            <div class="zqx-navitem-88">
                <a href="Perfila.jsp" class="zqx-navlink-xx">
                    <i class="bi bi-person-circle"></i> Perfil
                </a>
            </div>
        </div>
    </div>

    <div class="zqx-logoutsection-99">
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="zqx-navlink-xx">
            <i class="bi bi-box-arrow-right"></i> Cerrar sesión
        </a>
    </div>
</div>

<script>
    document.querySelectorAll('.zqx-togglebtn-tt').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            const parent = btn.closest('.zqx-navitem-88');
            parent.classList.toggle('zqx-open-aa');
        });
    });
</script>
