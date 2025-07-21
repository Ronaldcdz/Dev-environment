# dev.ps1 - Script para gestionar configuraciones de dotfiles
# Uso: .\dev.ps1 [-fromRoot | -toRoot | -help]

param (
  [switch]$fromRoot,
  [switch]$toRoot,
  [switch]$help
)

# Priorizar la ayuda si se usa --help
if ($help)
{
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
  Write-Host "  .\dev.ps1 -fromRoot"
  Write-Host "  .\dev.ps1 -toRoot"
  exit 0
}

# Error si se usan ambos parámetros o ninguno
if (($fromRoot -and $toRoot) -or (-not $fromRoot -and -not $toRoot))
{
  Write-Host "Error: Debes usar -fromRoot o -toRoot, pero no ambos." -ForegroundColor Red
  exit 1
}

# Definir rutas base
$repoDir = $PSScriptRoot
$dotfilesDir = "$repoDir\dotfiles"

# Definir configuraciones
$configs = @(
  @{ fromRoot = "$HOME\.wezterm.lua"; toRoot = "$dotfilesDir\wezterm\.wezterm.lua" },
  @{ fromRoot = "$env:LOCALAPPDATA\nvim"; toRoot = "$dotfilesDir\nvim" },
  @{ fromRoot = "$HOME\.config\whkdrc"; toRoot = "$dotfilesDir\komorebi\whkdrc" },
  @{ fromRoot = "$HOME\komorebi-work.json"; toRoot = "$dotfilesDir\komorebi\komorebi-work.json" },
  @{ fromRoot = "$HOME\komorebi-home.json"; toRoot = "$dotfilesDir\komorebi\komorebi-home.json" },
  @{ fromRoot = "$HOME\komorebi.bar.json"; toRoot = "$dotfilesDir\komorebi\komorebi.bar.json" },
  @{ fromRoot = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"; toRoot = "$dotfilesDir\powershell\Microsoft.PowerShell_profile.ps1" },
  @{ fromRoot = "$env:LOCALAPPDATA\yazi\config"; toRoot = "$dotfilesDir\yazi\config" },
  @{ fromRoot = "$HOME\.config\yasb"; toRoot = "$dotfilesDir\yasb" }
)

# Función para limpiar directorio destino
function Clear-Destination
{
  param ([string]$Path)
  if (Test-Path $Path -PathType Container)
  {
    Get-ChildItem -Path $Path -Recurse | Remove-Item -Recurse -Force
    Write-Host "Directorio limpado: $Path"
  }
}

# Función para copiar archivos o carpetas (con limpieza universal)
function Copy-Config
{
  param (
    [string]$Source,
    [string]$Dest
  )
  if (Test-Path $Source)
  {
    $destParent = Split-Path -Path $Dest -Parent
    if (-not (Test-Path $destParent))
    {
      New-Item -Path $destParent -ItemType Directory -Force | Out-Null
    }
        
    # Limpiar destino SIEMPRE (tanto para -fromRoot como -toRoot)
    if (Test-Path $Source -PathType Container)
    {
      Clear-Destination -Path $Dest
    }

    if (Test-Path $Source -PathType Container)
    {
      # Crear directorio destino si no existe
      if (-not (Test-Path $Dest))
      {
        New-Item -Path $Dest -ItemType Directory -Force | Out-Null
      }
      Copy-Item -Path "$Source\*" -Destination $Dest -Recurse -Force
    } else
    {
      # Para archivos individuales, solo sobrescribir
      Copy-Item -Path $Source -Destination $Dest -Force
    }
    Write-Host "Copiado $Source a $Dest"
    Write-Host ""
  } else
  {
    Write-Host "Advertencia: $Source no existe, omitiendo..." -ForegroundColor Yellow
  }
}

# Determinar la acción
if ($fromRoot)
{
  $action = "desde $HOME a $dotfilesDir"
} else
{
  $action = "desde $dotfilesDir a $HOME"
}

Write-Host "Copiando configuraciones $action..."
Write-Host ""

# Copiar cada configuración
foreach ($config in $configs)
{
  if ($fromRoot)
  {
    $source = $config.fromRoot
    $dest = $config.toRoot
  } else
  {
    $source = $config.toRoot
    $dest = $config.fromRoot
  }
  Copy-Config -Source $source -Dest $dest
}

Write-Host "Operación completada: $action."
