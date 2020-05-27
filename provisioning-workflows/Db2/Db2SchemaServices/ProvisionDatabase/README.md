# Readme file for Db2 for z/OS "Create Database" as a Service

The service allows you to rapidly provision a database in an existing Db2 subsystem.

This readme contains the following sections:
* **Prerequisites**
* **Setting up the service**
* **`provision.xml`**
* **`deprovision.xml`**
* **`clouddb2.input`**

## Prerequisites
* A Db2 subsystem is installed on the system where the provision will take place.
* The workflow files have been copied from the factory location and the `clouddb2.input` file customized for use in the local environment.
* The following privileges have been granted to the user specified in the JOBCARD: CREATEDBA privilege or SYSADM authority or System DBADM authority.
* The `DEPROVISION_SCHEMA` stored procedures is set up on the target environment, see [Deprovision Stored Procedure](https://github.com/IBM/Db2ZTools/tree/master/DevOps/Db2SchemaServices/Dependency/DeprovisionStoredProcedure).
* The RACF profile on the Db2 subsystem is step up to use RACF PassTicket.
* A JDBC driver and the RACF PassTicket jar files are installed on the Unix System Services (USS) of the Db2 subsystem.
* The following environment variables are customized in `deprovision.sh`, which is supplied with the service.
    * DESP_JAR: the full path to the directory that contains `DeprovisionService.jar`, which is supplied with the service
    * JAVA_HOME: the full path to the JDK installation directory
    * JDBC_HOME: the full path to the JDBC driver directory
    * RACF_HOME: the full path to RACF JAR files
* If you are using RACF security for Db2 and using the default `CREATERACF.jcl` to create RACF group and user, RACF profile BATCH must be defined on the subsystem where the provision will take place. If you are not using `<mvsname>.BATCH`, you must modify the `CREATERACF.jcl` to reflect the RACF BATCH profile that is defined in the environment.

## Setting up the service
The files of the service are stored in a directory in z/OS UNIX System Services (USS), and the directory including sub-directories and files must be accessible to z/OSMF. All the required files are packed into the pax file.

1. Download the pax file.
2. Use FTP to upload the pax file in binary mode to a directory where you want to store the service in USS.
3. Extract the contents of the pax file in the directory where you put the pax file.
    - pax -rvf `<the name of the pax file>`

Extracting produces the following directory structure:
```
    <service base direcotry>    -- all files of the service
        <security>              -- Workflow to provision security configuration
        provision.xml           -- Workflow to provision a database
        deprovision.xml         -- Workflow to deprovision the provisioned database
        actions.xml             -- Actions of the service
        clouddb2.input          -- Sample input variable file to be customized
        CREATDB.jcl             -- JCL template to create a database
        deprovision.sh          -- Deprovision shell script
        DeprovisionService.jar  -- Deprovision Java program
```

## `provision.xml`
This is the workflow that provisions a database in an existing Db2 subsystem. The workflow consists of the following steps.

0. Dynamically retrieves the database name and prepare values for deprovision.
1. Create a database in an existing Db2 subsystem.
2. Call provisionSecurity workflow to provision security configuration. The provisionSecurity workflow contains the following sub-steps:
    1. Add a RACF group and a user, to grant DBADM to the group and to give permission of running BATCH job, assuming the profile BATCH is defined ahead, on the subsystem.
    2. Create a role with DBADM authority of the databases created in the first step, and to create a local and a remote trusted context with the role. This should be run once and shared among the different instances.
    3. Create a RACF map to map a distributed identity to the trusted context.
    4. Assign DBADM privilege of these objects to the user for whom the database objects are provisioned.
    All the above sub-steps are optional based on the need, refer to the description of input variable file section on how to skip a certain step in the workflow.

Customize the security JCLs based on your security solution, policy and profiles before running the workflow.

The following table lists the steps:

| Step | Description                         | JCL      | Optional |
| ---  | ---                                 | ---      | ---      |
| 0a   | Dynamically retrieve database name  | N/A      | NO       |
| 0b   | Generate values for deprovision     | N/A      | NO       |
| 1    | Create a DATABASE                   | CREATEDB | NO       |
| 2    | Provision security configuration    | N/A      | YES      |

Sub-steps of `provisionSecurity.xml`:

| Step | Description                                                                     | JCL         | Optional |
| ---  | ---                                                                             | ---         | ---      |
| 1    | Create a RACF group and user with DBADM authority of the objects                | CREATERACF  | YES      |
| 2    | Create a local and remote trusted context granting a role with DBADM authority  | CREATETC    | YES      |
| 3    | Create a RACF map to the trusted context                                        | CREATETCMAP | YES      |
| 4    | Grant DBADM authority of these objects to a user                                | GRANTU      | YES      |

## `deprovision.xml`
The workflow that drives "deprovision" action of the instance and deprovisions a database under a schema from an existing Db2 subsystem. The workflow consists of the following steps:

1. Call deprovisionSecurity workflow to deprovision security configuration. The deprovisionSecurity workflow contains the following sub-steps:
    1. Revoke the DBADM privilege from the user that the database objects are provisioned for.
    2. Delete the provisioned RACF map.
    3. Delete the provisioned trusted contexts and role.
    4. Delete the provisioned RACF group and user. All the above sub-steps are optional based on the need, refer to the description of input variable file section on how to skip a certain step in the workflow.
2. Drop the database and associated data objects.

The following table lists the steps:

| Step | Description                        | JCL            | Optional |
| ---  | ---                                | ---            | ---      |
| 1    | Deprovision security configuration | N/A            | YES      |
| 2    | Deprovision database objects       | Inline         | NO       |

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
| DSNLOAD   | The name of the main APF-authorized Db2 load module library that is to be used by sample jobs|
| MVSSNAME  | The z/OS subsystem name for Db2, where the database will be provisioned and deprovisioned|
| PROGNAME  | The name of the program to execute dynamic queries, e.g. DSNTEP2|
| PLANNAME  | The name of the plan for the program to execute dynamic queries, e.g. DSNTEPB1|
| RUNLIB    | The name of the Db2 sample application load module library, where program to execute dynamic queries can be found|
| SQLID     | The ID used to execute the DDL to create the sample databases|
| USERNAME  | User name of DBADM of the DATABASE. If the value is blank, the step to grant the privilege is skipped|
| DBNAME    | The new name of the database to be created. The name is provisioned dynamically if the value is blank|
| DATABP    | The name of the BUFFERPOOL to be used for data pages, e.g. BP1|
| INDEXBP   | The name of the INDEXBP to be used, e.g. BP1|
| STOGROUP  | The name of the STOGROUP to be used, e.g. SYSDEFLT|
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

