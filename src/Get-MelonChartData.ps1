param (
    [Parameter(Mandatory=$true)]
    [string]$Url,

    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

# Download the data from the URL and save it to the file path
$(Invoke-WebRequest -Uri $Url).Content | Out-File $FilePath -Force

# Read the data from the saved file
$data = Get-Content -Path $FilePath

# Group the records by artist and order them by the song in ascending order
$groupedData = $($data | ConvertFrom-Json).items | Group-Object -Property artist | ForEach-Object {
    $_.Group | Sort-Object -Property title
}

# Output the result in a table format
$groupedData | Format-Table -AutoSize