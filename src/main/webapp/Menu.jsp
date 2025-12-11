<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.modeloUsuario"%>
<%@page session="true"%>
<%
    modeloUsuario usuario = (modeloUsuario) session.getAttribute("usuario");
    if (usuario == null) {
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
                <a href="inicio.jsp" class="zqx-navlink-xx">
                    <i class="bi bi-house-fill"></i> Inicio
                </a>
            </div>
            <div class="zqx-navitem-88">
                <a href="#" class="zqx-navlink-xx zqx-togglebtn-tt">
                    <i class="bi bi-clipboard-check-fill"></i> Encuestas
                    <i class="bi bi-chevron-right zqx-toggleicon-r"></i>
                </a>
                <div class="zqx-submenu-yy">
                    <a href="Emovil.jsp" class="zqx-navlink-xx">Encuesta Móvil</a>
                    <a href="Ehome.jsp" class="zqx-navlink-xx">Encuesta Hogar</a>
                    <a href="MisEncuestas.jsp" class="zqx-navlink-xx">Encuestas Respondidas</a>
                </div>
            </div>
           <div class="zqx-navitem-88">
                <a href="Disponibilidad.jsp" class="zqx-navlink-xx">
                    <i class="bi bi-check-all"></i> Disponibilidad
                </a>
            </div>
              <div class="zqx-navitem-88">
                <a href="Eficiencia.jsp" class="zqx-navlink-xx">
                    <i class="bi bi-gear-fill"></i> Eficiencia
                </a>
            </div>
              <div class="zqx-navitem-88">
                <a href="senal.jsp" class="zqx-navlink-xx">
                    <i class="bi bi-router-fill"></i> Calidad de Señal
                </a>
            </div>
             <div class="zqx-navitem-88">
                 <a href="ReporteServlet" class="zqx-navlink-xx">
                    <i class="bi bi-exclamation-triangle-fill"></i> Reclamar
                </a>
            </div>
            <div class="zqx-navitem-88">
                <a href="Perfil.jsp" class="zqx-navlink-xx">
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
