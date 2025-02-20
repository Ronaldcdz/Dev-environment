# Dev-environment

## Requirements

- Nerd font
- Terminal emulator
- Windows >= 10
- Git

## Installation for Windows

### 1. Install Git

You can easily install it with [ winget ](https://learn.microsoft.com/en-us/windows/package-manager/winget/) (is a command line tool enabling for windows).

winget install --id Git.Git -e --source winget.

### 2. Install a nerd font

A nerd font is required for terminal emulators in this setup.

I use [ Mononoki](https://www.nerdfonts.com/font-downloads), download Mononoki Nerd Font or choose whatever you want.

Just make sure to include it in your terminal config.

Changing the font in wezterm would be like [ this ](https://wezterm.org/config/fonts.html).

### 3. Install Glazewm

[ Glazewm ](https://github.com/glzr-io/glazewm?tab=readme-ov-file#installation) is a tiling window manager for Windows inspired by i3wm.

(Opcional) download my config to the glazewm path on powershell with admin priviliges:

```$repoUrl = "https://github.com/Ronaldcdz/Dev-environment.git"
$tempDir = "$env:TEMP\Dev-environment"
$destination = "$HOME\.glzr"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed" -ForegroundColor Red
    exit 1
}

if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}

git clone --depth=1 $repoUrl $tempDir

$sourceDir = "$tempDir/dotfiles/glazewm/.glzr"
if (-Not (Test-Path $sourceDir)) {
    Write-Host "Error: La carpeta .glzr no se encontró en el repositorio." -ForegroundColor Red
    exit 1
}

Copy-Item -Recurse -Force $sourceDir $destination

Remove-Item -Recurse -Force $tempDir
```

### 4. Install a terminal emulator

I use [ wezterm ](https://wezterm.org/installation.html).

(Opcional) download my config to the wezterm path:

```powershell
$weztermConfigUrl = "https://raw.githubusercontent.com/Ronaldcdz/Dev-environment/blob/main/dotfiles/wezterm/.wezterm.lua"
$destinationPath = "$HOME\.wezterm.lua"
Write-Output "Descargando configuración de WezTerm..."
try {
Invoke-WebRequest -Uri $weztermConfigUrl -OutFile $destinationPath -ErrorAction Stop
Write-Output "Archivo descargado correctamente en: $destinationPath"
} catch {
Write-Output "Error al descargar el archivo. Verifica la URL o tu conexión a internet."
}
```

### 5. Install Wsl version #2

Windows Subsystem for Linux [ (WSL) ](https://learn.microsoft.com/en-us/windows/wsl/about)

Is a feature of Windows that allows you to run a Linux environment on your Windows machine.

```powershell
wsl --install
wsl --set-default-version 2
```

### 6. Install a Linux Distribution

I use Ubuntu.

```powershell
wsl.exe --install Ubuntu
```

If doesn't work try this:

```powershell
wsl--install -d Ubuntu
```

### 7. Install Winyank32

Install winyank32, a clipboard tool for Windows.

We can copy and paste from windows to Wsl and vice versa.

```powershell
winget install --id=equalsraf.win32yank  -e
```

### 8. Open your chosen terminal emulator and create your WSL user and password

The first time you install your Ubuntu WSL it will ask you to create a user profile, typing your user and password

Is important to keep safe your password because you'll have to type it every time the
script asks for it.

## Run the script

1. Copy this script and paste it (if your using wezterm do it with CTRL+SHIFT+V):

```bash
git clone https://github.com/Ronaldcdz/Dev-environment.git
cd Dev-environment
chmod +x ./*
chmod +x ./runs/*
./dev.sh
./set-zsh.sh
./run.zsh
```

2. Restart your terminal, type tmux, press enter and do:

```tmux
CTRL+A (your prefix)
SHIFT + I
```
