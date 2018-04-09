Import-Module "WebAdministration"
#Set up directories for web content
New-Item c:\web\company.com\webservice4 -type directory
New-Item c:\web\company.com\webservice5 -type directory
New-Item c:\web\company.com\webservice6 -type directory
#Add a page so we know IIS is working
Set-Content c:\web\company.com\webservice4\default.htm "Welcome to webservice4"
Set-Content c:\web\company.com\webservice5\default.htm "Welcome to webservice5"
Set-Content c:\web\company.com\webservice6\default.htm "Welcome to webservice6"
# Configure APP Pool recycling 
#first get a random number between 1 and 59
$rctime = get-random -maximum 59
#tell the app pool to recycle at 05:$lastoctet
Set-ItemProperty -Path "IIS:\AppPools\.NET v4.5 Classic" -Name Recycling.periodicRestart.schedule -Value @{value="05:$rctime"}
#Recycle IIS
IISRESET
echo "Our work here is done!"