package Controlador;

import DAO.UsuarioDAO;
import Modelo.modeloUsuario;
import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.regex.*;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    UsuarioDAO dao = new UsuarioDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dniStr = request.getParameter("dni");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String correo = request.getParameter("correo");
        String contrasena = request.getParameter("contrasena");

        // Validar campos vacíos
        if (dniStr == null || nombre == null || apellido == null || correo == null || contrasena == null ||
            dniStr.trim().isEmpty() || nombre.trim().isEmpty() || apellido.trim().isEmpty() ||
            correo.trim().isEmpty() || contrasena.trim().isEmpty()) {
            request.setAttribute("mensaje", "Todos los campos son obligatorios.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // Validar DNI de 8 dígitos numéricos
        if (!dniStr.matches("\\d{8}")) {
            request.setAttribute("mensaje", "DNI inválido. Debe tener exactamente 8 dígitos numéricos.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // Validar que nombre y apellido contengan solo letras y espacios
        if (!nombre.matches("[a-zA-ZÁÉÍÓÚáéíóúÑñ ]+") || !apellido.matches("[a-zA-ZÁÉÍÓÚáéíóúÑñ ]+")) {
            request.setAttribute("mensaje", "Nombre y Apellido solo deben contener letras.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // Validar contraseña: mínimo 8 caracteres, 1 mayúscula, 1 número, 1 caracter especial
        Pattern pattern = Pattern.compile("^(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-={}:;\"',.<>?/]).{8,}$");
        Matcher matcher = pattern.matcher(contrasena);
        if (!matcher.matches()) {
            request.setAttribute("mensaje", "La contraseña debe tener al menos 8 caracteres, una mayúscula, un número y un caracter especial.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // Convertir DNI
        int dni = Integer.parseInt(dniStr);

        // Validar si DNI ya existe
        if (dao.existeDni(dni)) {
            request.setAttribute("mensaje", "El DNI ya está registrado.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // Validar si correo ya existe
        if (dao.existeCorreo(correo)) {
            request.setAttribute("mensaje", "El correo ya está registrado.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }

        // Crear usuario
        modeloUsuario usuario = new modeloUsuario();
        usuario.setDni(dni);
        usuario.setNombre(nombre);
        usuario.setApellido(apellido);
        usuario.setCorreo(correo);
        usuario.setContrasena(contrasena);
        usuario.setRol("USER");  // Asignar rol por defecto
        usuario.setEstado(1);    // Estado activo

        // Intentar registrar
        if (dao.registrarUsuario(usuario)) {
            response.sendRedirect("Login.jsp");
        } else {
            request.setAttribute("mensaje", "Error al registrar. Intenta nuevamente.");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
        }
    }
}
