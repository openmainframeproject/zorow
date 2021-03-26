# Creating standalone Db2 subsystem provisioning services

With the Db2 software services template, you can create services that rapidly provision from scratch one or multiple standalone Db2 subsystems, in IBM Cloud Provisioning and Management for z/OS. For information about cloud provisioning, including a description of the roles involved, see [Cloud provisioning services](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.1.0/com.ibm.zos.v2r1.izua700/izuprog_CloudProvisioning.htm#CloudProvisioningServices). 

The sample Db2 software service template is built on top of z/OSMF cloud provisioning service infrastructure. For more information about how to load and use the service in z/OSMF, see [Software Services task overview](https://www.ibm.com/support/knowledgecenter/SSLTBW_2.3.0/com.ibm.zos.v2r3.izua300/IZUHPINFO_OverviewSoftwareServices.htm). 

The sample Db2 software service template exploits the Network Resource Pool under the z/OSMF Cloud Provisioning Resource Management. For more information, see [Resource authorizations for the Configuration Assistant plug-in](https://www.ibm.com/support/knowledgecenter/SSLTBW_2.3.0/com.ibm.zos.v2r3.izua300/izuconfig_SecurityStructuresForZosmf.htm?view=kc#DefaultSecuritySetupForZosmf__SecuritySetupRequirementsForConfPlugin). For a tutorial that walks you through the steps that are needed, see [Getting Started Tutorial – Cloud.](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.tcp.ipsec.ipsec.help.doc/com/ibm/tcp/ipsec/cloud/GettingStartedWithCloud.html)  

This readme is intended for the service provider, who configures and makes the Db2 subsystem provisioning service available to consumers in your shop.

## About the sample Db2 software service template

You can use the sample Db2 software service template, to build your own Db2 software service template to provision multiple standalone Db2 12 for z/OS subsystem instances in a “typical Db2 configuration” with the following attributes:
* The subsystem name (`ssid`) is based on two characters that you specify, and a two-digit numeric value that indicates the unique instance. The examples throughout this readme assume that you specify `DY` and that you specify five instances, so that Db2 subsystems are provisioned with the following names for `ssid`: DY00, DY01, DY02, DY03, and DY04. 
* Other names within provisioned Db2 subsystems are based on a standard [naming convention](#naming-conventions). 
* Accepts only TCP/IP connections.
* Subsystem parameter (zPARMS) settings, as recommended by the latest best practices.
* Three dual sets of active logs.
* Archive logs and images copies to DASD only.
* The following work files:
    - For sort work, one 4K and one 32K work file, with PRIQTY 20MB and SEGSIZE 16
	- For declared global temporary tables (DGTT), one 4K and one 32K workfile, with PRIQTY 20MB and SEGSIZE 16
* The following default buffer pools for user data, with 5000 buffers for each: 
    - BP1 for table spaces with 4 KB pages
    - BP8K1 for table spaces with 8 KB pages
    - BP16K1 for table spaces with 16 KB pages
    - BP32K1 for tables spaces with 32 KB pages
    - BP32K2 for LOB data
    - BP16K2 for XML data
    - BP2 for indexes	
* All Db2-supplied stored procedures installed and verified.
* Optionally, the following features enabled and verified: 
    - Db2 REST services
	- ODBC connectivity
	- JDBC type-2 and type-4 connections

Later, you can also use the sample Db2 software service template to deprovision the provisioned Db2 subsystems. 

## Setting up the sample Db2 software service template

The files of the service are stored in a directory in z/OS UNIX System Services (USS), and the directory and files must be accessible to z/OSMF. All required files are compressed into the `Db2ProvisionSystemNonDS.pax` file.

1. Download the `Db2ProvisionSystemNonDS.pax` file.
2. Use FTP in binary mode to upload the `Db2ProvisionSystemNonDS.pax` file to the directory where you want to store the service in USS. The maximum length for the directory name is 40 characters.
3. Extract the file into the directory of your choice, for example: 

    ```
    pax -rvf Db2ProvisionSystemNonDS.pax
    ```

    Inside the directory that you specified, the extracted directory `<service-base-dir>` has the following structure:

    |File|Description| 
    |----|-----------|
    |`dsntiwin.xml`, `dsnopent.xml`|Workflows to provision a Db2 standalone subsystem and enable optional features (Db2 REST services, ODBC, JDBC)|
    |`actions.xml`|A workflow for actions of the service|
    |`dsndeprv.xml`|A workflow to deprovision a Db2 standalone subsystem|
    |`dsnstart.xml`|A workflow for starting the Db2 subsystem|
    |`dsnstop.xml`|A workflow for stopping the Db2 subsystem|
    |`dsndddf.xml`|A workflow for displaying DDF details for the Db2 subsystem|
    |`dsndgrpd.xml`|A workflow for issuing the -DISPLAY GROUP DETAIL command|
    |`dsnoptft.xml`, `dsnopent.xml`|Workflows for enabling optional features (Db2 REST services, ODBC, JDBC)|
    |`dsnti*`|Several JCL templates used by the `dsntiwin.xml`, `dsnopent.xml`, `dsnstart.xml`, `dsnstop.xml`, and `dsndeprv.xml` workflows|
    |`dsnte*`|Several JCL templates used by the `dsntiwin.xml` and `dsnopent.xml` workflows|
    |`dsntivin`|The input property file used by the workflows|

In addition, copy `db2provision.jar` in binary into your installation's DB2BASE/classes directory. This jar file is installed by default in the directory specified by the DDDEF created for SDSNACLS. 

## Preparing the environment for the Db2 software service template

Before building your own template based on the sample, verify with the following adminstrators that their prerequisite tasks are complete:

### Cloud provisioning administrator tasks
* Enable Cloud Provisioning Software Services in the z/OSMF server.
* Enable a network resource pool (NRP) in the z/OSMF server, with a port allocation range enough for the number of instances provisioned. Each Db2 subsystem requires two ports, a port for DRDA and REST services and a RESYNC port.

### System programmer tasks
* Provide the SMP/E Db2 product target libraries, with the the following Db2 12 APARs applied: PI85657, PI97635, PI99403, PH02971, PH05259, and PH06733; and if Db2 REST services will be enabled on the provisioned Db2 subsystems, APARs PI70652 and PI96649.  
* Certify that the SMP/E Db2 product target libraries for SDSNEXIT, SDSNLINK, SDSNLOAD, SDSNLOD2 and IRLM RESLIB are APF-authorized <br>**Note:** SDSNLOD2 is a PDSE data set, which contains JDBC and SQLJ DLLs. Although DB2 does not require that SDSNLOD2 be APF-authorized, be aware that if this data set is in a STEPLIB data set concatenation of an address space that does need APF authorization, SDSNLOD2 must also be APF-authorized. The provisioning template concatenates SDSNLOD2 when verifying JDBC local connection (Type-2) in Optional Features.
* Provide data set names, including for host languages (see `Section 7: Host language data sets`, in the `dsntivin` file.) 
* Provide directories for the following installed FMIDs: 
    - **JDBCC12** for Db2 JDBC/SQLJ. All variables must be set in `Section 6: Db2 Java properties`,  in the `dstnivin` file. 
    - **JDBCC17** for Db2 ODBC. The following variables must be set in `Section 7: Host language data sets`,  in the `dstnivin` file: CCOMP, CPPAUTCL, LELKED, LEPLMSGL, and LERUN.
    - **HDDA211** for z/OS Application Connectivity.
* Verify installation, and provide directories where indicated, for the following installed FMIDs: 
    - **JDBCC12** for Db2 JDBC/SQLJ. All variables must be set in `Section 6: Db2 Java properties`,  in the `dstnivin` file. 
    - **JDBCC17** for Db2 ODBC. The following variables must be set in `Section 7: Host language data sets`,  in the `dstnivin` file: CCOMP, CPPAUTCL, LELKED, LEPLMSGL, and LERUN.
    - **HDDA211** for z/OS Application Connectivity.
    - **HDBCC1K** for Db2 Utilities Suite for z/OS.

### Network administrator tasks
* Provide a range of TCP/IP ports to be used under the Network Resource Pool (NRP). The ports in this range cannot be part of the TCP/IP Profile. 

### Security administrator tasks
* Provide the Db2 authorization IDs in the following table for `Section 4: Db2 authorization IDs` in the `dsntivin` file:

|Field or ID|Input variable|Remarks|
|----|----|----|
|Executor ID for workflow steps|`AGEXECID`|This ID requires authority to generate RACF PassTickets and UPDATE access to the MVSADMIN.WLM.POLICY facility class, if the RACF facility class is active.|
|CONSOLE NAME |`CONSNAME`|This ID must have z/OS console operator authority, to issue Db2 START/STOP commands.|
|ROUTINES CREATOR  |`AUTHID`|The CURRENT SQLID when creating, configuring, and validating Db2-supplied stored procedures. This ID requires the following authorities:<br>- READ access to the MVSADMIN.WLM.POLICY facility class, if the RACF facility class is active<br>- READ access to the MVS.MCSOPER.DSNTRVFY opercmds class, if the RACF opercmds class is active.|
|SEC DEF CREATOR   |`SECDEFID`|The CURRENT SQLID when creating, configuring, and validating Db2-supplied stored procedures, that are created with the SECURITY DEFINER option.|
|INSTALL SQL ID    |`INSSQLID`||
|INSTALL GRANTEE(S)|`INSGRLST`||
|INSTALL PKG OWNER |`INSPKOWN`||
|IVP SQL ID        |`IVPSQLID`||
|IVP PACKAGE OWNER |`IVPPKOWN`||
|IVP GRANTEE(S)    |`IVPGRLST`||
|SYSTEM ADMIN 2    |`PROTADM2`||
|SYSTEM ADMIN 1    |`PROTADMN`||
|SYSTEM OPERATOR 1 |`PROTOPR1`||
|SYSTEM OPERATOR 2 |`PROTOPR2`||
|SECURITY ADMIN 1  |`SECADMN1`||
|SECURITY ADMIN 2  |`SECADMN2`||
|PACKAGE OWNER     | `RTM05PKO`|The ID to own the package for the Db2-supplied SYSPROC.DSNAHVPM stored procedure.|

* Define RACF STARTED class profiles to all potential provisioned Db2 subsystem instances associating an ID to be used by each Db2 address space. 
* Define RACF DSNR class profiles to control access to any provisioned Db2 subsystem from another environment, such as CICS, IMS, TSO, RRS, BATCH, DDF and REST services.  
* Define RACF SERVER class profiles to control access to any provisioned Db2 subsystem because they will use stored procedures in a WLM-established address space.


### Storage adminstrator tasks
* Define SMS constructs, such as SMS classes and storage groups, for Db2 provisioning. The SMS storage groups can be per instance or shared by all potential provisioned Db2 instances.<br>The storage administrator can decide if image copy data sets and archive log data sets are to share the SMS storage groups with other Db2 data sets.
* Together with the security administrator, provide access authorization to all prefixes in the following table to the Db2 IDs, including the ID that executes the steps of the Db2 provisioning workflow. 
* Define ACS routines to be used to determine the SMS classes and storage groups for data sets allocation during a Db2 subsystem provisioning. 
* Define USERCATs and ALIASes, associating them to their specific SMS storage group.<br> **Important:** The provisioning process determines the  `ssid` value. You must do the definition work for all potential instances. If you are allowing 5 instances, then you must have 5 sets of definitions below corresponding to the 5 `ssid(s)` that can be generated. For example: DY00SYS, DY01SYS, an so on. 

|prefix|to be used for|
|----|----|
|a) `ssidSYS` |Db2 catalog, directory, and IVP data sets| 
|b) `ssidLOG` |Db2 BSDS, active logs, and archive logs data sets| 
|c) `ssidUSR` |Db2 User data| 
|d) `ssidCP1` |Db2 Image Copy data sets| 
|e) `HLQ` |Aliases for the SMP/E libraries and Db2 non-SMP/E data sets.<sup>*(1)*</sup>|

