param ($version)

$build_file='.\src\' + $version + '_docfx.json'
$version_dir='.\src\' + $version

# Create a new persistent folder for the stable version or else clean the directory if it already exists
(Get-Content -Path '.\src\docfx_template.json') -replace '_version_', $version | Set-Content -Path $build_file
if (!(Test-Path $version_dir)) {
  New-Item -Force -Path '.\src' -Name $version -ItemType "directory"
} else {
  Get-ChildItem $version_dir | Remove-Item -Recurse -Confirm:$false
}
# Copy latest to the version folder
Copy-Item -Path '.\src\latest\*' -Destination $version_dir -Recurse

# Replace the content of the stable folder with the content of the latest folder
Get-ChildItem '.\src\stable\*' | Remove-Item -Recurse -Confirm:$false
Copy-Item -Path '.\src\latest\*' -Destination '.\src\stable' -Recurse

# Build stable and the persistent version
docfx build .\src\stable_docfx.json
docfx build $build_file