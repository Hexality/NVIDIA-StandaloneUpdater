if(-not (Test-Path $env:TEMP\wget.exe)){Invoke-WebRequest -Uri 'https://eternallybored.org/misc/wget/1.21.3/32/wget.exe' -OutFile "$env:TEMP\wget.exe"}
$wget = "$env:TEMP\wget.exe"
$nvidia = "$env:TEMP\nvidia.exe"

<#	Product Series List:
		GeForce RTX 40 Series 				= 127
		GeForce RTX 30 Series (Notebooks) 	= 123
		GeForce RTX 30 Series 				= 120
		GeForce RTX 20 Series (Notebooks) 	= 111
		GeForce RTX 20 Series 				= 107
		GeForce GTX 16 Series (Notebooks) 	= 115
		GeForce GTX 16 Series 				= 112
		GeForce GTX 10 Series (Notebooks) 	= 102
		GeForce GTX 10 Series 				= 101
		GeForce GTX 900 Series (Notebooks) 	= 99
		GeForce GTX 900 Series 				= 98
#>
<#	Card Family List:
		GeForce RTX 40 Series:
			RTX 4090		=	995
			RTX 4080		=	999
			RTX 4070TI		=	1001
		GeForce RTX 30 Series (Notebooks):
			RTX 3080TI		=	976
			RTX 3080		=	938
			RTX 3070TI		=	979
			RTX 3070		=	939
			RTX 3060		=	940
			RTX 3050TI		=	962
			RTX 3050		=	963
		GeForce RTX 30 Series:
			RTX 3090TI		=	985
			RTX 3090		=	930
			RTX 3080TI		=	964
			RTX 3080		=	929
			RTX 3070TI		=	965
			RTX 3070		=	933
			RTX 3060TI		=	934
			RTX 3060		=	942
			RTX 3050		=	975
		GeForce RTX 20 Series (Notebooks):
			RTX 2080		=	919
			RTX 2080		=	890
			RTX 2070		=	920
			RTX 2070		=	889
			RTX 2060		=	888
			RTX 2050		=	978
		GeForce RTX 20 Series:
			RTX 2080TI		=	877
			RTX 2080SUPER 	=	904
			RTX 2080		=	879
			RTX 2070SUPER 	=	903
			RTX 2070		=	880
			RTX 2060SUPER 	=	902
			RTX 2060		=	887
		GeForce GTX 16 Series (Notebooks):
			GTX 1660TI		=	899
			GTX 1650TI		=	921
			GTX 1650		=	898
		GeForce GTX 16 Series:
			GTX 1660SUPER	=	910
			GTX 1660TI		=	892
			GTX 1660		=	895
			GTX 1650SUPER	=	911
			GTX 1650		=	897
			GTX 1630		=	993
		GeForce GTX 10 Series (Notebooks):
			GTX 1080		=	819
			GTX 1070		=	820
			GTX 1060		=	821
			GTX 1050TI		=	836
			GTX 1050		=	837
		GeForce GTX 10 Series:
			GTX 1080TI		=	845
			GTX 1080		=	815
			GTX 1070TI		=	859
			GTX 1070		=	816
			GTX 1060		=	817
			GTX 1050TI		=	825
			GTX 1050		=	826
			GTX 1030		=	852
			GTX 1010		=	936
		GeForce GTX 900 Series (Notebooks):
			GTX 980		=	785
			GTX 980M	=	757
			GTX 970M	=	758
			GTX 965M	=	765
			GTX 960M	=	769
			GTX 950M	=	770
			GF 945M		=	795
			GF 940MX	=	796
			GF 930MX	=	807
			GF 920MX	=	808
			GF 940M		=	771
			GF 930M		=	772
			GF 920M		=	773
			GF 910M		=	779
		GeForce GTX 900 Series:
			GTX 980TI	=	778
			GTX 980		=	755
			GTX 970		=	756
			GTX 960		=	764
			GTX 950		=	782
#>
<#	Operating System List:
		Windows 11 	=	135
		Windows 10 	=	57
		Windows 8.1	=	41
		Linux x64	=   12 # Don't report errors for this one, you're on you own
#>
<#  Language List:
		English (US)	=	1033 (API is English-only)
#>

function Get-NvidiaDriver {
	param($json)
	.$wget "$($json.IDS.downloadInfo.downloadURL)" -c -q -t 5 -w 1 --show-progress -O $nvidia
	}
	&$nvidia
	Wait-Process $nvidia
	Remove-Item $nvidia

function Check-DriverVersion {
	<# Product Series:   #>    $psid   = 101 	<#   	     GeForce 10 Series			#>
	<# Product Family:   #>    $pfid   = 825 	<# 	  	      GeForce 1050 Ti			#>
	<# Operating System: #>    $osid   = 135 	<# 			     Windows 11 			#>
	<# Driver Language:  #>    $lid    = 1033 	<#		   English (United States)		#>
	<# Driver Branch:    #>    $whql   =   1		<#			    Signed (SCH)			#>
	<# Driver Type       #>    $dtcid  =   1		<#				 GameReady				#>
	<# Is beta driver?   #>	   $beta   =   0		<#			   Stable Driver			#>

	$json = Invoke-WebRequest	"https://gfwsl.geforce.com/services_toolkit/services/com/nvidia/services/AjaxDriverService.php?func=DriverManualLookup&psid=$($psid)&pfid=$($pfid)&osID=$($osID)&languageCode=$($lid)&beta=$($beta)&isWHQL=$($whql)&dltype=-1&dch=$($dtcid)&upCRD=0&qnf=0&sort1=0&numberOfResults=1" -ContentType 'applciation/json' | ConvertFrom-Json
	$ndv = ($json.IDS.downloadInfo.Version).Replace('.','')
	$cdv = ((Get-WmiObject Win32_PnPSignedDriver | Select Description,DeviceName,DriverVersion) -match 'nvidia geforce').DriverVersion
	$cdv = $cdv.Substring(6,6).Replace('.','')
	if($cdv -lt $ndv){
		Get-NvidiaDriver $json
	}
}

Check-DriverVersion

