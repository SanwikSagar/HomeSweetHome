Add-Type -AssemblyName System.IO.Compression

$buildDir = Split-Path -Parent $PSScriptRoot | Join-Path -ChildPath "Build"

Get-ChildItem $buildDir -Filter "*.br" | ForEach-Object {
    $srcFile = $_.FullName
    $destFile = $srcFile -replace '\.br$', ''
    
    Write-Host "Decompressing $($_.Name) → $([System.IO.Path]::GetFileName($destFile))"
    
    try {
        $inputBytes = [System.IO.File]::ReadAllBytes($srcFile)
        $memStream = New-Object System.IO.MemoryStream
        $memStream.Write($inputBytes, 0, $inputBytes.Length)
        $memStream.Position = 0
        
        $decompStream = New-Object System.IO.Compression.BrotliStream($memStream, [System.IO.Compression.CompressionMode]::Decompress)
        $outputStream = New-Object System.IO.MemoryStream
        $decompStream.CopyTo($outputStream)
        
        $outputBytes = $outputStream.ToArray()
        [System.IO.File]::WriteAllBytes($destFile, $outputBytes)
        
        Write-Host "✓ Decompressed successfully"
    }
    catch {
        Write-Host "✗ Error: $_"
    }
}

Write-Host "Done!"
