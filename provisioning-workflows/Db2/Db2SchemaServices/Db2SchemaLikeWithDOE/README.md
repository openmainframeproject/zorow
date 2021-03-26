# Db2 for z/OS "Create Schema Like" as a Service

You can use this service template and IBM Db2 DevOps Experience for z/OS to rapidly provision a logical collection of database objects without data, within an existing Db2 for z/OS subsystem or from one subsystem to another. The objects include databases, tables, indexes, views, triggers, and so on. The service runs as a software service template.

The software service template is built on the z/OSMF cloud provisioning services infrastructure. For information about about how to load and use the service in z/OSMF, see [Software Services Task](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.zosmfcore.softwareconfig.help.doc/izuSChpSoftwareConfigTask.html).

The service includes a list of actions for **provision**, **create schema**, **drop schema** and **deprovision**.

## Contents
This readme contains the following sections:
* [**Prerequisites**](#prerequisites)
* [**Setting up the service**](#setting-up-the-service)
* [**`provision.xml`**](#provisionxml)
* [**`createschema.xml`**](#createxml)
* [**`dropschema.xml`**](#dropschemaxml)
* [**`deprovision.xml`**](#deprovisionxml)
* [**`clouddb2.input`**](#Clouddb2input)

## Prerequisites
* A Db2 subsystem is installed on the system where the provision will take place.
* IBM Db2 DevOps Experience for z/OS V1.1 is installed with APAR UI63018 or higher.
* The workflow files are copied from the factory location and the `clouddb2.input` file is customized for use in the local environment.
* The following environment variables are customized in `deprovision.sh`, which is supplied with the service.
    * DESP_JAR: the full path to the directory that contains `DOEExecutor-1.0.jar`, which is supplied with the service
    * JAVA_HOME: the full path to the JDK installation directory
* If you are using RACF security for Db2 and using the default `CREATERACF.jcl` to create RACF group and user, RACF profile BATCH must be defined on the subsystem where the provision will take place. If you are not using `<mvsname>.BATCH`, you must modify the `CREATERACF.jcl` to reflect the RACF BATCH profile that is defined in the environment.

## Setting up the service
The files of the service are stored in a directory in z/OS UNIX System Services (USS), and the directory including sub-directories and files must be accessible to z/OSMF. All required files are packed in the `Db2SchemaService.pax` file.

1. Download the `Db2SchemaService.pax` file.
2. Use FTP to upload the pax file in binary mode to a directory where you want to store the service in USS.
3. Extract the contents of the pax file in the directory where you put the pax file.
     ```
     pax -rvf Db2SchemaService.pax
     ```

Extracting produces the following directory structure:
```
    <service base directory>    -- All sub-directories and files of the service
        <security>              -- Workflow to provision security configuration
        provision.xml           -- Workflow to provision schema like
        createschema.xml        -- Workflow to create schema
        dropschema.xml          -- Workflow to drop schema
        deprovision.xml         -- Workflow to deprovision schema 
        actions.xml             -- Actions of the service
        clouddb2.input          -- Sample input variable file to be customized
        doeProvision.sh         -- Provision shell script
        doeDeprovision.sh       -- Deprovision shell script
        DOEExecutor-1.0.jar     -- Deprovision Java program
```

## `provision.xml`
The workflow that is also the first action is triggered automatically when you run from the published software service template. The workflow generates a unique instance name. It consists of the following steps:

0. Generate a unique instance name from which the required unique values of workflow variables are derived, and prepare the related variables.

Customize the security JCLs based on your security solution, policy, and profiles before running the workflow.

The following table lists the steps:

| Step | Description                                        | JCL            | Optional |
| ---  | ---                                                | ---            | ---      |
| 0    | Provision instance name dynamically                | N/A(REST call) | NO       |

## `createschema.xml`

The workflow provisions a logical collection of database objects in an existing Db2 subsystem like those in another. It consists of the following steps:

1. Call the DevOps Experience for Db2 for z/OS server to dynamically provision the schema of the data objects like the source environment.
2. Retrieve the schema and database name of the provisioned schema instance and JDBCURL for Java application to connect to the Db2 subsystem.
3. Call the `provisionSecurity.xml` workflow to provision security configuration. The provisionSecurity workflow contains the following sub-steps:
    1. Add a RACF group and a user, to grant DBADM to the group and to give permission of running BATCH job, assuming the profile BATCH is defined ahead, on the subsystem.
    2. Create a role with DBADM authority of the databases created in the first step, and to create a local and a remote trusted context with the role. This should be run once and shared among the different instances.
    3. Create a RACF map to map a distributed identity to the trusted context.
    4. Assign DBADM privilege of these objects to the user for whom the database objects are provisioned.
   All the above sub-steps are optional based on the need. For information about skipping workflow steps, see the description of input variable file section.

Customize the security JCLs based on your security solution, policy, and profiles before running the workflow.

The following table lists the steps:

| Step | Description                                        | JCL            | Optional |
| ---  | ---                                                | ---            | ---      |
| 0    | Provision instance name dynamically                | N/A(REST call) | NO       |
| 1    | Provision a schema like the source environment     | N/A            | NO       |
| 1a   | Retrieve the information of the provisioned schema | N/A            | NO       |
| 2    | Provision security configuration                   | N/A            | YES      |

The following table lists the sub-steps of the `provisionSecurity.xml` workflow:

| Step | Description                                                                     | JCL         | Optional |
| ---  | ---                                                                             | ---         | ---      |
| 1    | Create a RACF group and user with DBADM authority of the objects                | CREATERACF  | YES      |
| 2    | Create a local and remote trusted context granting a role with DBADM authority  | CREATETC    | YES      |
| 3    | Create a RACF map to the trusted context                                        | CREATETCMAP | YES      |
| 4    | Grant DBADM authority of these objects to a user                                | GRANTU      | YES      |


## `dropschema.xml`

The workflow that drives the "dropschema" action for the instance and deprovisions a logical collection of database objects under a schema from an existing Db2 subsystem. The workflow consists of the following steps:

1. Call the `deprovisionSecurity.xml` workflow to deprovision security configuration. The deprovisionSecurity workflow contains the following sub-steps:
    1. Revoke the DBADM privilege from the user that the database objects are provisioned for.
    2. Delete the provisioned RACF map.
    3. Delete the provisioned trusted contexts and role.
    4. Delete the provisioned RACF group and user. All the above sub-steps are optional based on the need, refer to the description of input variable file section on how to skip a certain step in the workflow.
2. Drop the provisioned schema instance.

The following table lists the steps:

| Step | Description                        | JCL            | Optional |
| ---  | ---                                | ---            | ---      |
| 1    | Drop schema security configuration | N/A            | YES      |
| 2    | Drop schema the provisioned schema | N/A            | NO       |

The following table lists the sub-steps of the `deprovisionSecurity.xml`workflow:

| Step | Description                            | JCL         | Optional |
| ---  | ---                                    | ---         | ---      |
| 1    | Revoke DBADM authority from a user     | REVOKEU     | YES      |
| 2    | Delete RACF map of the trusted context | DELETETCMAP | YES      |
| 3    | Delete trusted contexts and role       | DELETETC    | YES      |
| 4    | Delete a RACF group and user           | DELETERACF  | YES      |

## `deprovision.xml`

The workflow that completes the "deprovision" action for the instance. The workflow consists of the following steps:

1. Deprovision to mark the workflow of the provisioned schema instance as completed.

The following table lists the steps:

| Step | Description                        | JCL            | Optional |
| ---  | ---                                | ---            | ---      |
| 0    | Deprovision completed              | N/A            | YES      |


## `clouddb2.input`

The workflow variable input file, which contains the following properties:

| Property | Remarks |
| ---      | ---     |
| DBNAME     | The new name of the database to be created. The name is provisioned dynamically if the value is blank|
| SCHEMANAME | The new name of the schema under which the data objects are created. The name is provisioned dynamically if the value is blank|
| DSNLOAD   | The name of the main APF-authorized Db2 load module library that is to be used by sample jobs|
| DSNEXIT   | The name of the main APF-authorized Db2 exit library that is to be used by sample jobs|
| DSNZPARM  | The Db2 subsystem parameters load module|
| MVSSNAME  | The z/OS subsystem name for Db2, where the database will be provisioned and deprovisioned|
| PROGNAME  | The name of the program to execute dynamic queries, for example: DSNTEP2|
| PLANNAME  | The name of the plan for the program to execute dynamic queries, for example: DSNTEPB1|
| RUNLIB    | The name of the Db2 sample application load module library, where program to execute dynamic queries can be found|
| SQLID     | The ID used to execute the DDL to create the sample databases|
| USERNAME  | User name of DBADM of the DATABASE. If the value is blank, the step to grant the privilege is skipped|
| db2RESTServiceSecure | Status of security enablement for Db2 Native Rest services (Access though http or https) |
| provisionShell   | The full path name of the provision shell script|
| deprovisionShell | The full path name of the deprovision shell script|
| doeHost          | The hostname of the Db2 DevOps Experience (DOE) server on the target Db2 subsystem|
| doePort          | The port number of the DOE server on the target Db2 subsystem|
| doeUsername      | The user name of the DOE server on the target Db2 subsystem|
| appName          | The application name in the DOE server on the target Db2 subsystem|
| envName          | The environment name in the DOE server on the target Db2 subsystem|
| teamName         | The team name in DOE server on the target Db2 subsystem|
| instanceNamePrefix  | The prefix of the instance name in the DOE server on the target Db2 subsystem|
| CONTEXTNAME       | The name of the local trusted context|
| REMOTECONTEXTNAME | The name of the remote trusted context|
| CLIENTIPADDRESS   | The IP address to be authenticated and added into the remote trusted context|
| ROLENAME          | The name of the role to be granted as DBADM and to be used in the trusted contexts. If the value is blank, the step to create the role and trusted contexts is skipped|
| LTCUSERNAME       | The system user id used in the local trusted context|
| RMTUSERNAME       | The system user id used in the remote trusted context|
| RMTUSER           | The user id who can use the remote trusted context|
| RMTDISTID         | The distributed identity user name to be mapped to the remote trusted context. If the value is blank, the step to create the RACF distributed map is skipped|
| RMTDISTREG        | The distributed identity registry name to be used in the RACF map|
| RACFOWNER         | The owner of the RACF group to be added|
| RACFSUPERGRP      | The name of the super RACF group|
| RACFGROUP         | The name of the RACF group to be added. If the value is blank, the step to add RACF group and user is skipped|
| RACFUSER          | The name of the RACF user to be connected into the group|
