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

1. Install Wsl
   [ Windows Subsystem for Linux ](https://learn.microsoft.com/en-us/windows/wsl/about)(WSL) is a feature of Windows that allows you to run a Linux environment on your Windows machine

```powershell
wsl --install
wsl --set-default-version 2
```

2. Install a Linux Distribution
   Install Ubuntu

```powershell
wsl.exe --install Ubuntu
```

3. Install Winyank32
   Install winyank32, a clipboard tool for Windows.
   We can copy and paste from windows to Wsl.

```powershell
winget install --id=equalsraf.win32yank  -e
```

## Steps to do before running the script

1. Open the emulator terminal
2. Git clone the [ script repo ](#) at your home directory
3. Set to executable every file in the directory:

```bash
chmod +x ./run.zsh
chmod +x ./runs/*
```

4. Run the command by doing:

```zsh
./run.zsh
```

## Steps that runs the script

1. Set bash as default shell
2.
