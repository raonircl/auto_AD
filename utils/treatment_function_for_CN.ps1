function Get-GroupNames {
    param (
        [string]$memberOf
    )

    if (-not $memberOf) {
        Write-Red "O parametro esta vazio ou nao foi fornecido."
        return
    }
    $texto = $memberOf

    $nomesGrupos = [regex]::Matches($texto, '(?<=CN=)[^,]+') | ForEach-Object { $_.Value }
    
    return $nomesGrupos
}