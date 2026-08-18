# ==============================================================================
# backup_parkour.ps1
# Automatización de respaldo de la base de datos PostgreSQL
# ==============================================================================

$pgDump = "C:\Program Files\PostgreSQL\18\bin\pg_dump.exe"
$database = "db_final"
$user = "postgres"

$backupDir = "C:\Users\angel\Downloads\BD\proyecto-final-DB\automatizacion\backups"

# Crear carpeta de respaldos si no existe
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
}

# Generar nombre con fecha y hora
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFile = Join-Path $backupDir "parkour_backup_$timestamp.dump"

Write-Host "Iniciando respaldo..."
Write-Host "Base de datos: $database"
Write-Host "Archivo: $backupFile"

# Ejecutar pg_dump
& $pgDump -U $user -F c -d $database -f $backupFile

# Comprobar resultado
if ($LASTEXITCODE -eq 0 -and (Test-Path $backupFile)) {
    $size = (Get-Item $backupFile).Length

    Write-Host "Respaldo realizado correctamente."
    Write-Host "Tamaño: $size bytes"
} else {
    Write-Host "Error: el respaldo no pudo completarse."
    exit 1
}