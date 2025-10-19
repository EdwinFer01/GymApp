# Verifica que se haya proporcionado un nombre para la feature
param (
    [string]$FeatureName
)

if ([string]::IsNullOrEmpty($FeatureName)) {
    Write-Host " Error: Debes proporcionar un nombre para la feature." -ForegroundColor Red
    Write-Host "Uso: .\create_feature.ps1 -FeatureName nombre_de_la_feature"
    exit 1
}

$basePath = "lib/features/$FeatureName"

# Define la lista de directorios a crear
$directories = @(
    "$basePath/data/datasources",
    "$basePath/data/models",
    "$basePath/data/repositories",
    "$basePath/domain/entities",
    "$basePath/domain/repositories",
    "$basePath/domain/usecases",
    "$basePath/presentation/manager",
    "$basePath/presentation/pages",
    "$basePath/presentation/widgets"
)

# Crea cada directorio
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

Write-Host "¡Estructura para la feature '$FeatureName' creada exitosamente en '$basePath'!" -ForegroundColor Green

#.\create_feature.ps1 -FeatureName user_profile