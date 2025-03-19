# dev.ps1

# Definir rutas de origen (ubicaciones actuales en $HOME)
$weztermSource = "$HOME\.wezterm.lua"
$nvimSource = "$HOME\AppData\Local\nvim"
$glazewmSource = "$HOME\.glzr"
$psProfileSource = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$yaziSource = "$HOME\AppData\Local\yazi\config"

# Definir rutas de destino (dentro de dotfiles/ en el repositorio)
$repoDir = Get-Location  # Directorio actual del repositorio (donde está el script)
$dotfilesDir = "$repoDir\dotfiles"
$weztermDest = "$dotfilesDir\wezterm"
$nvimDest = "$dotfilesDir\nvim"
$glazewmDest = "$dotfilesDir\glazewm"
$psProfileDest = "$dotfilesDir\powershell"
$yaziDest = "$dotfilesDir\yazi\config"

# Crear directorio dotfiles/ si no existe
if (-not (Test-Path $dotfilesDir)) {
    New-Item -Path $dotfilesDir -ItemType Directory -Force
    Write-Host "Creado directorio $dotfilesDir"
}

# Función para copiar archivos o carpetas
function Copy-Config {
    param (
        [string]$Source,
        [string]$Dest
    )
    if (Test-Path $Source) {
        # Crear directorio de destino si no existe
        if (-not (Test-Path $Dest)) {
            New-Item -Path $Dest -ItemType Directory -Force
        }
        # Copiar archivos/carpetas al destino
        Copy-Item -Path $Source -Destination $Dest -Recurse -Force
        Write-Host "Copiado $Source a $Dest"
    } else {
        Write-Host "Advertencia: $Source no existe, omitiendo..." -ForegroundColor Yellow
    }
}

# Copiar cada configuración
Copy-Config -Source $weztermSource -Dest $weztermDest
Copy-Config -Source $nvimSource -Dest $nvimDest
Copy-Config -Source $glazewmSource -Dest $glazewmDest
Copy-Config -Source $psProfileSource -Dest $psProfileDest
Copy-Config -Source $yaziSource -Dest $yaziDest

Write-Host "Actualización de dotfiles completada. Revisa $dotfilesDir y sube los cambios a Git si deseas."
