function metPathExistOrCreate {
    param (
        [string] $path
    )
    if (-not (Test-Path -Path $path -PathType Container)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        
    }
}
function funcFileExist {
    param (
        [string] $path
    )
    return (Test-Path -Path $path -PathType Leaf)
}