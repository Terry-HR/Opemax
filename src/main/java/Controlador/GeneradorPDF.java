package Controlador;

import Modelo.modeloReporte;
import Modelo.modeloUsuario;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

public class GeneradorPDF {

    public static void generarPDF(modeloReporte reporte, modeloUsuario usuario, String rutaImagen, HttpServletResponse response) {
        try {
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=Reporte_" + reporte.getIdreporte() + ".pdf");

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Imagen/logo
            Image img = Image.getInstance(rutaImagen);
            img.scaleToFit(100, 100);
            img.setAlignment(Image.ALIGN_CENTER);
            document.add(img);

            // Espaciado
            document.add(new Paragraph(" "));

            // Título
            Paragraph titulo = new Paragraph("Formulario de Reclamo", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20, BaseColor.DARK_GRAY));
            titulo.setAlignment(Element.ALIGN_CENTER);
            document.add(titulo);

            document.add(new Paragraph(" "));

            // Tabla de datos del usuario y reclamo
            PdfPTable tabla = new PdfPTable(2);
            tabla.setWidthPercentage(100);
            tabla.setSpacingBefore(10f);
            tabla.setSpacingAfter(10f);

            PdfPCell celda;

            celda = new PdfPCell(new Phrase("DNI"));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);
            tabla.addCell(String.valueOf(usuario.getDni()));

