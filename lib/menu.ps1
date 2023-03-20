class Menu {
    [hashtable]$Options
    [string]$DefaultOption

    Menu([hashtable]$options, [string]$defaultOption) {
        $this.Options = $options
        $this.DefaultOption = $defaultOption
    }

    [void]Show() {
        Clear-Host
        $consoleWidth = [Console]::WindowWidth - 2
        Write-Host ("+" + " {0,-$($consoleWidth-2)} +" -f ("-" * ($consoleWidth - 2)))
        Write-Host ("|" + " [{0,-7}] | {1,-29}" -f " Option", "Description") -NoNewline
        [Console]::SetCursorPosition(([Console]::WindowWidth - 1), 1)
        Write-Host ("|")
        Write-Host ("+" + " {0,-$($consoleWidth-2)} +" -f ("-" * ($consoleWidth - 2)))
        foreach ($item in $this.Options.GetEnumerator() | Sort-Object Key) {
            $optionText = "[ {0,5} ] | {1,-25}" -f $item.Key, $item.Value
            $optionWidth = $optionText.Length
            $paddingWidth = $consoleWidth - $optionWidth - 3
            Write-Host ("|" + " {0} {1,-$paddingWidth} |" -f $optionText, (" " * ($paddingWidth - 1)))
        }
        Write-Host ("+" + " {0,-$($consoleWidth-2)} +" -f ("-" * ($consoleWidth - 2)))
        $oldTop = [Console]::CursorTop
        Write-Host ("|" + " {0,-$($consoleWidth-2)} |" -f (" " * ($consoleWidth - 2)))
        Write-Host ("+" + " {0,-$($consoleWidth-2)} +" -f ("-" * ($consoleWidth - 2)))
        [Console]::SetCursorPosition(5, $oldTop)
        Write-Host "Option:" -NoNewline
    }

    [string]GetChoice([int]$timeoutSeconds) {
        $oldLeft = [Console]::CursorLeft
        $oldTop = [Console]::CursorTop
        $timer = New-Object System.Diagnostics.Stopwatch
        $timer.Start()
        $selectedOption = $null
        while ($timer.Elapsed.TotalSeconds -lt $timeoutSeconds) {
            $timeLeft = $timeoutSeconds - [math]::Round($timer.Elapsed.TotalSeconds)
            $timerString = "| Time left: {0:mm\:ss}" -f ([datetime]"00:00:00").AddSeconds($timeLeft)
            [Console]::SetCursorPosition(([Console]::WindowWidth - $timerString.Length - 3), 1)
            [Console]::Write($timerString)
    
            [Console]::SetCursorPosition($oldLeft, $oldTop)
            Start-Sleep -Milliseconds 50
            
            $sortedKeys = $this.Options.Keys | Sort-Object
            $sortedOptions = @{}
            foreach ($key in $sortedKeys) {
                $sortedOptions[$key] = $this.Options[$key]
            }
    
            function UpdateConsoleOutput($selectedOption) {
                Write-Host -ForegroundColor Red " [$selectedOption] " -NoNewline
                Write-Host -ForegroundColor Yellow " $($sortedOptions[$selectedOption]) " -NoNewline
                Write-Host "(ENTER to confirm...)" -ForegroundColor Green -NoNewline
                Write-Host (" " * ([Console]::WindowWidth - [Console]::CursorLeft - 1))
            }
    
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey("NoEcho,IncludeKeyDown")
                if ($key.Key -eq "Enter" -and $selectedOption -ne $null) {
                    Clear-Host
                    return $selectedOption
                }
                elseif ($key.KeyChar -in $sortedKeys) {
                    $selectedOption = $key.KeyChar.ToString()
                    UpdateConsoleOutput $selectedOption
                }
                elseif (($key.Key -eq "DownArrow") -or ($key.Key -eq "RightArrow")) {
                    $selectedIndex = [array]::IndexOf($sortedKeys, $selectedOption)
                    $selectedIndex = ($selectedIndex + 1) % $sortedKeys.Length
                    $selectedOption = $sortedKeys[$selectedIndex]
                    UpdateConsoleOutput $selectedOption
                }
                elseif (($key.Key -eq "UpArrow") -or ($key.Key -eq "LeftArrow")) {
                    $selectedIndex = [array]::IndexOf($sortedKeys, $selectedOption)
                    $selectedIndex = ($selectedIndex - 1 + $sortedKeys.Length) % $sortedKeys.Length
                    $selectedOption = $sortedKeys[$selectedIndex]
                    UpdateConsoleOutput $selectedOption
                }
            }
        }
    
        [Console]::SetCursorPosition(0, [Console]::CursorTop)
        [Console]::Write((" " * [Console]::WindowWidth).PadRight([Console]::WindowWidth))
        [Console]::SetCursorPosition(0, [Console]::CursorTop + 1)
    
        Write-Host "No option selected. Default option ($($this.Options[$this.DefaultOption])) selected."
        return $this.DefaultOption
    }
    
    
}