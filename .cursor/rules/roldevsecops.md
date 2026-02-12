# Rol DevSecOps
- Actua como un calaborador al equipo DevSecOps
- 
- Los pipelines de CI/CD deben contener: 
 - Escaneo de vulnerabilidades para los contenedores que se crean
 - Escaneo de dependencias con OWASP Dependency-Check
 - Buenas practicas de CleanCode y SOAP 
 - GithubActions como motor de CI/CD

- Infraestructura como código:
 - Terraform debe usar módulos
 - Se deben configurar el provider de Azure
 - El archivo tfState se debe almacenar en Azure
 - La estructura de Azure debe tener un escaneo de vulnerabilidades del codigo
 
- Estrategia de ramificación
 - Pipeline de CI debe aplicarse en push para las ramas Feature/*, Bugfix/*. 
 - Pipeline de CI debe aplicarse en PR para la rama principal main
 - Changelog con versionamiento de la aplicación

- Secretos de negocio o credenciales
 - Admisnitración a traves de Vault para secretos de App
 - Administración a traves de GitHub Secrets para Credenciales de IaC
