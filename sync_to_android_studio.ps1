# Script de synchronisation automatique vers le projet Android Studio
# E-Clavier Multilingue (ANB)

$SourceDir = "$PSScriptRoot\android_version\app"
$TargetDir = "C:\Users\Rodolpho Gouba\AndroidStudioProjects\E_CLAVIER\app"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  SYNCHRONISATION E-CLAVIER VERS ANDROID STUDIO" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

if (-not (Test-Path $TargetDir)) {
    Write-Warning "Le dossier cible Android Studio n'a pas été trouvé à : $TargetDir"
    Write-Host "Vérifie le chemin de ton projet Android Studio." -ForegroundColor Yellow
    exit 1
}

Write-Host "[1/4] Nettoyage des anciens packages obsolètes..." -ForegroundColor Green
$OldExampleDir = "$TargetDir\src\main\java\com\example"
if (Test-Path $OldExampleDir) {
    Remove-Item -Path $OldExampleDir -Recurse -Force
}

Write-Host "[2/4] Copie des sources Kotlin (com.eclavier.app)..." -ForegroundColor Green
if (-not (Test-Path "$TargetDir\src\main\java\com\eclavier\app")) {
    New-Item -ItemType Directory -Path "$TargetDir\src\main\java\com\eclavier\app" -Force | Out-Null
}
Copy-Item -Path "$SourceDir\src\main\java\com\eclavier\app\*" -Destination "$TargetDir\src\main\java\com\eclavier\app" -Recurse -Force

Write-Host "[3/4] Copie des layouts, drawables, styles et strings..." -ForegroundColor Green
Copy-Item -Path "$SourceDir\src\main\res\*" -Destination "$TargetDir\src\main\res" -Recurse -Force

Write-Host "[4/4] Copie du Manifest..." -ForegroundColor Green
Copy-Item -Path "$SourceDir\src\main\AndroidManifest.xml" -Destination "$TargetDir\src\main\AndroidManifest.xml" -Force

Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  SYNCHRONISATION TERMINÉE AVEC SUCCÈS !" -ForegroundColor Green
Write-Host "  Tu peux maintenant lancer la compilation dans Android Studio" -ForegroundColor Green
Write-Host "  ou exécuter : .\gradlew.bat assembleDebug" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
