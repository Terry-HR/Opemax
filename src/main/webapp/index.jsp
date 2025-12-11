
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <!-- Basic -->
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!-- Mobile Metas -->
    <meta
      name="OpeMax-INICIO"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <!-- Site Metas -->
    <meta name="keywords" content="" />
    <meta name="description" content="" />
    <meta name="author" content="" />

    <title>OpeMax</title>

    <!-- slider stylesheet -->
    <link
      rel="stylesheet"
      type="text/css"
      href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.1.3/assets/owl.carousel.min.css"
    />

    <!-- bootstrap core css -->
    <link rel="stylesheet" type="text/css" href="css/bootstrap.css" />

    <!-- fonts style -->
    <link
      href="https://fonts.googleapis.com/css?family=Poppins|Raleway:400,600|Righteous&display=swap"
      rel="stylesheet"
    />
    <!-- Custom styles for this template -->
    <link href="css/style.css" rel="stylesheet" />
    <!-- responsive style -->
    <link href="css/responsive.css" rel="stylesheet" />
  </head>

  <body>
    <div class="hero_area">
      <!-- header section strats -->
      <header class="header_section">
        <div class="container-fluid">
          <nav class="navbar navbar-expand-lg custom_nav-container">
            <a class="navbar-brand" href="index.jsp">
              <span>
                OpeMax
              </span>
            </a>

            <div class="navbar-collapse" id="">
              <div
                class="d-none d-lg-flex ml-auto flex-column flex-lg-row align-items-center mt-3"
              >
                <form class="form-inline mb-3 mb-lg-0 ">
                  <button
                    class="btn  my-sm-0 nav_search-btn"
                    type="submit"
                  ></button>
                </form>
                <ul class="navbar-nav  mr-2">
                  <li class="nav-item mr-2">
                      <a class="nav-link" href="Register.jsp">
                      <span>Registrarse</span>
                    </a>
                  </li>
                </ul>
                  <ul class="navbar-nav  mr-5">
                  <li class="nav-item mr-5">
                    <a class="nav-link" href="Login.jsp">
                      <span>Iniciar Sesion</span>
                    </a>
                  </li>
                </ul>
              </div>

              <div class="custom_menu-btn">
                <button onclick="openNav()">
                  <span class="s-1"> </span>
                  <span class="s-2"> </span>
                  <span class="s-3"> </span>
                </button>
              </div>
              <div id="myNav" class="overlay">
                <div class="overlay-content">
                    <a href="index.jsp">Inicio</a>
                    <a href="Login.jsp">Iniciar Sesion</a>
                    <a href="Register.jsp">Registrarse</a>
                </div>
              </div>
            </div>
          </nav>
        </div>
      </header>
      <!-- end header section -->
      <!-- slider section -->
      <section class=" slider_section position-relative">
        <div class="container">
          <div
            id="carouselExampleControls"
            class="carousel slide"
            data-ride="carousel"
          >
            <div class="carousel-inner">
              <div class="carousel-item active">
                <div class="slider_item-box">
                  <div class="slider_item-container">
                    <div class="slider_item-detail">
                      <h1>
                        Tu opinión importa, nuestra red se perfecciona
                      </h1>
                      <p>
                        Al priorizar la retroalimentación del usuario y convertirla en información accionable,
                        transformamos cada conexión en una experiencia de navegación superior.
                      </p>
                      <div>
                        <a href="Login.jsp">
                          AYUDANOS
                        </a>
                      </div>
                    </div>
                    <div class="slider_item-imgbox">
                      <img src="imagenes/laptop.png" alt="" />
                    </div>
                  </div>
                </div>
              </div>
              
      </section>
    </div>


    <section class="about_section layout_padding">
      <div class="container">
        <h2 class="text-uppercase">
          QUE HACEMOS?
        </h2>
      </div>

      <div class="container">
        <div class="about_card-container layout_padding2-top">
          <div class="about_card">
            <div class="about-detail">
              <div class="about_img-container">
                <div class="about_img-box">
                  <img src="imagenes/work1.png" alt="" />
                </div>
              </div>
              <div class="card_detail-ox">
                <h4>
                  RECOLECCION DE DATOS
                </h4>
                <p>
                 En nuestro esfuerzo por brindarte la mejor experiencia,
                 la recolección de datos del usuario es fundamental. 
                 Donde analizamos información crucial sobre la cobertura de red móvil,
                 las velocidades de internet y la estabilidad de las conexiones en tu ubicación.
                </p>
              </div>
            </div>
          </div>
          <div class="about_card">
            <div class="about-detail">
              <div class="about_img-container">
                <div class="about_img-box">
                  <img src="imagenes/work2.png" alt="" />
                </div>
              </div>
              <div class="card_detail-ox">
                <h4>
                  GRAFICOS
                </h4>
                <p>
                 En un mundo cada vez más conectado, la elección de tu operador de telefonía móvil 
                 o servicio de internet puede marcar una gran diferencia. Por eso, nos dedicamos a 
                 transformar la información sobre cobertura de red móvil, velocidades de internet y 
                 estabilidad de conexión en gráficos claros y fáciles de entender.
                </p>
              </div>
            </div>
          </div>
          <div class="about_card">
            <div class="about-detail">
              <div class="about_img-container">
                <div class="about_img-box">
                  <img src="imagenes/work3.png" alt="" />
                </div>
              </div>
              <div class="card_detail-ox">
                <h4>
                  GARANTIZAR UNA MEJOR TOMA DE DECISION 
                </h4>
                <p>
                  Nuestro objetivo es simplificar el proceso de contratacion de servicios. Al presentarte información clara y visual
                  sobre la cobertura de red móvil, las velocidades de internet y la calidad de conexión, 
                  te damos las herramientas para que tomes la mejor decisión.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- end about section -->

    <!-- who section -->
    <section class="who_section">
      <div class="container who_container">
        <div class="who_img-box">
          <img src="imagenes/OpeMax.png" alt="" />
        </div>
        <div class="who_deail-box">
          <h2>
            Qué es OpeMax?
          </h2>
          <p>
           Somos una página web enfocada a brindar información clara y visual 
           sobre los servicios de telecomunicaciones en el Perú. Esto gracias a la recopilación de datos clave 
           sobre la cobertura de red móvil, las velocidades de internet y la estabilidad 
           de las conexiones, transformándolos en gráficos intuitivos. Nuestro objetivo 
           es que tengas el poder de tomar la mejor decisión al contratar tu servicio de 
           telefonía o internet, alineándonos con la labor de Osiptel, el organismo supervisor, 
           que vela por la calidad del servicio y los derechos de los usuarios en el país. En resumen,
           te ofrecemos las herramientas para elegir con mayor confianza y asegurarte una buena calidad de servicio.
          </p>
        </div>
      </div>
    </section>
 
    <!-- info section -->
    <section class="info_section layout_padding">
      <div class="col-sm-12 d-flex justify-content-center">
        
          <h5>
                  REDES SOCIALES
                </h5>
              </div>
            
        <div class="d-flex flex-column flex-lg-row justify-content-center align-items-center align-items-lg-baseline">
          <div class="social-box">
            <a href="">
              <img src="imagenes/fb.png" alt="" />
            </a>

            <a href="">
              <img src="imagenes/twitter.png" alt="" />
            </a>
            <a href="">
              <img src="imagenes/linkedin1.png" alt="" />
            </a>
            <a href="">
              <img src="imagenes/instagram1.png" alt="" />
            </a>
          </div>
        </div>
      </div>
    </section>

    <section class="container-fluid footer_section">
      <p>
        &copy; 2025 Todos los derechos reservados.
        <a href="">OpeMax</a>
      </p>
    </section>
    <!-- footer section -->

    <script type="text/javascript" src="js/jquery-3.4.1.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.js"></script>

    <script>
      function openNav() {
        document.getElementById("myNav").classList.toggle("menu_width");
        document
          .querySelector(".custom_menu-btn")
          .classList.toggle("menu_btn-style");
      }
    </script>
  </body>
</html>
