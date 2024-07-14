# task.ps1

# Define the path to the data folder relative to the script location
$dataFolderPath = Join-Path -Path (Get-Item $PSScriptRoot).Parent.FullName -ChildPath "data"

# Log the path for debugging
Write-Host "Data folder path: $dataFolderPath"

# Check if the data directory exists
if (-Not (Test-Path -Path $dataFolderPath)) {
    Write-Host "Data directory does not exist: $dataFolderPath"
    Write-Host "Creating data directory..."
    New-Item -ItemType Directory -Path $dataFolderPath
}

# Initialize an empty array to hold the regions where the VM size is available
$regions = @()

# Get a list of JSON files in the data folder
$jsonFiles = Get-ChildItem -Path $dataFolderPath -Filter *.json

# Log the number of files found
Write-Host "Number of JSON files found: $($jsonFiles.Count)"

# Loop through each JSON file
foreach ($file in $jsonFiles) {
    # Get the region name by removing the '.json' extension from the file name
    $regionName = $file.Name.Replace('.json', '')

    # Read the JSON content and convert it to a list of objects
    $vmSizes = Get-Content -Path $file.FullName | ConvertFrom-Json

    # Check if the desired VM size is present in the list of objects
    $vmSizeFound = $vmSizes | Where-Object { $_.name -eq 'Standard_B2pts_v2' }

    # If the VM size is found, add the region name to the result list
    if ($vmSizeFound) {
        $regions += $regionName
    }
}

# Define the path to save the result in the current working directory
$resultFilePath = Join-Path -Path (Get-Location) -ChildPath "result.json"

# Log the result file path
Write-Host "Result file path: $resultFilePath"

# Export the result list of regions to a JSON file
$regions | ConvertTo-Json | Out-File -FilePath $resultFilePath

# Log the result
Write-Host "Result list of regions: $($regions | ConvertTo-Json)"

# Check if the result file is created
if (Test-Path -Path $resultFilePath) {
    Write-Host "Result file was successfully created at: $resultFilePath"
    # Additional verification step
    Get-Item -Path $resultFilePath | Format-List -Property FullName
} else {
    Write-Host "Failed to create result file at: $resultFilePath"
}
