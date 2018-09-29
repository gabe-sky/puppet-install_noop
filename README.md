# install_noop

Sometimes you want to install a Puppet Enterprise agent on some nodes, but you're too afraid to let it actually manage anything yet.  In these cases you might install it and set "noop=true" in the puppet.conf before its first run.  That way it's running, its facts and reports are getting stored in PuppetDB, but it's really only reporting on what it *would* change if you gave it the chance to do its job.

These Bolt tasks automate the job.  Briefly, they:

1. Fetch the installer script from a master,
2. Run the installer, but tell it to add "noop=true" to the puppet.conf before starting Puppet,
3. Try a limited run of the agent, only applying "puppet_enterprise" classes, and
4. Start up the Puppet (in noop mode) and PXP-Agent services

## With Autosigning (one-step)

If you have [autosigning enabled](https://puppet.com/docs/puppet/latest/ssl_autosign.html) on your master, these tasks will have your agent up and running in one fell swoop.

* Puppet agent running,
* Puppet execution protocol configured, and
* Puppet execution protocol running.

Installing an agent in noop mode is as simple as, for example:

    bolt task run install_noop::linux master=kermit.puppetlabs.vm \
      --no-host-key-check --user root --password \
      --nodes ssh://waldorf,ssh://statler

Or an example for Windows:

    bolt task run install_noop::windows master=kermit.puppetlabs.vm \
      --no-ssl --user Administrator --password \
      --nodes winrm://rizzo

For more information on Bolt's configuration and command-line options, refer to [the Bolt online documentation](https://puppet.com/docs/bolt/0.x/bolt.html).

## Without Autosigning (two-step)

If you don't have [autosigning enabled](https://puppet.com/docs/puppet/latest/ssl_autosign.html) on your master, you will need to do a two-step process.

1. Run install_noop::linux or install_noop::windows on nodes,
1. Sign the new nodes' certificates, and
1. Run install_noop::linux_postsign or install_noop::windows_postsign.

For instance, the whole process on Linux:

    # Install the agent on the node, in "noop" mode:
    bolt task run install_noop::linux master=kermit.puppetlabs.vm \
      --no-host-key-check --user root --password \
      --nodes ssh://waldorf,ssh://statler
    #
    # Sign the node's certificate on the master
    #
    # Run the agent in a limited fashion, to finish configuring it:
    bolt task run install_noop::linux_postsign \
      --no-host-key-check --user root --password \
      --nodes ssh://waldorf,ssh://statler

## Limitations

* This task can only install Puppet Enterprise, fetching from a Puppet Enterprise master.
* The methodology here has not been rigorously tested -- but it has been field tested in a handful of environments.
* Your master must be classified with the proper [pe_repo classes](https://puppet.com/docs/pe/latest/installing_agents.html) for each platform you wish to install to.
