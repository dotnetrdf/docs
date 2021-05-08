# This script makes a copy of the documentation in the latest directory as a new persistent version
# The version number provided in the script parameter should be the version of dotNetRDF that the docs relate to
# Ideally we should have no more than one docs release for each minor version (e.g docs version 2.7 would be the
# documentation for all 2.7.x releases of the library). As the docs are copied they can be tweaked post-release
# if needed.
#
# The copy process creates a new sub-directory under src for the version (with the version number as the directory name)
# and a new docfx build file specifically for that version (named {$version}_docfx.json)
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
Copy-Item -Path '.\src\latest\*' -Recurse -Destination '.\src\stable' -Container

# Build stable and the persistent version
docfx build .\src\stable_docfx.json
docfx build $build_file