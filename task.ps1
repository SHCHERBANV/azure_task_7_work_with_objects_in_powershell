$dataPath = ".\data"
$vmSizeToFind = "Standard_B2pts_v2"
$resultRegions = @()

$jsonFiles = Get-ChildItem -Path $dataPath -Filter *.json

Write-Host "Number of JSON files found: $($jsonFiles.Count)"

foreach ($file in $jsonFiles) {
    Write-Host "Processing file: $($file.FullName)"
    
    $content = Get-Content -Path $file.FullName -Raw | ConvertFrom-Json

    if ($content | Where-Object { $_.name -eq $vmSizeToFind }) {
        $region = $file.BaseName
        Write-Host "Found VM size '$vmSizeToFind' in region: $region"
        $resultRegions += $region
    } else {
        Write-Host "VM size '$vmSizeToFind' not found in region: $($file.BaseName)"
    }
}

$resultFilePath = ".\result.json"
$resultRegions | ConvertTo-Json -Depth 1 | Out-File -FilePath $resultFilePath -Encoding utf8

if (Test-Path -Path $resultFilePath) {
    Write-Host "Results successfully saved to $resultFilePath"
} else {
    Write-Host "Failed to save results to $resultFilePath"
}
