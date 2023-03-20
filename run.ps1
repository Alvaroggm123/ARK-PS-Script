# Import the Menu class from Menu.ps1
. ".\lib\menu.ps1"
. ".\lib\utilities.ps1"

# Validación de carpeta steamcmd y el ejecutable steamcmd.exe.
metPathExistOrCreate(".\steamcmd\instances")

if (-not (funcFileExist(".\steamcmd\steamcmd.exe"))) {
    Invoke-WebRequest "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip" -OutFile ".\steamcmd\steamcmd.zip"
    Expand-Archive -Path ".\steamcmd\steamcmd.zip" -DestinationPath ".\steamcmd"
    Remove-Item -Path ".\steamcmd\steamcmd.zip"
}

# Creación de opciones del menú.
[hashtable]$options = [ordered]@{
    "1" = "Configurar SteamCMD"
    "2" = "Configurar parametros del Cluster"
    "3" = "Menú de instancias"
    "5" = "Salir"
}
$defaultOption = "5"

# Generación de objeto de la clase menú.
$menu = [Menu]::new($options, $defaultOption)

do {
    if ($menu) {
        $menu.Show()
        $choice = $menu.GetChoice(60)
    }
    # Execute the selected option
    switch ($choice) {
        "1" {
            # Se llama al menú de configuración de SteamCMD
            $command = ".\lib\steam\config.ps1"
            Invoke-Expression $command
        }
        "2" {
            # Configuración de los parametros del Cluster
            $command = ".\lib\cluster\config.ps1"
        }
        "3" {
            # Menú de instancias
            $command = ".\RemoveOldestBackup.ps1"
            Invoke-Expression $command
        }
        "4" {
            # Exit
            Write-Host "Exiting..."
            return
        }
        default {
        }
    }
} while ($choice -ne "5")