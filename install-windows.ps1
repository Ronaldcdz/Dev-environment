# install-windows.ps1 / run.ps1

# 1. Verificar la política de ejecución efectiva y ajustarla para el usuario actual si está bloqueada
if ((Get-ExecutionPolicy) -notin @('RemoteSigned', 'Unrestricted', 'Bypass'))
{
  Write-Host "Configurando política de ejecución a RemoteSigned para el usuario actual..." -ForegroundColor Yellow
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
}

# 2. Automatizar instalación de Scoop
if (-not (Get-Command scoop -ErrorAction SilentlyContinue))
{
  Write-Host "Scoop no está instalado. Instalando Scoop..." -ForegroundColor Yellow
  Invoke-RestMethod https://get.scoop.sh | Invoke-Expression
  
  # Recargar la variable de entorno PATH para que el script reconozca 'scoop' de inmediato
  $env:PATH += ";$HOME\scoop\shims"
}

# 3. Automatizar instalación de Git
if (-not (Get-Command git -ErrorAction SilentlyContinue))
{
  Write-Host "Git no está instalado. Instalando Git a través de Scoop..." -ForegroundColor Yellow
  scoop install git
  
  # Recargar el PATH para Git por si acaso
  $env:PATH += ";$HOME\scoop\apps\git\current\cmd"
}