*(1)* The `HLQ` here will be concatenaded with the instantiated `ssid` and used as the prefix in all aliases and non SMP/E Db2 data sets. 

## Naming conventions for the sample Db2 software service template
The template uses the following naming conventions The naming conventions are very important for coordination of the IBM Cloud Provisioning and Management register between provision and deprovision processes.

|Named item|Name format and description|
|----|----|
|Db2 subsystem identifier – (ssid)|`ssid` - two characters provided when building the template plus a two-character sequential number. Throughout this information, ssid refers to this value.  <br>The template enforces that `ssid` is 4 characters. For example, if you specify `DY`, ssid is DY00.  <br>**Recommendation:** Start with “D” and another character to identify the set of Db2 subsystems. Do not use the letter “I” as the first character. |
|IRLM subsystem identifier| `Isid` - The template builds the name by replacing the first character of the provisioned Db2 subsystem by the letter “I.” For example: DY00 and IY00`|
|Db2 SMP/E TLIB data set|`HLQ.ssid.SDSN*`|
|IRLM SMP/E TLIB data set|`HLQ.ssid.SDXRRESL`|
|Db2, IRLM, and WLM address space startup procedures|`ssidMSTR`, `ssidDBM1`, `ssidDIST`, `ssidIRLM`, and `ssidWLMx`|
|Db2 command prefix|`-ssid`|
|Db2 location|`ssid`|
|Db2 IPNAME|`ssid`|
|Db2 ZPARM|`ssidZPRM`|
|Db2 BSDS|`ssidLOG.ssid.BSDSnn`|
|Db2 active Logs|`ssidLOG.ssid.LOGCOPYn.DSmm`|
|Db2 archive Logs|`ssidLOG.ssid.ARCLGn `|
|Db2 catalog and directory|`ssidSYS.* `|
|Db2 image copy template|`ssidCP1.&DB..&SN..&IC..D&JU..T&TI.`|
|Db2 flash copy template|`ssidCP1.&DB..&SN..N&DSNUM..&UQ.`|
|Db2 non-VSAM data sets|`HLQ.ssid.* `|
|Compression Dictionary Data Set (CDDS) prefix|`ssidSYS`|
|Db2 WLM application environments for supplied stored procedures – (*) |`ssidWLM_GENERAL`<br>`ssidWLM_PGM_CONTROL`<br>`ssidWLM_UTILS`<br>`ssidWLM_NUMTCB1`<br>`ssidWLM_XML`<br>`ssidWLM_JAVA`<br>`ssidWLM_REXX`<br>`ssidWLM_DEBUGGER`<br>`ssidWLM_DSNACICS `<br>`ssidWLM_MQSERIES `<br>`ssidWLM_WEBSERVICES`|
|Java runtime options (JAVAENVV, JVMPROPS)|`${DB2BASE}/classes/ssidenvfile.txt` and `${DB2BASE}/classes/ssidjvmsp`|
|Db2 program preparation and utilities invocation JCL procedures|`HLQ.ssid.PRIVATE.PROCLIB` - The template allocates a “private.proclib” data set, to add the Db2 program preparation and utilities invocation JCL procs per each provisioned Db2 subsystem|

## Specifying input properties

The `dsntivin` input variable file defines and describes more than 1200 input properties that define the Db2 subsystem. At provisioning time, values are set for about 200 of these variables based on the Db2 subsystem instance name being provisioned. The remaining variables are defined with default values from the sample template, or the values entered in the install CLIST panel. Review these values carefully before you publish the template.

If you are using the sample artifacts before building your own template, you must edit the `dsntivin` input variable file, and update it according to your installation as follows:  

1. In `Section 1: Variables to support provisioning instantiation`, you do not need to change anything, unless you want to use a COMMAND PREFIX (AGSSIDPX) to use other character than `–` (hyphen)

2. In `Section 2: Db2 function level`, no changes are required. The sample template is built on top of Db2 12 function level 502. 

3. You must update the values in each of the following sections for your environment in: 
  * `Section 3: Db2 install data sets prefix/HLQ` 
  * `Section 4: Db2 authorization IDs` 
  * `Section 5: Db2 product SMP/E target libraries` 
  * `Section 6: Db2 Java properties` 
  * `Section 7: Host language data sets`  
  * `Section 8: Other data sets` 

4. In `Section 9: Variables whose values will be generated at provisioning time`, do not change anything. The values of the variables in this section are built at provisioning time according to the subsystem instance name (`ssid`) being provisioned and the [naming convention](#naming-conventions) rules for provisioning. 

5. In `Section 10: Variables with default values for provisioning a typical Db2 configuration`, you do not need to change any of these variables if you want the recommended configuration. The following table lists variables that use different default values than are used by the Db2 installation CLIST. 

|Variable name (parameter name if different) |Db2 CLIST default|Template default|
|----|----|----|
|`ABIND`|`YES`|`COEXIST`|
|`ACCUMACC`|`10`|`NO`|
|`ADMTPROC`|`ssidADMT`|blank|
|`ARCHDEVT` (`UNIT`)|`TAPE`|`SYSDA`|
|`ARCHDEV2` (`UNIT2`)|blank (no value)|`SYSDA`|
|`ARCHTS` (`TSTAMP`)|`NO`|`YES`|
|`ASCSSID`|blank (no value)|`819`|
|`BP1`|`0`|`5000`|
|`BP2`|`0`|`5000`|
|`BP8K0`|`2000`|`5000`|
|`BP8K1`|`0`|`5000`|
|`BP16K0`|`500`|`5000`|
|`BP16K1`|`0`|`5000`|
|`BP16K2`|`0`|`5000`|
|`BP32K`|`250`|`5000`|
|`BP32K1`|`0`|`5000`|
|`BP32K2`|`0`|`5000`|
|`BSACP` (`ALTERNATE_CP`)|blank|`NO`|
|`CHKTYPE`|`MINUTES`|`SINGLE`|
|`CMPSPT01` (`COMPRES_SPT01`)|`NO`|`YES`|
|`CQAC` (`QUERY_ACCELERATION`)|`1`|`NONE`|
|`DDFSTART` (`DDF`)|`NO`|`AUTO`|
|`DEFCCSID`|blank (no value)|`37`|
|`EDMDBDC`|`23400`|`40960`|
|`EDMSKP` (`EDM_SKELETON_POOL`)|`51200`|`81920`|
|`EDMSTMTC`|`113386`|`122880`|
|`IDXBPOOL`|`BP0`|`BP2`|
|`LBACKOUT `|`AUTO`|`LIGHTAUTO`|
|`MNSU`(`MATERIALIZE_NODET_SQLTUDF`)|`YES`|`NO`|
|`MON`|`NO`|`YES`|
|`NUMCONBT` (`IDBACK`)|`50`|`200`|
|`NUMCONTS` (`IDFORE`)|`50`|`200`|
|`OPSMFSTA` (`SMFSTAT`)|`YES`|`*`|
|`OPNDS (DSMAX)`|`calculated value`|`20000`|
|`OPTHINTS`|`NO`|`YES`|
|`OPTRCSIZ` (`TRACTBL`)|`16`|`25`|
|`(OTC_LICENSE)`|blank (no value)|`NO`|
|`PARAMDEG`|`0`|`16`|
|`PALK` (`PREVENT_ALTERTB_LIMITKEY`)|`NO`|`YES`|
|`PFUP` (`PCTFREE_UPD`)|`0`|`AUTO`|
|`PCLOSEN `|`10`|`15`|
|`SMFCOMP`|`OFF`|`ON`|
|`SYNCVAL`|`NO`|`0`|
|`TBSBPOOL`|`BP0`|`BP1`|
|`TBSBP8K`|`BP8K0`|`BP8K1`|
|`TBSBP16K`|`BP16K0`|`BP16K1`|
|`TBSBP32K`|`BP32K0`|`BP32K1`|
|`TBSBPLOB`|`BP0`|`BP32K2`|
|`TBSBPXML`|`BP16K0`|`BP16K2`|
|`UTOC` (`UTILITY_OBJECT_CONVERSION`)|`NONE`|`EXTENDED`|
|`WFDBSEP`|`NO`|`YES`|

After your input properties file is updated with your installation values, you can create your own template under the z/OSMF Cloud Provisioning Software Services. 

## Preparing and publishing the Db2 software service template

1. In z/OSMF Cloud Provisioning Software Services, add a standard template. For general instructions for this process, see [Prepare and publish a template](https://www.ibm.com/support/knowledgecenter/SSLTBW_2.3.0/com.ibm.zosmfcore.softwareconfig.help.doc/izuSChpHowToProvisionSP.html) and [Add a template and resource pool](https://www.ibm.com/support/knowledgecenter/SSLTBW_2.3.0/com.ibm.zos.v2r3.izsc300/izuRPhpAddTemplateandResourcePool.htm).

    a. When you create the template, specify the following file names, where `<service-base-dir>` is the directory where you unpaxed the `Db2ProvisionSystemNonDS.pax` file: 
     - For the workflow file, specify: `<service-base-dir>/dsntiwin.xml` 
     - For the actions file, specify: `<service-base-dir>/actions.xml`
     - For the workflow variable input file, specify: `<service-base-dir>/dsntivin` 
     
    b. Associate the template with a tenant. When you associate the tenant, specify two leading characters for the subsystem name (`ssid`), and the number of instances to provision. For example, if you specify `DY` and you specify five instances, Db2 subsystems are provisioned with the following names for `ssid`: DY00, DY01, DY02, DY03, and DY04.
     
    c. Use the network configuration assistant to specify the port ranges to use for the provisioned Db2 subsystems. Two ports must be provided for each instance being provisioned, a DRDA and REST services  port, and a RESYNC port.
     
    d. Test the provisioning template and verify the provisioned Db2 subsystems.
    
    e. Publish the template to make it available to consumers. 
    
### Steps in the provisioning workflow (`dsntiwin.xml`)

When you execute the provisioning workflow, you are prompted to specify whether you want to execute the optional features.  

To provision a standalone Db2 subsystem, the sample template completes the following steps: 

1. Instantiates the Db2 subsystem ID (ssid) being provisioned 

2. Sets the variables (section 9 of DSNTIVIN) according to the name convention rules

3. Acquires Db2 ports from the NRP

4. Defines aliases for the Db2 SMP/E target libraries for the instantiated Db2 subsystem

5. Allocates private proclib for instantiated Db2 subsystem

6. Assigns IRLM SSID based on the instantiated Db2 subsystem name

7. Dynamically defines Db2 and IRLM subsystems to z/OS

8. Executes all mandatory steps to install and verify a standalone Db2 subsystem, including: Java definitions, all Db2-supplied stored procedures, SQL Install Verification, Db2 storage groups for user data (`ssidUSG`), and optionally DDF REST services, ODBC, and JDBC connections (Type-2 and Type-4)  
    
### Actions for the provisioned Db2 subsystems 

The following actions are available from z/OSMF Cloud Provisioning Software Services for the provisioned Db2 subsystem:
   * Start the Db2 subsystem   
   * Stop the Db2 subsystem 
   * Display DDF information 
   * Display group information
   * Enable the optional features (ODBC, JDBC, and REST services) 
   * Deprovision the Db2 subsystem

### Steps in the deprovision workflow (`dsndeprv.xml`)

The deprovision workflow removes all definitions and data sets related to the deprovisioned Db2 subsystem. To deprovision a Db2 subsystem, the sample template completes the following high-level actions: 

1. Issues a STOP DB2 command; this step will not fail the workflow execution if Db2 is already stopped 

2. Releases DRDA/REST services TCP/IP port 

3. Releases RESYNC TCP/IP port 

4. Deletes IVP and non-VSAM data sets   

5. Deletes JAVAENV data set and the Java environment files 

6. Deletes Image Copy data sets 

7. Deletes Db2 catalog, directory, BSDS, active & archive log data sets, Db2 user data sets 

8. Deletes Db2 start up and WLMENV procedures 

9. Deletes the Db2 ZPARM module 

10. Deletes WLM application environments 

11. Deletes aliases defined against Db2 and IRLM SMP/E target libraries 

12. Deletes Db2 and IRLM subsystem definitions from z/OSMF
    
## Security considerations for the sample Db2 software service template

The “workflow executor” of the provisioning service must have RACF authority to execute the service, and must also have the following authority: 
* Authority to allocate data sets with the HLQ assigned to that Db2 instance, as well as USS files 
* Read/write authority for the system PROCLIB and WLM application environment definition  
* Authority to generate RACF PassTickets to others executing steps where a password would be required  

Db2 itself requires specific authorities when executing some of the installation and provisioning steps, and some workflow steps are executed under user IDs other than the workflow executor, by using the runAsUser ID. For details, see the tables in [Authorizations for workflows](#authorizations-for-workflows). 

Also, the enablement steps for the optional features have special requirements.   

### Using RACF PassTickets for optional features
The JDBC enablement optional feature requires connection to the provisioned Db2 subsystem to perform the BIND for the JDBC packages as well as to verify a remote connection (JCC-Type-4). 

When connecting, a user ID and password must be passed to the connection statement. Instead of sending clear text passwords, the sample template uses generated RACF PassTickets.  Users of the application can then use the PassTickets to authenticate within a RACF-secured network. This procedure prevents the need to store password credentials within the z/OSMF environment. 

You must certify that the ID used to execute the workflows has the RACF authority to generate PassTickets to others. 

To enable the usage of RACF PassTicket by the sample template, take the following actions: 

1. Activate the RACF PassTicket class, by issuing the following commands: 
```
SETROPTS CLASSACT(PTKTDATA) RACLIST(PTKTDATA) SETROPTS GENERIC(PTKTDATA)
```

2. Define RACF profiles for the application in PTKTDATA, by issuing the following commands:
```
RDEFINE PTKTDATA <applName> SSIGNON(KEYMASKED(<key>)) 
APPLDATA('NO REPLAY PROTECTION')
```
In the preceding example: 
`<applName>` is the name of the application that requests and uses the PassTickets. Provisioned Db2 subsystems accept TCP/IP connections only, therefore we should use the value of the the IPNAME as  `<applName>`.  


`<key>` is a session key with the value of 16 hexadecimal digits (for an 8-byte or 64-bit key). The session key must be identical to the key in the PassTicket definition in each RACF instance. The key for each application must be the same on all subsystems in the configuration. 


`APPLDATA('NO REPLAY PROTECTION')` is the option that you can use to permit reuse of the same PassTicket multiple times. 

The following example shows these commands for provisioning five Db2 subsystems. As described in the [Naming Convention](#naming-convention) section, the name of the subsystem being provisioned (`ssid`) is used for the IPNAME value. Because we expect five instances to be provisioned, you can activate them all in one single job, considering that they will be all under the same RACF database.

```
//STEP01 EXEC PGM=IKJEFT01                     
//SYSTSPRT DD SYSOUT=*                         
//SYSTSIN DD *                                 
  RDEL PTKTDATA (DY00)                         
  RDEL PTKTDATA (DY01)                         
  RDEL PTKTDATA (DY02)                         
  RDEL PTKTDATA (DY03)                         
  RDEL PTKTDATA (DY04)                         
  RDEL PTKTDATA (IRRPTAUTH.DY*.*)              
  RDEF PTKTDATA DY00 -                         
   SSIGNON(KEYMASKED(E001193519561977)) -       
   UACC(NONE) APPLDATA('NO REPLAY PROTECTION')  
  RDEF PTKTDATA DY01 -                         
   SSIGNON(KEYMASKED(E001193519561977)) -       
   UACC(NONE) APPLDATA('NO REPLAY PROTECTION')  
  RDEF PTKTDATA DY02 -                         
   SSIGNON(KEYMASKED(E001193519561977)) -       
   UACC(NONE) APPLDATA('NO REPLAY PROTECTION')  
  RDEF PTKTDATA DY03 -                                             
   SSIGNON(KEYMASKED(E001193519561977)) -                           
   UACC(NONE) APPLDATA('NO REPLAY PROTECTION')                      
  RDEF PTKTDATA DY04 -                                             
   SSIGNON(KEYMASKED(E001193519561977)) -                           
   UACC(NONE) APPLDATA('NO REPLAY PROTECTION')                      
  RDEFINE PTKTDATA IRRPTAUTH.DY*.*                                 
  PERMIT IRRPTAUTH.DY*.* CLASS(PTKTDATA) ID(WFexecutorID) ACCESS(UPDATE)  
  SETROPTS RACLIST(PTKTDATA) REFRESH 
