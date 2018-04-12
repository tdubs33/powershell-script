Import-Module "WebAdministration"
#Set up directories for web content
New-Item c:\web\company.com\webservice1 -type directory
New-Item c:\web\company.com\webservice2 -type directory
New-Item c:\web\company.com\webservice3 -type directory
#Add a page so we know IIS is working
Set-Content c:\web\company.com\webservice1\default.htm "Welcome to webservice1"
Set-Content c:\web\company.com\webservice2\default.htm "Welcome to webservice2"
Set-Content c:\web\company.com\webservice3\default.htm "Welcome to webservice3"
#make some webservices
New-Item 'IIS:\Sites\Default Web Site\webservice1' -Type Application -PhysicalPath c:\web\company.com\webservice1
Set-ItemProperty 'IIS:\Sites\Default Web Site\webservice1' -name applicationPool -value '.NET v4.5 Classic'
New-Item 'IIS:\Sites\Default Web Site\webservice2' -Type Application -PhysicalPath c:\web\company.com\webservice2
Set-ItemProperty 'IIS:\Sites\Default Web Site\webservice2' -name applicationPool -value '.NET v4.5 Classic'
New-Item 'IIS:\Sites\Default Web Site\webservice3' -Type Application -PhysicalPath c:\web\company.com\webservice3
Set-ItemProperty 'IIS:\Sites\Default Web Site\webservice3' -name applicationPool -value '.NET v4.5 Classic'
