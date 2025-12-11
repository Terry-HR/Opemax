
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Iniciar Sesion</title>
  <link rel="stylesheet" href="css/styleLogin.css" />
  <!-- Font Awesome CDN link for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" />
</head>
<body>
    <a href="index.jsp">
    <button  class="fixed-button" aria-label="Botón fijo arriba a la izquierda">Inicio</button>
    </a>
  <div class="wrapper">
    <div class="title"><span>Iniciar Sesion</span></div>
    <center>
    <p style="color:red;">
        <%= request.getAttribute("mensaje") != null ? request.getAttribute("mensaje") : "" %>
    </p>
    </center>
    <form action="LoginServlet" method="post">
      <div class="row">
        <i class="fas fa-user"></i>
        <input type="text" placeholder="Correo Electronico" name="correo" required />
      </div>
      <div class="row">
        <i class="fas fa-lock"></i>
        <input type="password" placeholder="Contraseña" name="contrasena" required />
      </div>
      <div class="row button">
        <input type="submit" value="Iniciar Sesion" />
      </div>
      <div class="signup-link">No te encuentras registrado?<a href="Register.jsp"> Registrarse</a></div>
    </form>
  </div>
</body>
</html>