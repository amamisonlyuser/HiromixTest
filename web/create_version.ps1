$pubspec = Get-Content pubspec.yaml
$version = ($pubspec | Select-String -Pattern "version:").ToString().Split(" ")[1]
Set-Content -Path web/version.txt -Value $version
