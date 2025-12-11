# ==== STAGE 1: Build WAR ====
FROM maven:3.8.5-openjdk-8 AS build

WORKDIR /app

# Copiar pom.xml y descargar dependencias primero (para cache)
COPY pom.xml /app/
RUN mvn dependency:go-offline -B

# Copiar el resto del proyecto
COPY . /app

# Construir el proyecto (WAR)
RUN mvn -q -DskipTests package


# ==== STAGE 2: Tomcat para ejecutar WAR ====
FROM tomcat:9.0-jdk8

# Limpiar aplicaciones por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el WAR generado al ROOT de Tomcat
COPY --from=build /app/target/Opemax_v1-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
