# Workflows for Unified Key Orchestrator for IBM z/OS

A detailed documentation of how to use the installation workflows can be found in the [UKO for z/OS installation documentation](https://www.ibm.com/docs/en/ukofz/3.1?topic=installation). 

These workflows will help you with the installation of UKO for z/OS. There are installation workflows (called `provision.xml`) for the following components:
* [ukousers](https://www.ibm.com/docs/en/ukofz/3.1?topic=installation-required-user-ids): helps you to set up the technical user IDs to run UKO and its components, typically started task users and groups. In addition, you can use it to define the differend users that will use the product afterwars, like key administrators and custodians.
* [ukokeyring](https://www.ibm.com/docs/en/ukofz/3.1?topic=installation-certificates-keyrings): helps you to define the required certificate authority, keyring(s) and certificates required by the UKO server. 
* [ukodb](https://www.ibm.com/docs/en/ukofz/3.1?topic=installation-database-setup): helps you to create the UKO database by assembling one big DDL file from the individual DDL files that are shipped with the UKO database component code. It will also help you to grant access to the created views and tables. 
* [ukoserver](https://www.ibm.com/docs/en/ukofz/3.1?topic=installation-liberty-server): helps you to configure the UKO liberty server by creating the required directories, configuration files, started task and secirity definitions. 
* [ukoagent](https://www.ibm.com/docs/en/ukofz/3.1?topic=installation-agent): If you plan to manage keys in z/OS keystores, you will need a UKO agent. The provided installation workflow will help you to create the required configuration file, started task and security configuration 

In addition to the installation workflows, the following workflows for [migration](https://www.ibm.com/docs/en/ukofz/3.1?topic=installation-migration) are provided:
* ukoserver provides a migration workflow called `updateServer.xml` to migrate from your existing installation to the latest version of UKO
* ukodb provides a migration workflow called `updateDatabase.xml` to migrate the database to the latest version of UKO

In addition, there are the following workflows: 
* ukodb provides a workflow to collect information from the global catalog and [fill the Data sets dashboard](https://www.ibm.com/docs/en/ukofz/3.1?topic=how-populating-data-sets-panel) with information about z/OS data set encryption called `refreshDatasetDashboard.xml`