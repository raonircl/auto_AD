$users = Import-Csv -Path ".\users.csv"

foreach ($users in $usersCSV) {
    $name = ""
    $cpf = ""
    $email = ""
    $password = ""

    $splitNamesLower = ($name.ToLower()) -split " "
    $passwordLower = $password.ToLower()

    if ([string]::IsNullOrEmpty($name) -or
    [string]::IsNullOrEmpty($cpf) -or
    [string]::IsNullOrEmpty($password) -or
    [string]::IsNullOrEmpty($email)) {
        Write-Host "Todos os campos são obrigatórios" -ForegroundColor Red
        return
    }

    foreach ($splitName in $splitNamesLower) {
        if ($passwordLower -match $parte) {
            Write-Red "A senha não pode conter partes do nome"
            return
        }
    }

    if (Get-ADUser -Filter "SamAccountName -eq '$name'") {
        Write-Red "O nome de usuário '$name' Já existe na base de dados."
        return
    }

    if (Get-ADUser -Filter "EmailAddress -eq '$email'") {
        Write-Red "O endereço de email '$email' já existe na base de dados."
        return
    }

    if ($email -notmatch "^([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$") {
        Write-Red "O formato do endereço de email '$email' não é válido."
        return
    }

    if ($password.Length -lt 8) {
        Write-Red "A senha deve conter pelo menos 8 caracteres."
        return
    }

    if ($password -notmatch "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^a-zA-Z0-9]).{8,}$") {
        Write-Red "A senha deve conter pelo menos uma letra maiúscula, uma letra minúscula, um número e um caractere especial."
        return
    }

    New-ADUser `
    -Name $name`
    -SamAccountName $nameUser`
    -UserPrincipalName "$nameUser@seu.dominio.com" `
    -EmailAddress $email `
    -AccountPassword (ConvertFrom-SecureString $password -AsPlainText -Force) `
    -Enable $true`

    Write-Green "Usuário '$nameUser' criado com sucesso!"
}