# Readme file for Db2 for z/OS "Create Schema Like" as a Service

You can use Db2 for z/OS "Create Schema Like" as a Service to rapidly provision a logical collection of database objects, with or without data, within an existing Db2 subsystem or from one subsystem to another. The objects include databases, tables, indexes, views, triggers, and so on. The service runs as a software service template. The instance name prefix of the software services requires an asterisk at the end, so that z/OS Management Facility(z/OSMF) can generate an identifier and ensure unique database and schema names for each instance.

The software service template is built on the z/OSMF cloud provisioning service infrastructure. For information about about how to load and use the service in z/OSMF, see [Software Services Task](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.zosmfcore.softwareconfig.help.doc/izuSChpSoftwareConfigTask.html).

The service requires Db2 Administration Tool for z/OS with APAR PI67731/PI72396/PI76054, and Db2 Cloning Tool for z/OS with APAR PH00169.

The service includes a list of actions **provision**, **RefreshData**, **Snapshot**, **Restore**, and **deprovision**.

This readme contains the following sections:
* **Prerequisites**
* **Known restrictions**
* **Setting up the service**
* **`provision.xml`**
* **`refresh.xml`**
* **`snapshot.xml`**
* **`restore.xml`**
* **`deprovision.xml`**
* **`clouddb2.input`**

