# Import the Menu class from Menu.ps1
. ".\lib\menu.ps1"

[hashtable]$options = [ordered]@{
    "1" = "Configurar SteamCMD"
    "2" = "Configurar parametros del Cluster"
    "3" = "Menú de instancias"
    "5" = "Salir"
}
$defaultOption = "0"
$menu = [Menu]::new($options, $defaultOption)

do {
    if ($menu) {
        $menu.Show()
        $choice = $menu.GetChoice(60)
    }
    # Execute the selected option
    switch ($choice) {
        "1" {
            # Create a backup of a custom folder
            $command = ".\lib\steam\config.ps1"
            Invoke-Expression $command
        }
        "2" {
            # Backup OneDrive Documents
            $command = ".\lib\steam\instances.ps1"
        }
        "3" {
            # Remove oldest backup
            $command = ".\RemoveOldestBackup.ps1"
            Invoke-Expression $command
        }
        "4" {
            # Exit
            Write-Host "Exiting..."
            return
        }
        default {
            Write-Error "Invalid option: $choice"
        }
    }
} while ($choice -ne "4")