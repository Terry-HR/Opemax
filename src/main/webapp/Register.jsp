
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Registrate</title>
  <link rel="stylesheet" href="css/styleLogin.css" />
  <!-- Font Awesome CDN link for icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" />
  
</head>
<body>
     <a href="index.jsp">
    <button  class="fixed-button" aria-label="Botón fijo arriba a la izquierda">Inicio</button>
    </a>
  <div class="wrapper">
    <div class="title"><span>Registrarse</span></div>
    <center> 
       <p style="color:red;">
        <%= request.getAttribute("mensaje") != null ? request.getAttribute("mensaje") : "" %>
    </p>
    </center>
    <form action="RegistroServlet" method="post" >
      <div class="row">
        <i class="fa-solid fa-id-card"></i>
        <input type="number" placeholder="DNI" name="dni" required />
      </div>
        <div class="row">
        <i class="fas fa-user"></i>
        <input type="text" placeholder="Nombres" name="nombre" required />
      </div>
        <div class="row">
        <i class="fas fa-user"></i>
        <input type="text" placeholder="Apellidos" name="apellido" required />
      </div>
        <div class="row">
       <i class="fa-solid fa-envelope"></i>
        <input type="email" placeholder="Correo electronico" name="correo" required />
      </div>
      <div class="row">
        <i class="fas fa-lock"></i>
        <input type="password" placeholder="Password"  name="contrasena" required />
      </div>
      <div class="row button">
        <input type="submit" value="Registrarse" />
      </div>
      <div class="signup-link">Ya estas registrado<a href="Login.jsp"> Iniciar Session</a></div>
    </form>
  </div>
</body>
</html>