Function Test-ExePreReqs {
	<#
    .SYNOPSIS
        Test Pre-Requisites needed for PACLI exeutbale to run.
        
    .DESCRIPTION
        Module functions which call the PACLI utility require that a specific variable 
        is set to the full path of the PACLI utiltiy on the Local System and is in a scope 
        accesible to the function.
        Function Test-ExePreReqs ensures that both the variable is set, and that the path 
        to the utility stored int he variable resolves OK.
        
        Returns True or False (if one or both of the conditions is not met).
        
    .PARAMETER pacliVar
        The name of the variable containing the path to the PACLI Utility.

    .EXAMPLE
        Test-ExePreReqs
        
    .NOTES
    	AUTHOR: Pete Maan
    	LASTEDIT: January 2015
    #>
        
	[CmdLetBinding()]
	param(
		[Parameter(Mandatory = $False)]
		[string]$pacliVar = "pacli"
	)

	if ((Get-Variable -Name pacliVar) -and 
		(Test-Path (Get-Variable -Name pacliVar -ValueOnly ) -PathType leaf -Include "*.exe" )) {
			Write-Output $true
	}#if
	else {
		Write-Warning -Message "Failed Pre-Requisite Checks, please check you have the PACLI.exe and DLLS installed"
		Write-Output $False
	}#else
    
}