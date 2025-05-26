# Leia Apache'ga seotud teenused (case-insensitive)
$apacheServices = Get-Service | Where-Object { $_.Name -like "*apache*" -or $_.DisplayName -like "*Apache*" }


if ($apacheServices) {
    foreach ($service in $apacheServices) {
        Write-Host "Leitud teenus: $($service.Name) ($($service.DisplayName))"


        if ($service.Status -eq 'Running') {
            Write-Host "Staatus: TÖÖTAB"
        } else {
            Write-Host "Staatus: EI TÖÖTA (staatus: $($service.Status))"
        }


        Write-Host "---------------------------------------"
    }
} else {
    Write-Host "Apache'ga seotud teenust ei leitud!"
}