## Prerequisites
* A Db2 subsystem is installed on the system where the provision will take place.
* Db2 Administration Tool for z/OS is installed with APAR PI67731/PI72396/PI76054.
* Db2 Cloning Tool for z/OS is installed with APAR PH00169.
* The workflow files are copied from the factory location and the `clouddb2.input` file is customized for use in the local environment.
* The `DEPROVISION_SCHEMA` stored procedures is set up on the target environment, see [Deprovision Stored Procedure](https://github.com/IBM/Db2ZTools/tree/master/DevOps/Db2SchemaServices/Dependency/DeprovisionStoredProcedure).
* The RACF profile on the Db2 subsystem is step up to use RACF PassTicket.
* A JDBC driver and the RACF PassTicket jar files are installed on the Unix System Services (USS) of the Db2 subsystem.
* The following environment variables are customized in `deprovision.sh`, which is supplied with the service.
    * DESP_JAR: the full path to the directory that contains `DeprovisionService.jar`, which is supplied with the service
    * JAVA_HOME: the full path to the JDK installation directory
    * JDBC_HOME: the full path to the JDBC driver directory
    * RACF_HOME: the full path to RACF JAR files
* If you are using RACF security for Db2 and using the default `CREATERACF.jcl` to create RACF group and user, RACF profile BATCH must be defined on the subsystem where the provision will take place. If you are not using `<mvsname>.BATCH`, you must modify the `CREATERACF.jcl` to reflect the RACF BATCH profile that is defined in the environment.

## Known restrictions
* Any schema changes against a provisioned Db2 object where its source does not contain system pages might cause Db2 errors. For more information, see Db2 APAR PI86880.
* The service does not support source objects that are in implicitly created databases.

## Setting up the service
The files of the service are stored in a directory in z/OS UNIX System Services (USS), and the directory including sub-directories and files must be accessible to z/OSMF. All the required files are packed into the pax file.

1. Download the pax file.
2. Use FTP to upload the pax file in binary mode to a directory where you want to store the service in USS.
3. Extract the contents of the pax file in the directory where you put the pax file.
    - pax -rvf `<the name of the pax file>`

Extracting produces the following directory structure:
```
    <service base direcotry>    -- all sub-direcotry and files of the service
        <admintool>             -- Db2 Administration Tool workflows and JCL templates
        <cloningtool>           -- Db2 Cloning Tool workflows and JCL templates
        <snapshot>              -- Workflow to create snapshots of the provisioned database schema and data
        <restore>               -- Workflow to restore a certain snapshot
        <security>              -- Workflow to provision security configuration
        provision.xml           -- Workflow to provision schema like
        deprovision.xml         -- Workflow to deprovision schema and related snapshots
        actions.xml             -- Actions of the service
        clouddb2.input          -- Sample input variable file to be customized
        deprovision.sh          -- Deprovision shell script
        DeprovisionService.jar  -- Deprovision Java program
```
The workflows and JCL template files for Db2 Administration Tool and Cloning Tool are shipped with those products and must be copied into the corresponding directories.

## `provision.xml`
A workflow that is also the first action triggered automatically when you run from the published software service template. The workflow provisions a logical collection of database objects in an existing Db2 subsystem like those in another. The workflow consists of the following steps.

0. Generates a unique instance name from which the required unique values of workflow variables are derived, and prepare the related variables.
1. Calls the Db2 Administration Tool workflow to dynamically extract the schema of the data objects from the source environment.
2. Calls another workflow to run the extracted DDL schema against the target environment. The sixth step is optional, and it calls another workflow to provision security configuration against the provisioned schema.
3. Call provisionSecurity workflow to provision security configuration. The provisionSecurity workflow contains the following sub-steps:
    1. Add a RACF group and a user, to grant DBADM to the group and to give permission of running BATCH job, assuming the profile BATCH is defined ahead, on the subsystem.
    2. Create a role with DBADM authority of the databases created in the first step, and to create a local and a remote trusted context with the role. This should be run once and shared among the different instances.
    3. Create a RACF map to map a distributed identity to the trusted context.
    4. Assign DBADM privilege of these objects to the user for whom the database objects are provisioned.
    All the above sub-steps are optional based on the need, refer to the description of input variable file section on how to skip a certain step in the workflow.

Customize the security JCLs based on your security solution, policy and profiles before running the workflow.

The following table lists the steps:

| Step | Description                                        | JCL            | Optional |
| ---  | ---                                                | ---            | ---      |
| 0a   | Provision instance name dynamically                | N/A(REST CALL) | NO       |
| 0a1  | Check selected objects                             | N/A            | YES      |
| 0b   | Generate values for the required variables stage 1 | N/A            | NO       |
| 0c   | Generate values for the required variables stage 2 | N/A            | NO       |
| 0d   | Check selected objects                             | N/A            | YES      |
| 1a   | Extract database definition for selected objects   | N/A            | YES      |
| 1b   | Extract the schema from the source environment     | N/A            | NO       |
| 2    | Run the extracted DDL                              | N/A            | NO       |
| 3    | Provision security configuration                   | N/A            | YES      |

Sub-steps of `provisionSecurity.xml`:

| Step | Description                                                                     | JCL         | Optional |
| ---  | ---                                                                             | ---         | ---      |
| 1    | Create a RACF group and user with DBADM authority of the objects                | CREATERACF  | YES      |
| 2    | Create a local and remote trusted context granting a role with DBADM authority  | CREATETC    | YES      |
| 3    | Create a RACF map to the trusted context                                        | CREATETCMAP | YES      |
| 4    | Grant DBADM authority of these objects to a user                                | GRANTU      | YES      |

See APAR PI67731 for the description of the `wfadbgen.xml` workflow and corresponding input variables.
See APAR PI72396 for the description of the `wfadbtep2.xml` workflow.

The **RefreshData** action is driven by the Cloning Tool workflow directly with the variables prepared by `provision.xml` and passed in through `actions.xml`.

## `snapshot.xml`
The workflow that drives "Snapshot" action of the instance and creates a snapshot of the provisioned database schema and the data in it. The workflow consists of the following seven steps:

0. Generate unique database and schema names for the snapshot, and prepare the required variables for the workflow.

1. Invoke the Db2 Administration Tool workflow to dynamically extract the schema of the provisioned data objects, which can be modified by now.

2. Call another workflow to run the extracted DDL schema to create the snapshot.

3. Calls the Db2 Cloning Tool workflow to clone the data from the provisioned data  objects into the snapshot data objects.

The following table lists the steps:

| Step | Description                                        | JCL            | Optional |
| ---  | ---                                                | ---            | ---      |
| 0a   | Provision instance name dynamically                | N/A(REST CALL) | NO       |
| 0b   | Generate values for the required variables stage 1 | N/A            | NO       |
| 0c   | Generate values for the required variables stage 2 | N/A            | NO       |
| 0d   | Generate values for the required variables stage 3 | N/A            | NO       |
| 1    | Extract the schema from the source environment     | N/A            | NO       |
| 2    | Run the extracted DDL                              | N/A            | NO       |
| 3    | Clone the data                                     | N/A            | NO       |

## `restore.xml`
The workflow that drives "Restore" action of the instance and creates a snapshot of the provisioned database schema and the data in it. The workflow consists of the following steps:
0. Prepare the required variables for the workflow.
1. Clean up the provisioned data objects.
2. Invoke the Db2 Administration Tool workflow to dynamically extract the schema of the snapshot data objects.
3. Call another workflow to restore the snapshot data objects to the provisioned database schema.
4. Restore the security configuration.
5. Invoke Db2 Cloning Tool workflow to clone the data  from the snapshot into the restored data objects.

The following table lists the steps:

| Step | Description                                   | JCL | Optional |
| ---  | ---                                           | --- | ---      |
| 0a   | Prepare required variable                     | N/A | NO       |
| 1    | Clean up provisioned data objects for restore | N/A | NO       |
| 2    | Extract the schema from a certain snapshot    | N/A | NO       |
| 3    | Restore the provisioned data objects          | N/A | NO       |
| 4    | Restore the security configuration            | N/A | NO       |
| 5    | Restore the data                              | N/A | NO       |

## `deprovision.xml`
The workflow that drives "deprovision" action of the instance and deprovisions a logical collection of database objects under a schema from an existing Db2 subsystem. The workflow consists of the following steps:

1. Call deprovisionSecurity workflow to deprovision security configuration. The deprovisionSecurity workflow contains the following sub-steps:
    1. Revoke the DBADM privilege from the user that the database objects are provisioned for.
    2. Delete the provisioned RACF map.
    3. Delete the provisioned trusted contexts and role.
    4. Delete the provisioned RACF group and user. All the above sub-steps are optional based on the need, refer to the description of input variable file section on how to skip a certain step in the workflow.
2. Drop the database that holds all the data objects.
3. Cleans up the intermediate PDS member.

The following table lists the steps:

| Step | Description                        | JCL            | Optional |
| ---  | ---                                | ---            | ---      |
| 1    | Deprovision security configuration | N/A            | YES      |
| 2    | Drop the database objects          | Inline         | NO       |
| 3    | Clean up intermediate PDS member   | N/A(REST CALL) | NO       |

Sub-steps of `deprovisionSecurity.xml`:

| Step | Description                            | JCL         | Optional |
| ---  | ---                                    | ---         | ---      |
| 1    | Revoke DBADM authority from a user     | REVOKEU     | YES      |
| 2    | Delete RACF map of the trusted context | DELETETCMAP | YES      |
| 3    | Delete trusted contexts and role       | DELETETC    | YES      |
| 4    | Delete a RACF group and user           | DELETERACF  | YES      |

## `clouddb2.input`
`clouddb2.input` is the workflow variable input file containing the following properties:

| Property | Remarks |
| ---      | ---     |
| DBNAME     | The new name of the database to be created. The name is provisioned dynamically if the value is blank|
| SCHEMANAME | The new name of the schema under which the data objects are created. The name is provisioned dynamically if the value is blank|
| GMDB       | The name of the source golden copy database|
| GMSCHEMA   | The schema name of the data objects in the source golden copy database|
| newdb      | The intermediate variable whose value is generated dynamically|
| newsch     | The intermediate variable whose value is generated dynamically|
| DDLPDS     | The name of partitioned dataset to keep the extracted DDL schema|
| CTLOGPDS   | The name of partitioned dataset to keep the intermediate log records|
| CTSYNCPDS  | The name of partitioned dataset to keep the synchronization records|
| DSNLOAD   | The name of the main APF-authorized Db2 load module library that is to be used by sample jobs|
| DSNEXIT   | The name of the main APF-authorized Db2 exit library that is to be used by sample jobs|
| DSNZPARM  | The Db2 subsystem parameters load module|
| MVSSNAME  | The z/OS subsystem name for Db2, where the database will be provisioned and deprovisioned|
| PROGNAME  | The name of the program to execute dynamic queries, e.g. DSNTEP2|
| PLANNAME  | The name of the plan for the program to execute dynamic queries, e.g. DSNTEPB1|
| RUNLIB    | The name of the Db2 sample application load module library, where program to execute dynamic queries can be found|
| SQLID     | The ID used to execute the DDL to create the sample databases|
| USERNAME  | User name of DBADM of the DATABASE. If the value is blank, the step to grant the privilege is skipped|
| deprovisionShell | The full path name of deprovision shell script|
| racfappid        | The RACF ApplID used to generate RACF passticket to execute deprovision stored procedure|
| hostname         | The hostname of target Db2 subsystem|
| db2port          | The port number of target Db2 subsystem|
| db2location      | The location of target Db2 subsystem|
| conn_userid      | Userid to connect to the target Db2 subsystem with RACF passticket|
| deprocSPSchema   | The schema name of stored procedure DEPROVISION_SCHEMA|
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

The following called workflows and the corresponding input variables are described in APARs.

* For `wfadbtep2.xml`, see APAR PI72396.
* For `wfadbgen.xml`, see APAR PI67731.
* For `wfCKZappClone.xml`, see APAR PH00169.

The following list of variables from Db2 Administration Tool and Cloning Tool workflows must be blank in the input variable file because the values of these variables are generated dynamically.
* The following variables from the Db2 Administration Tool workflow: `sqldd`, `ddlin`
* The following variables from the Db2 Cloning Tool workflow: `objxlat`

The `tgtdb2` variable from the Db2 Cloning Tool workflow should not be put into the input variable file because its name is a duplicate of one from Db2 Administration Tool. The service has logic to handle that variable dynamically.
The data objects that are created in implicit database will still be created in implicit database on the target environment.
