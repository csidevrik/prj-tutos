# Crear una nueva variable de entorno llamada JAVA_HOME
Set-Item -Path 'Env:JAVA_HOME' -Value 'C:\Program Files\OpenLogic\jdk-17.0.5.8-hotspot'

# Obtener el valor actual del PATH
$currentPath = [Environment]::GetEnvironmentVariable('PATH', 'Machine')

# Obtener la ruta de JAVA_HOME
$javaHomePath = [Environment]::GetEnvironmentVariable('JAVA_HOME', 'Machine')

# Agregar la ruta de JAVA_HOME al PATH
$newPath = "$currentPath;$javaHomePath\bin"

# Actualizar el valor del PATH
[Environment]::SetEnvironmentVariable('PATH', $newPath, 'Machine')