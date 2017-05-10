<#
    .SYNOPSIS
    Zajawka
    Powershell HMAC SHA 256.
    .DESCRIPTION
     Uruchomienie bez parametrów powoduje automatyczne dopytanie siê o teksty (w formie jawnej) i has³o (w formie tajnej)
    Hash has³a jest dostêpny jedynie przez 10 sekund po czym zostaje zamazany z pamieci.
    .EXAMPLE
    HMAC_SHA.ps1
    .EXAMPLE
    HMAC_SHA.ps1 facebook P@ssw0rd!
    .EXAMPLE
    HMAC_SHA.ps1 facebook P@ssw0rd! -Hex
    .INPUTS
    facebook P@ssw0rd!
    .OUTPUTS
    fMGujwwGOhh2iB/o+Gg7+JN0eNYlH3eJSRyb3se7w18=
    .NOTES
    Lotus Notes ^.^' ?
    .LINK
    www.google.pl
#>


[CmdletBinding(DefaultParameterSetName = 'Secret')]
param (
    #Tekst z którego ma zostaæ wyliczona funkcja skrótu. Domyœlnie dla jaj 'Message'.
    [Parameter(Position=0, Mandatory=$true)]
    [String]$Tekst = 'Message',

    #Has³o do zaciemnienia funkcji skrótu w formie nie jawnej.
    [Parameter(Position=1, Mandatory=$true, ParameterSetName='Secret')]
    [Security.SecureString]$HMACKlucz,
    #Has³o do zaciemnienia funkcji skrótu w formie jawnej.
    [Parameter(Position=1, Mandatory=$true, ParameterSetName='Plain')]
    [String]$PlainText_HMACKlucz,
    
    #Prze³acznik powoduj¹cy wyœwietlenie wartoœci funkcji skrótu w formie hexadecymalnej, a nie w BASE64.
    [Parameter(Position=2)]    
    [Switch]$Hex
)

begin{
    [System.Runtime.InteropServices.Marshal]$s_BSTR_HMACKlucz
    [System.Runtime.InteropServices.Marshal]$s_PlainText_HMACKlucz
    [System.Security.Cryptography.HMACSHA256]$s_hmacsha
    [String]$s_HASH
}
process{
    try{
        switch($PSCmdlet.ParameterSetName){
            'Secret'{
                $s_BSTR_HMACKlucz = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($HMACKlucz)
                $s_PlainText_HMACKlucz = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($s_BSTR_HMACKlucz)
            }
            'Plain'{
                $s_PlainText_HMACKlucz = $PlainText_HMACKlucz
            }
        }

        $s_hmacsha = New-Object System.Security.Cryptography.HMACSHA256
        $s_hmacsha.key = [Text.Encoding]::ASCII.GetBytes($s_PlainText_HMACKlucz)

        $s_HASH = $s_hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($Tekst))


        if($Hex){
            $s_HASH = [String]::Join("", ($s_HASH | ForEach-Object { [Convert]::ToString($_, 16)}))
        }else{
            $s_HASH = [Convert]::ToBase64String($s_HASH)
        }

            $s_HASH | clip.exe
            Clear-Variable s_* 
            Start-Sleep -Seconds 10
    }
    finally{
        "Terefere ^.^'" | clip.exe
        Clear-Variable s_* 
    }
}
end{
    Clear-Variable s_* 
}
