param ($version)

# Create a new persistent folder for the stable version
Get-Content('.\src\docfx_template.json').Replace('\$version\$', $version) | Set-Content('.\src\' + $version + '_docfx.json')

# Replace the content of the stable folder with the content of the latest folder
Get-ChildItem '.\src\stable\*' -Recurse | Remove-Item
Copy-Item -Path '.\src\latest\*' -Destination '.\src\stable' -Recurse

# Build stable and the persistent version
docfx build .\src\stable_docfx.json
docfx build '.\src\' + $version '_docfx.json'