$counter = 1; $outputPrefix = "file"; $extractDir = "extracted_temp"
Get-ChildItem -Filter *.goodnotes | ForEach-Object {
    Write-Host "Processing $($_.Name)..."
    if (Test-Path $extractDir) { Remove-Item -Recurse -Force $extractDir }
    Copy-Item $_.FullName "$($_.FullName).zip" -Force
    Expand-Archive "$($_.FullName).zip" $extractDir; Remove-Item "$($_.FullName).zip"
    $attachments = Join-Path $extractDir "attachments"
    if (Test-Path $attachments) {
        $largest = Get-ChildItem $attachments -File | Sort-Object Length -Descending | Select-Object -First 1
        if ($largest) { Copy-Item $largest.FullName "$outputPrefix`_$counter.mp3"; $counter++ }
    }
    Remove-Item -Recurse -Force $extractDir
}
Write-Host "Done!"