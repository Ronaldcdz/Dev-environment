# Inicializa Oh My Posh con un tema p10k
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_rainbow.omp.json" | Invoke-Expression

# Añade posh-git para información de Git
Import-Module posh-git

# Añade íconos en el terminal
Import-Module Terminal-Icons

# Call Yazi with Y
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
    }
    Remove-Item -Path $tmp
}

$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"  # Ajusta la ruta

# atajo para cd nvim
function cd-nvim {
    Set-Location -Path "$HOME\AppData\Local\nvim"
}
