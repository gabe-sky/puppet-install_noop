# Disable SSL validation
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

# Fetch the installer
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile("https://${env:PT_master}:8140/packages/current/install.ps1", 'C:\Windows\Temp\install.ps1')

# Run the installer, but set noop=true in the puppet.conf, and don't do a first
# run
C:\Windows\Temp\install.ps1 agent:noop=true -PuppetServiceEnable false -PuppetServiceEnsure stopped

# Try to run the Puppet agent in "no-noop" mode, only applying resources that
# are essential to the agent's functioning -- i.e. those tagged
# "puppet_enterprise".  This run will succeed if autosigning is enabled on the
# master, or will complain that it can't fetch a certificate if not.
& 'C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat' agent --no-daemonize --onetime --no-noop --tags puppet_enterprise

# Ensure that Puppet agent is running
Set-Service -Name puppet -StartupType automatic -Status running
Set-Service -Name pxp-agent -StartupType automatic -Status running
