# Dev-environment

## Requirements

- Nerd font
- Terminal emulator, I use [ wezterm ](https://wezterm.org/installation.html)
- Windows >= 10
- [ Glazewm ](https://github.com/glzr-io/glazewm?tab=readme-ov-file#installation)
- Admin privileges to run script
- Git
- Github logged in

## Installation for Windows

1. Install a nerd font

   A nerd font is required for terminal emulators in this setup.
   I use [ Mononoki ](https://www.nerdfonts.com/font-downloads) download Mononoki Nerd Font or choose whatever you want

2. Install a terminal emulator

   I use [ wezterm ](https://wezterm.org/installation.html)
   (Opcional) download your config to the wezterm path:

   ```powershell
   $weztermConfigUrl = "https://raw.githubusercontent.com/Ronaldcdz/dotfiles/main/wezterm/.wezterm.lua"
   $destinationPath = "$HOME\.wezterm.lua"
   Write-Output "Descargando configuración de WezTerm..."
   try {
   Invoke-WebRequest -Uri $weztermConfigUrl -OutFile $destinationPath -ErrorAction Stop
   Write-Output "Archivo descargado correctamente en: $destinationPath"
   } catch {
   Write-Output "Error al descargar el archivo. Verifica la URL o tu conexión a internet."
   }
   ```

3. Install Wsl

[ Windows Subsystem for Linux ](https://learn.microsoft.com/en-us/windows/wsl/about)(WSL) is a feature of Windows that allows you to run a Linux environment on your Windows machine

```powershell
wsl --install
wsl --set-default-version 2
```

4. Install a Linux Distribution
   Install Ubuntu

```powershell
wsl.exe --install Ubuntu
```

If doesn't work try this:

```powershell
wsl--install -d Ubuntu
```

5. Install Winyank32

   Install winyank32, a clipboard tool for Windows.
   We can copy and paste from windows to Wsl.

```powershell
winget install --id=equalsraf.win32yank  -e
```

## Steps to do before running the script

1. Open the emulator terminal
2. Git clone the [ script repo ](#) at your home directory and cd to it:

```bash
git clone https://github.com/Ronaldcdz/Dev-environment.git
cd Dev-environment
```

3. Set to executable every file in the directory:

```bash
chmod +x ./*
chmod +x ./runs/*
```

4. Run the bash command to install zsh:

```bash
./set-zsh.sh
```

5. Run the command by doing:

```zsh
./run.zsh
```

## Steps that runs the script

1. Set bash as default shell
2.