# 4. Automatizar instalación de Visual Studio (Herramientas de compilación C++)
if (-not (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio") -and -not (Test-Path "C:\Program Files\Microsoft Visual Studio"))
{
  Write-Host "Visual Studio no está instalado. Instalando Visual Studio Build Tools 2022 (C++) vía Winget..." -ForegroundColor Yellow
  
  winget install --id Microsoft.VisualStudio.2022.BuildTools --override "--passive --locale es-ES --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended" --accept-source-agreements --accept-package-agreements
  
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Hubo un problema instalando Visual Studio. Es posible que requieras ejecutar este script como Administrador." -ForegroundColor Red
    exit 1
  }
}

Write-Host "Todos los requisitos previos están listos o instalados. Configurando el entorno..."

# =========================================================================
# 5. Clonar tu repositorio de entorno de desarrollo
# =========================================================================
$repoUrl = "https://github.com/Ronaldcdz/Dev-environment.git"
$targetDir = "$HOME\Dev-environment"

# Si no existe la carpeta 'dotfiles' en el directorio actual, manejamos la clonación
if (-not (Test-Path ".\dotfiles"))
{
  if (-not (Test-Path $targetDir))
  {
    Write-Host "Clonando el repositorio Dev-environment en $targetDir..." -ForegroundColor Yellow
    git clone $repoUrl $targetDir
  }
  else
  {
    Write-Host "El repositorio ya existe en $targetDir. Actualizando cambios locales con git pull..." -ForegroundColor Yellow
    Push-Location $targetDir
    git pull
    Pop-Location
  }

  # Cambiar la ubicación de ejecución a la carpeta clonada para asegurar las rutas relativas
  Set-Location $targetDir
}
# =========================================================================

# Actualizar Scoop y añadir buckets
scoop update
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts # Fuente para WezTerm
scoop bucket add main # Para plugins de Neovim (pynvim)
scoop bucket add Gentleman-Programming_scoop-bucket https://github.com/Gentleman-Programming/scoop-bucket
scoop install Gentleman-Programming_scoop-bucket/gentle-ai

# Instalar herramientas con Scoop
$tools = @(
  "neovim",           # Editor principal
  # "yazi",             # Administrador de archivos
  "extras/komorebi",   # Administrador de ventanas tiling (Probando uno nuevo)
  "extras/whkd",   # Dependecia de komorebi
  "nodejs",           # Para plugins de Neovim (LSP, etc.)
  "gcc",              # Compilador para plugins
  "make",             # Herramienta de compilacion
  "ripgrep",          # Busqueda rapida para Neovim
  "lazygit",          # Interfaz Git en terminal
  "win32yank",        # Portapapeles para Neovim
  "unzip",            # Descompresion
  "gzip",             # Compresion
  "oh-my-posh",       # Prompt personalizado
  "pwsh",             # PowerShell Core
  #"ffmpeg",           # Previsualizacion de videos en Yazi
  "7zip",             # Soporte para archivos comprimidos
  "jq",               # Procesamiento JSON
  # "poppler",          # Previsualizacion de PDFs en Yazi
  "fd",               # Busqueda rapida de archivos
  "fzf",              # Busqueda fuzzy
  "zoxide",           # Navegacion inteligente de directorios
  # "imagemagick",       # Previsualizacion de imagenes en Yazi
  # "ghostscript",      # Previsualizacion de pdfs
  "main/nvm",         # Node Version Manager
  "main/luarocks",       # luarocks for nvim
  "main/netcoredbg",       # c# debugger for nvim
  "main/sqlite", # sqlite driver
  "extras/yasb", # Windows status bar written in Python
  "wezterm", # Terminal emulator
  "extras/altsnap", # tool para arrastrar ventanas desde cualquier posicion manteniendo presionado 'alt'
  "main/bun", # Incredibly fast JavaScript runtime
  "opencode", # AI coding agent.
  "main/tree-sitter", # Tool for highlighting
  "main/rustup", # Dependency for tree-sitter
  "main/python", # Python
  "nerd-fonts/Mononoki-NF", # Fuente para WezTerm
  "nerd-fonts/JetBrainsMono-NF-Propo", # Fuente para YASB
  "nerd-fonts/FiraCode-NF" # Fuente Actual para Wezterm
)

foreach ($tool in $tools)
{
  if (-not (Get-Command $tool.Split("/")[-1] -ErrorAction SilentlyContinue))
  {
    Write-Host "Instalando $tool..."
    scoop install $tool
  } else
  {
    Write-Host "$tool ya esta instalado."
  }
}

cargo install cargo-binstall
cargo binstall tree-sitter-cli

# Instalar modulos de PowerShell
if (-not (Get-Module -ListAvailable -Name posh-git))
{
  Write-Host "Instalando posh-git..."
  Install-Module -Name posh-git -Scope CurrentUser -Force
}
if (-not (Get-Module -ListAvailable -Name Terminal-Icons))
{
  Write-Host "Instalando Terminal-Icons..."
  Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force
}

# Configurar directorios y copiar archivos desde dotfiles/
$weztermFile = "$HOME\.wezterm.lua"
$nvimDir = "$HOME\AppData\Local\nvim"
$psProfileDir = "$HOME\Documents\PowerShell"
$psProfileDirJustInCase = "$HOME\Documents\WindowsPowerShell"
$komorebiDir = "$HOME"
$whkdrcDir = "$HOME\.config"
$herdrDir = "$HOME\AppData\Roaming\herdr"

if (-not (Test-Path $nvimDir)) { mkdir $nvimDir -Force }
if (-not (Test-Path $komorebiDir )) { mkdir $komorebiDir -Force }
if (-not (Test-Path $whkdrcDir )) { mkdir $whkdrcDir -Force }
if (-not (Test-Path $psProfileDir)) { mkdir $psProfileDir -Force }
if (-not (Test-Path $psProfileDirJustInCase)) { mkdir $psProfileDirJustInCase -Force }

Copy-Item -Path ".\dotfiles\wezterm\.wezterm.lua" -Destination $weztermFile -Force
Copy-Item -Path ".\dotfiles\nvim\*" -Destination $nvimDir -Recurse -Force
Copy-Item -Path ".\dotfiles\komorebi\komorebi.bar.json" -Destination $komorebiDir -Recurse -Force
Copy-Item -Path ".\dotfiles\komorebi\komorebi.json" -Destination $komorebiDir -Recurse -Force
Copy-Item -Path ".\dotfiles\komorebi\whkdrc" -Destination $whkdrcDir -Recurse -Force
Copy-Item -Path ".\dotfiles\powershell\Microsoft.PowerShell_profile.ps1" -Destination "$psProfileDir\Microsoft.PowerShell_profile.ps1" -Force
Copy-Item -Path ".\dotfiles\powershell\Microsoft.PowerShell_profile.ps1" -Destination "$psProfileDirJustInCase\Microsoft.PowerShell_profile.ps1" -Force
Copy-Item -Path ".\dotfiles\herdr\*" -Destination $herdrDir -Recurse -Force

Write-Host "Configuracion completada con exito."
