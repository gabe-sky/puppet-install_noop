#!/bin/bash

# Run the Puppet agent in "no-noop" mode, but only apply resources that are
# essential to the agent's functioning -- i.e. those tagged "puppet_enterprise"
/opt/puppetlabs/puppet/bin/puppet agent \
  --no-daemonize --onetime \
  --no-noop --tags puppet_enterprise