```
### Authorizations for the sample Db2 software service template workflows
The following tables show the authorizations required for certain steps of the sample template. All other steps run under the authorization ID that executes the workflow. You can specify the authorization ID that executes the workflow in the AGEXECID variable in section 4 of the DSNTIVIN input variable file. If the AGEXECID value is blank, the sign-on ID executes the steps.    

#### Authorizations for the provisioning workflow (`dsntiwin.xml`)

|Step name|Job name|Run as user|Job description|RACF authorization|
|----|----|----|----|----|
|s00DEFSS|`DSNTIJMD`|SYSADM1/${PROTADMN}|Defines Db2 and IRLM to z/OS by SETSSI|A console that has master authority, or a console operator with sufficient RACF authorization.|
|step15|`DSNTIJTC`|SYSADM1/${PROTADMN}|CATMAINT |For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|step16|`DSNTIJTM`|SYSADM1 /${PROTADMN}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|step17|`DSNTIJSG`|SYSADM1/${PROTADMN}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|step20b|`DSNTIJRT`|${AUTHID}||Db2 authorization: DSNTRIN accepts two auth parms <br>(1) AUTHID ... the authorization ID to use to create most objects specified in ROUTINES CREATOR field of DSNTIPG <br>(2) SECDEFID ... the authorization ID to use to create routines that require SECURITY DEFINER, specified in SEC DEF CREATOR field of DSNTIPG. The user ID needs to be able to SET CURRENT SQLID to these secondary IDs |
|step20c|`DSNTIJRV`|${AUTHID}||RACF auth: <br>  - If CLASS(FACILITY) is active and the profile MVSADMIN.WLM.POLICY exists then the user ID needs READ access to the profile. <br> - If CLASS(OPERCMDS) is active and the profile MVS.MCSOPER.* exists then the user ID needs READ access to the profile. <br> For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.<br> - AUTHID ... used as the CURRENT SQLID when issuing SQL statements and as the owner of the package and plan for program DSNTRVFY. Specified in ROUTINES CREATOR field of DSNTIPG.|
|step22b|`DSNTEJ1`|${IVPSQLID}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority. IVPSQLID is specified in the IVP SQL ID field of DSNTIPG.|
|step22c|`DSNTEJ1L`|${IVPSQLID}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority. IVPSQLID is specified in the IVP SQL ID field of DSNTIPG.|
|step22d|`DSNTEJ2A`|${IVPSQLID}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority. IVPSQLID is specified in the IVP SQL ID field of DSNTIPG.|
|stepJTU|`DSNTIJTU`|${INSSQLID}|Creates and grants usage on STOGROUP for user data TO ${INSGRLST}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority. INSGRLST is specified in the INSTALL GRANTEE(S) field of DSNTIPG.|

#### Authorizations for the START DB2 action (`dsnstart.xml`)

|Step name|Job name|Run as user|Job description|RACF authorization|
|----|----|----|----|----|
|stepJMD|`DSNTIJMD`|SYSADM1/${PROTADMN}|Defines Db2 & IRLM to z/OS by SETSSI|A console that has master authority, or a console operator with sufficient RACF authorization.|
|stepJSA|`DSNTIJSA`|SYSADM1/${PROTADMN}||RACF authorization: If CLASS(OPERCMDS) is active and the profile MVS.MCSOPER.* exists then the user ID needs READ access to the profile. <br>Db2 Authorization: None.  However, the command can be executed only from a z/OS console with the START command capability.|


#### Authorizations for the STOP DB2 action (`dsnstop.xml`)

|Step name|Job name|Run as user|Job description|RACF authorization|
|----|----|----|----|----|
|stepJSO|`DSNTIJSO`|SYSADM1/${PROTADMN}||Db2 Authorization: The user ID must use a privilege set of the process that includes one of the following privileges or authorities: <br>STOPALL privilege <br>SYSOPR authority <br>SYSCTRL authority <br>SYSADM authority <br>Db2 commands that are issued from a logged-on z/OS console or TSO SDSF can be checked by Db2 authorization using primary and secondary authorization IDs.|


#### Authorizations for the deprovisioning workflow (`dsndeprv.xml`)

|Step name|Job name|Run as user|Job description|RACF authorization|
|----|----|----|----|----|
|stepJSO|`DSNTIJSO`|SYSADM1/${PROTADMN}||Db2 Authorization: The user ID must use a privilege set of the process that includes one of the following privileges or authorities: <br>STOPALL privilege <br>SYSOPR authority <br>SYSCTRL authority <br>SYSADM authority <br>Db2 commands that are issued from a logged-on z/OS console or TSO SDSF can be checked by Db2 authorization using primary and secondary authorization IDs.|
|stepDJMD|`DSNTDJMD`|SYSADM1/${PROTADMN}||A console that has master authority, or a console operator with sufficient RACF authorization.|


#### Authorizations for the optional features enablement action (`dsnopent.xml`)

|Step name|Job name|Run as user|Job description|RACF authorization|
|----|----|----|----|----|
|stepJRP|`DSNTIJRP`|SYSADM1/${PROTADMN}|Enables Db2 REST services|For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|stepODBCBIND|`DSNTIJCL`|SYSADM1/${PROTADMN}|Bind and grants usage of PKG/PLAN TO ${INSGRLST}|For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|stepODBCVerify|`DSNTEJ8`|SYSADM1/${PROTADMN}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|stepJDBCBIND|Shell-JCL inline|Workflow executor|Uses DB2Binder utility, which binds the Db2 packages that are used at the data server by the IBM Data Server Driver for JDBC and SQLJ into the NULLID collection, and grants EXECUTE authority on the packages to PUBLIC.|1) The workflow executor ID MUST have RACF privilege to generate PassTickets for others <br> 2) The BIND will be performed under SYSADM1/${JCCSID} ID, using a generated PASSTICKET instead of sending clear text passwords to connect to the Db2 subsystem. <br>See more details in [Using RACF PassTickets for optional features](#using-racf-passtickets-for-optional-features)|
|stepJDBCVerifyT2|Shell-JCL inline|Workflow executor|Performs local connection (JCC Type-2) to the provisioned Db2 subsystem and perform SQL queries against the Db2 sample database. Records the output into /tmp/db2-ssid-tej91t2 ||
|stepJDBCVerifyT4|Shell-JCL inline|Workflow executor|Performs remote connection (JCC Type-4) to the provisioned Db2 subsystem and perform SQL queries against the Db2 sample database. Records the output into `/tmp/db2-ssid-tej91t4`|The connection and verification is performed under SYSADM1/${PROTADMN} ID, using a generated PASSTICKET instead of sending clear text passwords to connect to the Db2 subsystem. <br> See more details in [Using RACF PassTickets for optional features](#using-racf-passtickets-for-optional-features)|


