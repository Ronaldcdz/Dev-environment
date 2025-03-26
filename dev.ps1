# dev.ps1 - Script para gestionar configuraciones de dotfiles
# Uso: .\dev.ps1 [-fromRoot | -toRoot | -help]

param (
    [switch]$fromRoot,
    [switch]$toRoot,
    [switch]$help
)

# Priorizar la ayuda si se usa --help
if ($help) {
    Write-Host "Script para gestionar configuraciones de dotfiles."
    Write-Host ""
    Write-Host "Uso: .\dev.ps1 [-fromRoot | -toRoot | -help]"
    Write-Host ""
    Write-Host "Parámetros:"
    Write-Host "  -fromRoot: Copia configuraciones desde `$HOME` a `dotfiles/` en el repositorio."
    Write-Host "  -toRoot: Copia configuraciones desde `dotfiles/` en el repositorio a `$HOME`."
    Write-Host "  -help: Muestra esta ayuda."
    Write-Host ""
    Write-Host "Ejemplos:"
    Write-Host "  .\dev.ps1 --fromRoot"
    Write-Host "  .\dev.ps1 --toRoot"
    exit 0
}

# Error si se usan ambos parámetros o ninguno (sin contar --help)
if (($fromRoot -and $toRoot) -or (-not $fromRoot -and -not $toRoot)) {
    Write-Host "Error: Debes usar -fromRoot o -toRoot, pero no ambos." -ForegroundColor Red
    Write-Host "$help" -ForegroundColor Red
    exit 1
}

# Definir rutas base
$repoDir = $PSScriptRoot  # Usar la ubicación del script para mayor robustez
$dotfilesDir = "$repoDir\dotfiles"

# Definir configuraciones con rutas de origen y destino
$configs = @(
    @{ fromRoot = "$HOME\.wezterm.lua"; toRoot = "$dotfilesDir\wezterm\.wezterm.lua" },
    @{ fromRoot = "$env:LOCALAPPDATA\nvim"; toRoot = "$dotfilesDir\nvim" },
    @{ fromRoot = "$HOME\.glzr"; toRoot = "$dotfilesDir\glazewm\.glzr" },
    @{ fromRoot = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"; toRoot = "$dotfilesDir\powershell\Microsoft.PowerShell_profile.ps1" },
    @{ fromRoot = "$env:LOCALAPPDATA\yazi\config"; toRoot = "$dotfilesDir\yazi\config" }
)

# Función para copiar archivos o carpetas
function Copy-Config {
    param (
        [string]$Source,
        [string]$Dest
    )
    if (Test-Path $Source) {
        $destParent = Split-Path -Path $Dest -Parent
        if (-not (Test-Path $destParent)) {
            New-Item -Path $destParent -ItemType Directory -Force | Out-Null
        }
        if (Test-Path $Source -PathType Container) {
            Copy-Item -Path "$Source\*" -Destination $Dest -Recurse -Force
        } else {
            Copy-Item -Path $Source -Destination $Dest -Force
        }
        Write-Host "Copiado $Source a $Dest"
        Write-Host ""
    } else {
        Write-Host "Advertencia: $Source no existe, omitiendo..." -ForegroundColor Yellow
    }
}

# Determinar la acción basada en los parámetros
if ($fromRoot) {
    $action = "desde $HOME a $dotfilesDir"
} else {
    $action = "desde $dotfilesDir a $HOME"
}

# Usar interpolación en lugar de concatenación
Write-Host "Copiando configuraciones $action..."
Write-Host ""

# Copiar cada configuración según la dirección especificada
foreach ($config in $configs) {
    if ($fromRoot) {
        $source = $config.fromRoot
        $dest = $config.toRoot
    } else {
        $source = $config.toRoot
        $dest = $config.fromRoot
    }
    Copy-Config -Source $source -Dest $dest
}

Write-Host "Operación completada: $action."

