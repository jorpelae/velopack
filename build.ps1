# Stop the script if an error occurs
$ErrorActionPreference = "Stop"
$In = ".\build\Release\"
$Out = ".\build\publish\"
$Folders = @("./build", "./packages", "./test/bin", "./test/obj")

# Ensure a clean state by removing build/package folders
foreach ($Folder in $Folders) {
    if (Test-Path $Folder) {
        Remove-Item -path $Folder -Recurse -Force
    }
}

# Build Squirrel C++ and library files
msbuild /restore /p:Configuration=Release

# Build single-exe packaged projects
dotnet publish -c Release src\Update\Update.csproj -o $Out
dotnet publish -c Release src\SyncReleases\SyncReleases.csproj -o $Out

# Copy over all files we need
# Copy-Item "$In\net45\Update.exe" -Destination "$Out\Squirrel.exe"
# Copy-Item "$In\net45\update.com" -Destination "$Out\Squirrel.com"
# Copy-Item "$In\net45\Update.pdb" -Destination "$Out\Squirrel.pdb"
Copy-Item "$In\Win32\Setup.exe" -Destination $Out
Copy-Item "$In\Win32\Setup.pdb" -Destination $Out
# Copy-Item "$In\net45\Update-Mono.exe" -Destination "$Out\Squirrel-Mono.exe"
# Copy-Item "$In\net45\Update-Mono.pdb" -Destination "$Out\Squirrel-Mono.pdb"
Copy-Item "$In\Win32\StubExecutable.exe" -Destination $Out
# Copy-Item "$In\net45\SyncReleases.exe" -Destination $Out
# Copy-Item "$In\net45\SyncReleases.pdb" -Destination $Out
Copy-Item "$In\Win32\WriteZipToSetup.exe" -Destination $Out
Copy-Item "$In\Win32\WriteZipToSetup.pdb" -Destination $Out

Write-Output "Successfully copied files to './build/publish'"
