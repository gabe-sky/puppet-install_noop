# Run Puppet, but only for essential puppet_enterprise modules.
& 'C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat' agent --no-daemonize --onetime --no-noop --tags puppet_enterprise
