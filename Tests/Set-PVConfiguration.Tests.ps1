#Get Current Directory
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path

#Get Function Name
$FunctionName = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -Replace ".Tests.ps1"

#Assume ModuleName from Repository Root folder
$ModuleName = Split-Path (Split-Path $Here -Parent) -Leaf

if( -not (Get-Module -Name $ModuleName -All)) {

	#Resolve Path to Module Directory
	$ModulePath = Resolve-Path "$Here\..\$ModuleName"
	#Define Path to Module Manifest
	$ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"
	Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

}

BeforeAll {

	#$Script:RequestBody = $null

}

AfterAll {

	#$Script:RequestBody = $null

}

Describe $FunctionName {

	InModuleScope $ModuleName {

		Context "General" {

			BeforeEach {

				Mock Test-Path -MockWith {
					$true
				}

				$InputObj = [pscustomobject]@{
					ClientPath = "C:\Windows\System32\cmd.exe"
				}

			}

			it "sets value of script scope variable" {

				$InputObj | Set-PVConfiguration
				$Script:PV | Should Not BeNullOrEmpty
			}

			it "sets client path property value" {
				$InputObj | Set-PVConfiguration
				$($Script:PV.ClientPath) | Should Be "C:\Windows\System32\cmd.exe"
			}

			it "sets independent property value" {
				Set-PVConfiguration -sessionID 666
				$($Script:PV.sessionID) | Should Be "666"
				$($Script:PV.ClientPath) | Should Be "C:\Windows\System32\cmd.exe"
			}

			it "throws as expected" { 

				Mock Get-Item -MockWith {
					[PSCustomObject]@{
						VersionInfo = [PSCustomObject]@{
							ProductVersion = 5.5
						}
					}
				}
				
				{ $InputObj | Set-PVConfiguration } | should throw


			}

		}

	}

}