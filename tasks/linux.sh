#!/bin/bash

# Fetch the installer and run it with an extra flag that adds "noop = true" to
# the "agent" section of the puppet.conf.  Do not try to do a first run.
curl -k https://$PT_master:8140/packages/current/install.bash | sudo bash \
  -s agent:noop=true --puppet-service-ensure stopped

# Try to run the Puppet agent in "no-noop" mode, only applying resources that
# are essential to the agent's functioning -- i.e. those tagged
# "puppet_enterprise".  This run will succeed if autosigning is enabled on the
# master, or will complain that it can't fetch a certificate if not.
/opt/puppetlabs/puppet/bin/puppet agent \
  --no-daemonize --onetime \
  --no-noop --tags puppet_enterprise

# Now, start up the Puppet agent and pxp-agent.
/opt/puppetlabs/puppet/bin/puppet resource service puppet ensure=running
/opt/puppetlabs/puppet/bin/puppet resource service pxp-agent ensure=running
