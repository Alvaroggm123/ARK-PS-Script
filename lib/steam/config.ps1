
# Validar la existencia del archivo de configuración.
$userFile = ".\steamcmd\ark-ps-script.ini"
if (-not (Test-Path -Path $userFile -PathType Leaf)) {
    "USUARIO=anonymous" | Set-Content -Path $userFile -Encoding UTF8
}
$username = (Get-Content $userFile | Select-String "^USUARIO=" | ForEach-Object { $_.ToString().Split("=")[1].Trim() })

[hashtable]$options = [ordered]@{
    "1" = "Actualizar SteamCMD"
    "2" = "Cambiar el usuario [$username]"
    "3" = "Regresar"
}

$defaultOption = "3"
$menu = [Menu]::new($options, $defaultOption)

do {
    if ($menu) {
        $menu.Show()
        $choice = $menu.GetChoice(60)
    }

    # Execute the selected option
    switch ($choice) {
        "1" {
            # Opción 1: Actualizar SteamCMD
            Invoke-Expression ".\steamcmd\steamcmd +login $username +quit"
            Pause
        }
        "2" {
            # Opción 2: Cambiar usuario
            Write-Host "Usuario actual: $username"
            $newUsername = Read-Host -Prompt "Introduce el nuevo nombre de usuario (o 'anonymous' para usuario anónimo)"

            if ($newUsername -ne $username) {
                (Get-Content $userFile) | ForEach-Object {
                    if ($_ -match "^USUARIO=") {
                        # Asignamos el usuario para escribirlo en nuestro archivo.
                        "USUARIO=$newUsername"
                    }
                    else {
                        $_
                    }
                } | Set-Content $userFile -Encoding UTF8
                # Se muestra al usuario en nuevo nombre de usuario
                Write-Host "Usuario actualizado a: $newUsername"
            }
            else {
                # Se muestra mensaje para mencionar que el usuario que se intentó registrar y el registrado son el mismo.
                Write-Host "El usuario actual y el nuevo usuario son iguales."
            }
            # Pause para mostrar el nuevo nombre de usuario que se grabó en la configuración.
            Pause
        }
    }
    # Actualizamos la variable username
    $username = (Get-Content $userFile | Select-String "^USUARIO=" | ForEach-Object { $_.ToString().Split("=")[1].Trim() })

    # Actualizamos el menú
    $options["2"] = "Cambiar el usuario [$username]"
} while ($choice -ne "3")
