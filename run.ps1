# run.ps1

# Verificar requisitos previos
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Git no esta instalado. Descarga e instala desde https://git-scm.com/download/win" -ForegroundColor Red
    exit 1
}
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Scoop no esta instalado. Instalalo con: Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio")) {
    Write-Host "Error: Visual Studio no esta instalado. Instala Visual Studio con las herramientas de compilacion C++ desde https://visualstudio.microsoft.com/downloads/" -ForegroundColor Red
    exit 1
}
if (-not (Get-Command wezterm -ErrorAction SilentlyContinue)) {
    Write-Host "Error: WezTerm no esta instalado. Descarga e instala desde https://wezfurlong.org/wezterm/install/windows.html" -ForegroundColor Red
    exit 1
}

# Verificar politica de ejecucion
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -eq "Restricted") {
    Write-Host "Error: La politica de ejecucion es 'Restricted'. Ejecuta 'Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned' en PowerShell como administrador y vuelve a intentar." -ForegroundColor Red
    exit 1
}

Write-Host "Todos los requisitos previos estan instalados. Configurando el entorno..."

# Actualizar Scoop y anadir buckets
scoop update
scoop bucket add extras
scoop bucket add versions
scoop bucket add nerd-fonts # Fuente para WezTerm
scoop install nerd-fonts/Mononoki-NF # Fuente para WezTerm
scoop bucket add main # Para plugins de Neovim (pynvim)
scoop install main/python # Para plugins de Neovim (pynvim)
# Instalar herramientas con Scoop
$tools = @(
    "neovim",           # Editor principal
    "yazi",             # Administrador de archivos
    # "extras/glazewm",   # Administrador de ventanas tiling
    "extras/komorebi",   # Administrador de ventanas tiling (Probando uno nuevo)
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
    "ffmpeg",           # Previsualizacion de videos en Yazi
    "7zip",             # Soporte para archivos comprimidos
    "jq",               # Procesamiento JSON
    "poppler",          # Previsualizacion de PDFs en Yazi
    "fd",               # Busqueda rapida de archivos
    "fzf",              # Busqueda fuzzy
    "zoxide",           # Navegacion inteligente de directorios
    "imagemagick"       # Previsualizacion de imagenes en Yazi
    "ghostcript"       # Previsualizacion de pdfs
    "main/nvm"       # Node Version Manager
    "main/bitwarden-cli"       # Node Version Manager
)
foreach ($tool in $tools) {
    if (-not (Get-Command $tool.Split("/")[-1] -ErrorAction SilentlyContinue)) {
        Write-Host "Instalando $tool..."
        scoop install $tool
    } else {
        Write-Host "$tool ya esta instalado."
    }
}

# Instalar modulos de PowerShell
if (-not (Get-Module -ListAvailable -Name posh-git)) {
    Write-Host "Instalando posh-git..."
    Install-Module -Name posh-git -Scope CurrentUser -Force
}
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Write-Host "Instalando Terminal-Icons..."
    Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force
}

# Configurar directorios y copiar archivos desde dotfiles/
$weztermFile = "$HOME\.wezterm.lua"
$nvimDir = "$HOME\AppData\Local\nvim"
# $glazewmDir = "$HOME"
$psProfileDir = "$HOME\Documents\PowerShell"
$psProfileDirJustInCase = "$HOME\Documents\WindowsPowerShell"
$yaziDir = "$HOME\AppData\Local\yazi\config"
$komorebiDir = "$HOME"
$whkdrcDir = "$HOME\.config"

if (-not (Test-Path $nvimDir)) { mkdir $nvimDir -Force }
# if (-not (Test-Path $glazewmDir)) { mkdir $glazewmDir -Force }
if (-not (Test-Path $komorebiDir )) { mkdir $komorebiDir  -Force }
if (-not (Test-Path $whkdrcDir  )) { mkdir $whkdrcDir   -Force }
if (-not (Test-Path $psProfileDir)) { mkdir $psProfileDir -Force }
if (-not (Test-Path $psProfileDir)) { mkdir $psProfileDirJustInCase Force }
if (-not (Test-Path $yaziDir)) { mkdir $yaziDir -Force }

Copy-Item -Path ".\dotfiles\wezterm\.wezterm.lua" -Destination $weztermFile -Force
Copy-Item -Path ".\dotfiles\nvim\*" -Destination $nvimDir -Recurse -Force
Copy-Item -Path ".\dotfiles\komorebi\komorebi.bar.json" -Destination $komorebiDir -Recurse -Force
Copy-Item -Path ".\dotfiles\komorebi\komorebi.json" -Destination $komorebiDir -Recurse -Force
Copy-Item -Path ".\dotfiles\komorebi\whkdrc" -Destination $whkdrcDir  -Recurse -Force
# Copy-Item -Path ".\dotfiles\glazewm\*" -Destination $glazewmDir -Recurse -Force
Copy-Item -Path ".\dotfiles\powershell\Microsoft.PowerShell_profile.ps1" -Destination "$psProfileDir\Microsoft.PowerShell_profile.ps1" -Force
Copy-Item -Path ".\dotfiles\powershell\Microsoft.PowerShell_profile.ps1" -Destination "$psProfileDirJustInCase\Microsoft.PowerShell_profile.ps1" -Force
Copy-Item -Path ".\dotfiles\yazi\config\*" -Destination $yaziDir -Recurse -Force

Write-Host "Configuracion completada. Reinicia WezTerm y usa Ctrl+a y para abrir Yazi."
Write-Host "Asegurate de ajustar $env:YAZI_FILE_ONE en $PROFILE con la ruta de file.exe de tu instalacion de Git."

