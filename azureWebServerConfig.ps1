Add-WindowsFeature web-server
sleep 100
Import-Module "WebAdministration"
#Set up directories for web content
New-Item c:\web\company.com\aspnet_client\system_web\1_1_4322 -type directory
New-Item c:\web\company.com\aspnet_client\system_web\2_0_50727 -type directory
New-Item c:\web\company.com\aspnet_client\system_web\4_0_30319 -type directory
New-Item c:\web\company.com\website1 -type directory
New-Item c:\web\company.com\website2 -type directory
New-Item c:\web\company.com\website2\WebService -type directory
New-Item c:\web\company.com\website3 -type directory
New-Item c:\web\company.com\webservice -type directory
New-Item c:\web\company.com\webservice2 -type directory
New-Item c:\web\company.com\webservice3 -type directory
#Add a page so we know IIS is working
Set-Content c:\web\company.com\website1\default.htm "This is the website1 - U got served"
Set-Content c:\web\company.com\website2\default.htm "Welcome to my i"
Set-Content c:\web\company.com\website3\default.htm "Welcome to my j"
#Remove Default Web Site
Stop-Website "Default Web Site"
Remove-Website "Default Web Site"
#Create MainSite Website, bindings and assign to .NET 4.5 application pool
New-Item 'IIS:\Sites\MainSite' -PhysicalPath c:\web\company.com -bindings @{protocol="http";bindingInformation=":80:"}
Set-ItemProperty 'IIS:\Sites\MainSite' -name applicationPool -value '.NET v4.5 Classic'
# Configure APP Pool recycling 
#first get a random number between 1 and 59
$rctime = get-random -maximum 59
#tell the app pool to recycle at 04:$lastoctet
Set-ItemProperty -Path "IIS:\AppPools\.NET v4.5 Classic" -Name Recycling.periodicRestart.schedule -Value @{value="04:$rctime"}
#dump the 1740 minute recycle
set-ItemProperty "IIS:\AppPools\.NET v4.5 Classic" -Name Recycling.periodicRestart -Value @{time="00:00:00"}
#set 32-bit
set-ItemProperty "IIS:\AppPools\.NET v4.5 Classic" -name "enable32BitAppOnWin64" -Value "true"
#Add logging field for XFF headers
Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/sites/site[@name='MainSite']/logFile/customFields" -name "." -value @{logFieldName='Original_IP';sourceName='X-FORWARDED-FOR';sourceType='RequestHeader'}
#Create WebApplications and assign to .NET 4.5 application pool
New-Item 'IIS:\Sites\MainSite\website1' -Type Application -PhysicalPath c:\web\company.com\website1
Set-ItemProperty 'IIS:\Sites\MainSite\website1' -name applicationPool -value '.NET v4.5 Classic'
New-Item 'IIS:\Sites\MainSite\website2' -Type Application -PhysicalPath c:\web\company.com\website2
Set-ItemProperty 'IIS:\Sites\MainSite\website2' -name applicationPool -value '.NET v4.5 Classic'
New-Item 'IIS:\Sites\MainSite\website3' -Type Application -PhysicalPath c:\web\company.com\website3
Set-ItemProperty 'IIS:\Sites\MainSite\website3' -name applicationPool -value '.NET v4.5 Classic'
#Create webservice applications
New-Item 'IIS:\Sites\MainSite\webservice' -Type Application -PhysicalPath c:\web\company.com\webservice
Set-ItemProperty 'IIS:\Sites\MainSite\webservice' -name applicationPool -value '.NET v4.5 Classic'
#Create webservice application2
New-Item 'IIS:\Sites\MainSite\webservice2' -Type Application -PhysicalPath c:\web\company.com\webservice2
Set-ItemProperty 'IIS:\Sites\MainSite\webservice2' -name applicationPool -value '.NET v4.5 Classic'
#Create webservice application3
New-Item 'IIS:\Sites\MainSite\webservice3' -Type Application -PhysicalPath c:\web\company.com\webservice3
Set-ItemProperty 'IIS:\Sites\MainSite\webservice3' -name applicationPool -value '.NET v4.5 Classic'
#Increase max worker processes to 4
Set-ItemProperty IIS:\AppPools\".NET v4.5 Classic" -name processModel.maxProcesses -value 4
#Redirect IIS logging
New-Item c:\logs -type directory
icacls "C:\logs" /grant 'IIS_IUSRS:(OI)(CI)M'
icacls "C:\windows\temp" /grant 'IIS_IUSRS:(OI)(CI)M'
icacls "C:\web\" /grant 'IIS_IUSRS:(OI)(CI)M'
Set-ItemProperty 'IIS:\Sites\MainSite' -name logFile.directory -value 'C:\logs'
Start-Website 'MainSite'
Start-Sleep -s 5
#Recycle IIS
IISRESET
echo "config complete"
