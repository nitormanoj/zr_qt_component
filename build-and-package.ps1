
$ErrorActionPreference = "Stop"

# ==========================================
# Qt Quick Application - Build and Package
# ==========================================

$Project = "D:\POCS\zr_qt_component"
$QtRoot  = "C:\Qt\6.12.0"
$Build   = "$Project\build"
$Dist    = "$Project\portable-app"
$ExeName = "appQTDemoApp.exe"
$Exe     = "$Build\$ExeName"
$DistExe = "$Dist\$ExeName"
$Zip     = "$Project\appQTDemoApp-Windows-Release.zip"

Write-Host "`n=== Qt Application Packaging ===" -ForegroundColor Cyan

# 1. Validate project and existing Release configuration
if (!(Test-Path "$Project\CMakeLists.txt")) {
    throw "CMakeLists.txt not found: $Project"
}

$Cache = "$Build\CMakeCache.txt"
if (!(Test-Path $Cache)) {
    throw "Build directory not configured. Configure using VS Code CMake Tools first."
}

$BuildType = Select-String -Path $Cache `
    -Pattern "^CMAKE_BUILD_TYPE:STRING=(.*)$"

if (!$BuildType -or $BuildType.Matches[0].Groups[1].Value -ne "Release") {
    throw "Build directory is not configured for Release. Select Release in VS Code, then configure."
}

# 2. Find the Qt MinGW kit and deployment tool
$Windeploy = "$QtRoot\mingw_64\bin\windeployqt.exe"
$QtBin = "$QtRoot\mingw_64\bin"

if (!(Test-Path $Windeploy)) {
    $Found = Get-ChildItem $QtRoot -Filter "windeployqt.exe" `
        -Recurse -ErrorAction SilentlyContinue |
        Select-Object -First 1

    if (!$Found) {
        throw "windeployqt.exe not found under $QtRoot. Check your Qt installation."
    }

    $Windeploy = $Found.FullName
    $QtBin = Split-Path $Windeploy
}

Write-Host "Deployment tool: $Windeploy"

# 3. Discover the compiler configured for this build
$CompilerLine = Select-String -Path $Cache `
    -Pattern "^CMAKE_CXX_COMPILER:FILEPATH=(.*)$"

if ($CompilerLine) {
    $Compiler = $CompilerLine.Matches[0].Groups[1].Value -replace "/", "\"
    $MingwBin = Split-Path $Compiler

    if (Test-Path $Compiler) {
        $env:PATH = "$MingwBin;$QtBin;$env:PATH"
        Write-Host "Compiler: $Compiler"
    }
}

# 4. Build using CMake if available; otherwise use Ninja
$CMakeCmd = Get-Command cmake.exe -ErrorAction SilentlyContinue

if (!$CMakeCmd) {
    $CMakeExe = Get-ChildItem "C:\Qt\Tools" -Filter "cmake.exe" `
        -Recurse -ErrorAction SilentlyContinue |
        Select-Object -First 1

    if ($CMakeExe) {
        $CMakePath = $CMakeExe.FullName
    }
}

if ($CMakeCmd -or $CMakePath) {
    $CMakeProgram = if ($CMakeCmd) { $CMakeCmd.Source } else { $CMakePath }

    Write-Host "`n[1/5] Building Release with CMake..." -ForegroundColor Yellow
    & $CMakeProgram --build $Build --parallel

    if ($LASTEXITCODE -ne 0) {
        throw "CMake build failed."
    }
}
else {
    $NinjaExe = Get-Command ninja.exe -ErrorAction SilentlyContinue

    if (!$NinjaExe) {
        $NinjaExe = Get-ChildItem "C:\Qt\Tools" -Filter "ninja.exe" `
            -Recurse -ErrorAction SilentlyContinue |
            Select-Object -First 1
    }

    if (!$NinjaExe) {
        throw "CMake/Ninja executable not found. Build Release using VS Code first, or install CMake and Ninja."
    }

    Write-Host "`n[1/5] Building Release with Ninja..." -ForegroundColor Yellow
    & $NinjaExe.Source -C $Build

    if ($LASTEXITCODE -ne 0) {
        throw "Ninja build failed."
    }
}

# 5. Verify the application executable
if (!(Test-Path $Exe)) {
    throw "Application EXE not found: $Exe. Check the executable target and build output."
}

# 6. Create a clean deployment directory
Write-Host "`n[2/5] Preparing deployment folder..." -ForegroundColor Yellow

if (Test-Path $Dist) {
    Remove-Item $Dist -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $Dist | Out-Null
Copy-Item $Exe $DistExe -Force

# 7. Deploy Qt, QML, plugins, and compiler runtime dependencies
Write-Host "`n[3/5] Deploying Qt dependencies..." -ForegroundColor Yellow

& $Windeploy `
    --release `
    --compiler-runtime `
    --qmldir $Project `
    --dir $Dist `
    $DistExe

if ($LASTEXITCODE -ne 0) {
    throw "windeployqt failed. Review the output above."
}

# 8. Create ZIP package
Write-Host "`n[4/5] Creating ZIP..." -ForegroundColor Yellow

if (Test-Path $Zip) {
    Remove-Item $Zip -Force
}

Compress-Archive -Path "$Dist\*" -DestinationPath $Zip -Force

# 9. Summary
Write-Host "`n[5/5] Packaging complete!" -ForegroundColor Green
Write-Host "EXE folder : $Dist"
Write-Host "ZIP package: $Zip"
Write-Host "`nTest the EXE on a Windows PC without Qt installed."