            celda = new PdfPCell(new Phrase("Nombre"));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);
            tabla.addCell(usuario.getNombre());

            celda = new PdfPCell(new Phrase("Apellido"));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);
            tabla.addCell(usuario.getApellido());

            celda = new PdfPCell(new Phrase("Correo"));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);
            tabla.addCell(usuario.getCorreo());

            celda = new PdfPCell(new Phrase("Fecha Ingreso"));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);
            tabla.addCell(reporte.getFecha_ing());

            celda = new PdfPCell(new Phrase("Servicio"));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);
            tabla.addCell(reporte.getServicio());

            celda = new PdfPCell(new Phrase("Empresa"));
            celda.setBackgroundColor(BaseColor.LIGHT_GRAY);
            tabla.addCell(celda);
            tabla.addCell(reporte.getEmpresa());

            document.add(tabla);

            // Espacio
            document.add(new Paragraph(" "));

            // Recuadro para el reclamo
            Paragraph reclamoTitulo = new Paragraph("Descripción del Reclamo:", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14));
            document.add(reclamoTitulo);

            PdfPCell reclamoCell = new PdfPCell(new Phrase(reporte.getReclamo()));
            reclamoCell.setBorderColor(BaseColor.GRAY);
            reclamoCell.setPadding(10f);
            reclamoCell.setColspan(2);
            reclamoCell.setMinimumHeight(100);
            reclamoCell.setBackgroundColor(new BaseColor(245, 245, 245));

            PdfPTable tablaReclamo = new PdfPTable(1);
            tablaReclamo.setWidthPercentage(100);
            tablaReclamo.setSpacingBefore(5f);
            tablaReclamo.addCell(reclamoCell);
            document.add(tablaReclamo);

            // Cierre
            document.close();

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error al generar PDF individual", e);
        }
    }

    public static void generarPDFTodosReportes(List<modeloReporte> reportes, modeloUsuario usuario, String rutaImagen, HttpServletResponse response) {
        Document document = null;
        try {
            System.out.println("GeneradorPDF: Iniciando generación de PDF...");
            
            // Configurar respuesta
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=Todos_Reportes_" + usuario.getDni() + ".pdf");
            
            document = new Document();
            PdfWriter writer = PdfWriter.getInstance(document, response.getOutputStream());
            document.open();
            
            System.out.println("GeneradorPDF: Documento PDF creado");

            // Imagen/logo (manejar si no existe)
            try {
                if (rutaImagen != null && new java.io.File(rutaImagen).exists()) {
                    Image img = Image.getInstance(rutaImagen);
                    img.scaleToFit(100, 100);
                    img.setAlignment(Image.ALIGN_CENTER);
                    document.add(img);
                    document.add(new Paragraph(" "));
                    System.out.println("GeneradorPDF: Logo añadido");
                } else {
                    System.out.println("GeneradorPDF: Logo no encontrado, continuando sin imagen");
                }
            } catch (Exception e) {
                System.out.println("GeneradorPDF: Error con logo - " + e.getMessage());
            }

            // Título principal
            Paragraph titulo = new Paragraph("Historial Completo de Reclamos", 
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.DARK_GRAY));
            titulo.setAlignment(Element.ALIGN_CENTER);
            document.add(titulo);

            // Información del usuario
            Paragraph infoUsuario = new Paragraph("Usuario: " + usuario.getNombre() + " " + usuario.getApellido() + 
                " - DNI: " + usuario.getDni(), FontFactory.getFont(FontFactory.HELVETICA, 12));
            infoUsuario.setAlignment(Element.ALIGN_CENTER);
            document.add(infoUsuario);

            document.add(new Paragraph(" "));
            document.add(new Paragraph(" "));

            if (reportes == null || reportes.isEmpty()) {
                System.out.println("GeneradorPDF: No hay reportes para mostrar");
                Paragraph sinReportes = new Paragraph("No hay reportes registrados", 
                    FontFactory.getFont(FontFactory.HELVETICA, 14));
                sinReportes.setAlignment(Element.ALIGN_CENTER);
                document.add(sinReportes);
            } else {
                System.out.println("GeneradorPDF: Procesando " + reportes.size() + " reportes");
                
                // Tabla principal de reportes
                PdfPTable tablaReportes = new PdfPTable(7);
                tablaReportes.setWidthPercentage(100);
                tablaReportes.setSpacingBefore(10f);
                tablaReportes.setSpacingAfter(10f);

                float[] columnWidths = {1f, 1.5f, 1.5f, 3f, 1.5f, 1.5f, 1.5f};
                tablaReportes.setWidths(columnWidths);

                // Encabezados de la tabla
                String[] headers = {"ID", "Servicio", "Empresa", "Reclamo", "Fecha Ingreso", "Fecha Fin", "Estado"};
                for (String header : headers) {
                    PdfPCell headerCell = new PdfPCell(new Phrase(header, 
                        FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
                    headerCell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                    headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    tablaReportes.addCell(headerCell);
                }

                // Datos de los reportes
                for (modeloReporte reporte : reportes) {
                    // ID
                    tablaReportes.addCell(new Phrase(String.valueOf(reporte.getIdreporte())));
                    
                    // Servicio
                    tablaReportes.addCell(new Phrase(reporte.getServicio()));
                    
                    // Empresa
                    tablaReportes.addCell(new Phrase(reporte.getEmpresa()));
                    
                    // Reclamo (truncado si es muy largo)
                    String reclamo = reporte.getReclamo();
                    if (reclamo.length() > 50) {
                        reclamo = reclamo.substring(0, 50) + "...";
                    }
                    tablaReportes.addCell(new Phrase(reclamo));
                    
                    // Fecha Ingreso
                    tablaReportes.addCell(new Phrase(reporte.getFecha_ing()));
                    
                    // Fecha Fin
                    String fechaFin = (reporte.getFecha_fin() != null && !reporte.getFecha_fin().isEmpty()) ? 
                        reporte.getFecha_fin() : "N/A";
                    tablaReportes.addCell(new Phrase(fechaFin));
                    
                    // Estado
                    String estadoTexto = "";
                    BaseColor estadoColor = BaseColor.WHITE;
                    
                    switch (reporte.getEstado()) {
                        case 1: 
                            estadoTexto = "Pendiente";
                            estadoColor = new BaseColor(255, 193, 7); // Amarillo
                            break;
                        case 2: 
                            estadoTexto = "En Proceso";
                            estadoColor = new BaseColor(255, 152, 0); // Naranja
                            break;
                        case 3: 
                            estadoTexto = "Finalizado";
                            estadoColor = new BaseColor(76, 175, 80); // Verde
                            break;
                        default: 
                            estadoTexto = "Desconocido";
                            estadoColor = BaseColor.LIGHT_GRAY;
                    }
                    
                    PdfPCell estadoCell = new PdfPCell(new Phrase(estadoTexto));
                    estadoCell.setBackgroundColor(estadoColor);
                    estadoCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                    tablaReportes.addCell(estadoCell);
                }

                document.add(tablaReportes);

                // Resumen estadístico
                document.add(new Paragraph(" "));
                document.add(new Paragraph(" "));
                
                long pendientes = reportes.stream().filter(r -> r.getEstado() == 1).count();
                long enProceso = reportes.stream().filter(r -> r.getEstado() == 2).count();
                long finalizados = reportes.stream().filter(r -> r.getEstado() == 3).count();
                
                Paragraph resumen = new Paragraph("Resumen de Reclamos:", 
                    FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14));
                document.add(resumen);
                
                Paragraph detalles = new Paragraph(
                    "• Pendientes: " + pendientes + "\n" +
                    "• En Proceso: " + enProceso + "\n" +
                    "• Finalizados: " + finalizados + "\n" +
                    "• Total: " + reportes.size(),
                    FontFactory.getFont(FontFactory.HELVETICA, 12));
                document.add(detalles);
            }

            // Pie de página
            document.add(new Paragraph(" "));
            Paragraph fechaGeneracion = new Paragraph("Documento generado el: " + new java.util.Date(), 
                FontFactory.getFont(FontFactory.HELVETICA_OBLIQUE, 10));
            fechaGeneracion.setAlignment(Element.ALIGN_RIGHT);
            document.add(fechaGeneracion);

            System.out.println("GeneradorPDF: PDF generado exitosamente");

        } catch (Exception e) {
            System.out.println("GeneradorPDF: Error crítico - " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error al generar PDF de todos los reportes", e);
        } finally {
            if (document != null && document.isOpen()) {
                document.close();
            }
        }
    }
}