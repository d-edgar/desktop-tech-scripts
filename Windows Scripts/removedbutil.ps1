$path = "C:\Users"
$filepath = "AppData\Local\Temp\dbutil_2_3.sys"
$Tempcheck = "C:\Windows\Temp\dbutil_2_3.sys"

Get-ChildItem $path -Directory -Exclude Default*,Public | foreach {
$joined_path = Join-Path -Path $_.FullName -ChildPath $filepath
If (test-path $joined_path) {
Write-Host $joined_path
Remove-Item "$joined_path" -Force
}
}

if (Test-Path $Tempcheck -PathType leaf)
{
	Remove-Item "$Tempcheck" -Force
}