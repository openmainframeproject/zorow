# Creating Db2 for z/OS data sharing group provisioning services

With the Db2 data sharing software services template, you can create services that rapidly provision from scratch one or multiple Db2 data sharing groups, in IBM Cloud Provisioning and Management for z/OS. For information about cloud provisioning, including a description of the roles involved, see [Cloud provisioning services](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.1.0/com.ibm.zos.v2r1.izua700/izuprog_CloudProvisioning.htm#CloudProvisioningServices). 

The sample Db2 data sharing software service template is built on top of z/OSMF cloud provisioning service infrastructure. For more information about how to load and use the service in z/OSMF, see [Software Services task overview](https://www.ibm.com/support/knowledgecenter/SSLTBW_2.3.0/com.ibm.zos.v2r3.izua300/IZUHPINFO_OverviewSoftwareServices.htm). 

The sample Db2 data sharing software service template uses a z/OSMF *composite template*, which uses a single workflow definition file that contains all steps required to run multiple sequences. It runs sequence 1 to  install the originating data sharing member and then repeats sequence 2 as necessary to install the specified number of additional data sharing members software instances to add to the cluster. 

The sample Db2 data sharing software service template exploits the Network Resource Pool under the z/OSMF Cloud Provisioning Resource Management. For more information, see [Resource authorizations for the Configuration Assistant plug-in](https://www.ibm.com/support/knowledgecenter/SSLTBW_2.3.0/com.ibm.zos.v2r3.izua300/izuconfig_SecurityStructuresForZosmf.htm?view=kc#DefaultSecuritySetupForZosmf__SecuritySetupRequirementsForConfPlugin). For a tutorial that walks you through the steps that are needed, see [Getting Started Tutorial – Cloud.](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.tcp.ipsec.ipsec.help.doc/com/ibm/tcp/ipsec/cloud/GettingStartedWithCloud.html)  

This readme is intended for the service provider, who configures and makes the Db2 data sharing group provisioning service available to consumers in your shop.

## About the sample Db2 data sharing software service template

You can use the sample Db2 software service template, to build your own Db2 software service template to provision multiple Db2 12 for z/OS data sharing group instances in a “typical Db2 configuration” with the following attributes:
*  The data sharing group name, group attach name, member names (Db2 subsystems), and all other names are based on the cluster prefix character that you specify when building the template, according to the rules described in the [naming convention](#naming-conventions-for-the-sample-db2-data-sharing-software-service-template). Throughout this information, all examples assume that  `Z` is specified for the cluster prefix character.
* Accepts only TCP/IP connections.
* Subsystem parameter (zPARMS) settings, as recommended by the latest best practices.
* Three dual sets of active logs, and dual archive logs with timestamp.
* Images copies to DASD only.
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

You can also use the sample Db2 software service template for actions against the provisioned data sharing group, and later to deprovision the provisioned Db2 data sharing groups. 

## Setting up the sample Db2 software service template

The files of the service are stored in a directory in z/OS UNIX System Services (USS), and the directory and files must be accessible to z/OSMF. All required files are compressed into the `Db2ProvisionSystemDS.pax` file.

1. Download the `Db2ProvisionSystemDS.pax` file.
2. Use FTP in binary mode to upload the `Db2ProvisionSystemDS.pax` file to the directory where you want to store the service in USS. The maximum length for the directory name is 40 characters. 
3. Extract the file into the directory of your choice, for example: 
    
    ```
    pax -rvf Db2ProvisionSystemDS.pax
    ```

    Inside the directory that you specified, the extracted directory `<service-base-dir>` has the following structure:

    |File|Description| 
    |----|-----------|
    |`dsntiwpc.xml`, `dsnopent.xml`| Workflows to provision a Db2 data sharing group and enable optional features (Db2 REST services, ODBC, JDBC)|
    |`actions.xml`|A workflow for actions of the service|
    |`dsndeprc.xml`|A workflow to deprovision the Db2 data sharing group|
    |`dsnstart.xml`|A workflow for starting specific Db2 data sharing members|
    |`dsnstop.xml`|A workflow for stopping specific Db2 data sharing members|
    |`dsndddf.xml`|A workflow for displaying DDF details for the Db2 data sharing group|
    |`dsndgrpd.xml`|A workflow for displaying details of the Db2 data sharing group|
    |`dsnoptft.xml`, `dsnopent.xml`|Workflows for enabling optional features (Db2 REST services, ODBC, JDBC)|
    |`dsntivin`|The input property file for the originating member|
    |`dsntivia`|The input property file for additional members|
    |`dsnti*`|Several JCL templates used by the `dsntiwpc.xml`, `dsnopent.xml`, `dsnstart.xml`, `dsnstop.xml`, `dsnddf.xml`, `dsndgrpd.xml`, and `dsndeprc.xml` workflows|
    |`dsnta*`|Several JCL templates used by the `dsntiwpc.xml` workflow, specific to additional members|
    |`dsnte*`|Several JCL templates used by the `dsntiwpc.xml` and `dsnopent.xml` workflows|
    |`dsntd*`|Several JCL templates used by `dsndeprc.xml` workflow|
    |`dsntx*`|Several JCL templates used by `dsndeprc.xml` workflow, specific to additional members|


In addition, copy `db2provision.jar` in binary into your installation's DB2BASE/classes directory. This jar file is installed by default in the directory specified by the DDDEF created for SDSNACLS. 


## Preparing the environment for the Db2 software service template

Before building your own template based on the sample, verify with the following adminstrators that their prerequisite tasks are complete:

### Cloud provisioning administrator tasks
* Enable Cloud Provisioning Software Services in the z/OSMF server, certifying that the `domain` to be used has enough systems (LPARs) for the number of members in the data sharing group. IBM Cloud Provisioning and Management currently does not support more than one member of the same data sharing group in the same LPAR.
* Enable a network resource pool (NRP) in the z/OSMF server, with sufficient dynamic virtual IP address (DVIPA) and port allocation ranges for the number of instances provisioned. For example, a two-way data sharing group requires 3 DVIPAs and 3 ports. That is, each `n`-way data sharing group requires the following network resources:
   -  `n + 1` DVIPAs: one distributed dynamic virtual IP address (DDVIPA) for the group and one specific DVIPA for each member.
   - `n + 1` TCP/IP ports: one TCP/IP port for the group and one specific RESYNCH port for each member.


### System programmer tasks
* Provide the SMP/E Db2 product target libraries, with the the following Db2 12 APARs applied: PH09857; and if Db2 REST services will be enabled on the provisioned Db2 subsystems, APARs PI70652 and PI96649.  
* Certify that the SMP/E Db2 product target libraries for SDSNEXIT, SDSNLINK, SDSNLOAD, SDSNLOD2 and IRLM RESLIB are APF-authorized <br>**Note:** SDSNLOD2 is a PDSE data set, which contains JDBC and SQLJ DLLs. Although DB2 does not require that SDSNLOD2 be APF-authorized, be aware that if this data set is in a STEPLIB data set concatenation of an address space that does need APF authorization, SDSNLOD2 must also be APF-authorized. The provisioning template concatenates SDSNLOD2 when verifying JDBC local connection (Type-2) in Optional Features.
* Provide data set names, including for host languages (see `Section 7: Host language data sets`, in the `dsntivin` and `dsntivia` files.) 
* Verify installation, and provide directories where indicated, for the following installed FMIDs: 
    - **JDBCC12** for Db2 JDBC/SQLJ. All variables must be set in `Section 6: Db2 Java properties`,  in the `dstnivin` file. 
    - **JDBCC17** for Db2 ODBC. The following variables must be set in `Section 7: Host language data sets`,  in the `dstnivin` file: CCOMP, CPPAUTCL, LELKED, LEPLMSGL, and LERUN.
    - **HDDA211** for z/OS Application Connectivity.
    - **HDBCC1K** for Db2 Utilities Suite for z/OS.
* Define sufficient coupling facility (CF) structures for all possible provisioned data sharing group instances, following the [naming conventions](#naming-conventions) and the sizing for a medium configuration, as described in [Coupling facility structure size allocation](https://www.ibm.com/support/knowledgecenter/SSEPEK_12.0.0/inst/src/tpc/db2z_cfstructuresizeallocation.html).
    
### Network administrator tasks
* Provide a range of DVIPAs and TCP/IP ports to be used under the Network Resource Pool (NRP).

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
* Define USERCATs and ALIASes, associating them to their specific SMS storage group.<br> **Important:** The provisioning process determines the  `groupname` value. You must do the definition work for all potential instances. If you are allowing 2 instances of a data sharing group, then you must have 2 sets of definitions below, corresponding to the 2 `groupname(s)` that can be generated. For example: DSNZ0SYS, DSNZ1SYS, an so on. 

|Aliases(prefixes)|to be used for|
|----|----|
|a) `groupnameSYS` |Db2 catalog, directory, and IVP data sets| 
|b) `groupnameLOG` |Db2 BSDS, active logs, and archive logs data sets| 
|c) `groupnameUSR` |Db2 User data| 
|d) `groupnameCP1` |Db2 Image Copy data sets| 
|e) `groupname` |Aliases for the SMP/E libraries and Db2 non-SMP/E data sets.<sup>*(1)*</sup>|

*(1)* The `groupname` here precedes the following names:
- The instantiated member name, as the prefix in all aliases. For example: `DSNZ0.DZ00.*`, where `DSNZ0` is the groupname, and `DZ00` is the instantiated member name.
- The group attach name, as the prefix for IVP data sets, which are allocated only when provisioning the originating member. For example `DSNZ0.DZ0G.*`, where `DSNZ0` is the groupname, and `DZ0G` is the group attach name.


## Naming conventions for the sample Db2 data sharing software service template
The template uses the following naming conventions The naming conventions are very important for coordination of the IBM Cloud Provisioning and Management register between provision and deprovision processes. Throughout this information, all examples assume that  `Z` is specified for the cluster prefix character.

In the table following characters have these meanings:
- `c`= Cluster instance name prefix
- `n`= cluster instance number – 0-n 
- `m`= SW instance number – 0-m

|Named item            |Format   |Example (originating)|Example (additional)
|----                  |----      |----|----|
|Group name            |`DSNcn`   |DSNZ0              |DSNZ1
|Group attach name     |`DcnG`    |DZ0G               |DZ1G
|Subsystem name & member name |`Dcnm` |DZ00, DZ01     |DZ10, DZ11
|IRLM SS name          |`Icnm`    |IZ00, IZ01         |IZ10, IZ11
|IRLM XES Group name   |`DXRcn`   |DXRZ0              |DXRZ1      
|Subsystem load module |`DcnmZPRM`|DZ00ZPRM, DZ01ZPRM |DZ10ZPRM, DZ11ZPRM
|Subsystem DECP        |`DcnGDECP`|DZ0GDECP           |DZ1GDECP
|Location              |`DSNcn`   |DSNZ0              |DSNZ1 
|IPname                |`DSNcn`   |DSNZ0              |DSNZ1 
|**Start up procedures**|See the following five rows|
|-ssnmMSTR|`DcnmMSTR`|DZ00MSTR, DZ01MSTR |DZ10MSTR, DZ11MSTR  
|-ssnmDBM1|`DcnmDBM1`|DZ00DBM1, DZ01DBM1 |DZ10DBM1, DZ11DBM1
|-ssnmDIST|`DcnmDIST`|DZ00DIST, DZ01DIST |DZ10DIST, DZ11DIST  
|-ssnmIRLM|`DcnmIRLM`|DZ00IRLM, DZ01IRLM |DZ10IRLM, DZ11IRLM
|-groupattachWLM*|`DcnGWLM*`|DZ0GWLM*           |DZ1GWLM*
|**WLMENV Db2 supplied SPs**|See the following row|
|-groupattachWLM_*|`DcnGWLM_*`|DZ0GWLM_*  |DZ1GWLM_*
|**XCF Structures** |See the following three rows|
|-groupname_LOCK1      |`DSNcn_LOCK1`    |DSNZ0_LOCK1            |DSNZ1_LOCK1
|-groupname_SCA        |`DSNcn_SCA`  |DSNZ0_SCA            |DSNZ1_SCA
|-groupname_GBPxx       |`DSNcn_GBPxx`  |DSNZ0_GBPx <br/>(GBP0, GBP1, GBP2, <br/>GBP8K0, GBP8K1, <br/>GBP16K0, GBP16K1, GBP16K2, <br/>GBP32K, GBP32K1, GBP32K2)  |DSNZ1_GBPx
|Catalog & Directory   |`DSNcnSYS`|DSNZ0SYS.* |DSNZ1SYS.*
|BSDS              |`DSNcnLOG.Dcnm.BSDS01`|DSNZ0LOG.DZ00.BSDS01/BSDS02<br/>DSNZ0LOG.DZ01.BSDS01/BSDS02	|DSNZ1LOG.DZ10.BSDS01/BSDS02<br/>DSNZ1LOG.DZ11.BSDS01/BSDS02
|Active Logs       |`DSNcnLOG.Dcnm.LOGCOPY1.DS01`|DSNZ0LOG.DZ00.LOGCOPY1.DS01/DS02/DS03<br/>DSNZ0LOG.DZ00.LOGCOPY2.DS01/DS02/DS03<br/>DSNZ0LOG.DZ01.LOGCOPY1.DS01/DS02/DS03<br/>DSNZ0LOG.DZ01.LOGCOPY2.DS01/DS02/DS03|DSNZ1LOG.DZ10.LOGCOPY1.DS01/DS02/DS03<br/>DSNZ1LOG.DZ10.LOGCOPY2.DS01/DS02/DS03<br/>DSNZ1LOG.DZ11.LOGCOPY1.DS01/DS02/DS03<br/>DSNZ1LOG.DZ11.LOGCOPY2.DS01/DS02/DS03
|Archive Logs      |`DSNcnLOG.Dcnm.ARCH1.Dyyddd.Thhmmsst.Axxxxxxx`|DSNZ0LOG.DZ00.ARCH1.Dyyddd.Thhmmsst.Axxxxxxx<br/>DSNZ0LOG.DZ00.ARCH2.Dyyddd.Thhmmsst.Axxxxxxx<br/>DSNZ0LOG.DZ01.ARCH1.Dyyddd.Thhmmsst.Axxxxxxx<br/>DSNZ0LOG.DZ01.ARCH2.Dyyddd.Thhmmsst.Axxxxxxx|DSNZ1LOG.DZ10.ARCH1.Dyyddd.Thhmmsst.Axxxxxxx<br/>DSNZ1LOG.DZ10.ARCH2.Dyyddd.Thhmmsst.Axxxxxxx<br/>DSNZ1LOG.DZ11.ARCH1.Dyyddd.Thhmmsst.Axxxxxxx<br/>DSNZ1LOG.DZ11.ARCH2.Dyyddd.Thhmmsst.Axxxxxxx  
|Image Copy  |`DSNcnCP1.&DB..&SN..&IC.&JU..&UQ.`|DSNZ0CP1.&DB..&SN..&IC.&JU..&UQ.|DSNZ1CP1.&DB..&SN..&IC.&JU..8UQ. 
|Flash Copy  |`DSNcnCP1.&DB..&SN..N&DSNUM..&UQ.`|DSNZ0CP1.&DB..&SN..N&DSNUM..&UQ.|DSNZ1CP1.&DB..&SN..N&DSNUM..&UQ.
|non-VSAM data sets and Db2 SMP/E TLIBs aliases |	`DSNcn.Dcnm.*`|	DSNZ0.DZ00.*, DSNZ0.DZ01.* |DSNZ1.DZ10.*, DSNZ1.DZ11.*
|User data  |`DSNcnUSR` |DSNZ0USR.* |DSNZ1USR.*
|Java runtime options  |`DSNcn.DcnGWLMJ.JAVAENV`|DSNZ0.DZ0GWLMJ.JAVAENV|DSNZ1.DZ1GWLMJ.JAVAENV
|Java environment files  |`dcngenvfile.txt` and `dcngjvmsp`|dz0genvfile.txt and  dz0gjvmsp|dz1genvfile.txt and  dz1gjvmsp|
|Db2 program preparation and utilities invocation JCL procs|`DSNcn. DcnG.PRIVATE.PROCLIB`|DSNZ0.DZ0G.PRIVATE.PROCLIB|DSNZ1.DZ1G.PRIVATE.PROCLIB||
|Additional Db2 libraries created during provisioning|`DSNcn.DcnG.${AGNEWIDS}.SDSNCLST`<br/>`DSNcn.DcnG.RUNLIB.LOAD`<br/>`DSNcn.DcnG.SRCLIB.DATA`<br/>`DSNcn.DcnG.DBRMLIB.DATA`|DSNZ0.DZ0G.NEW.SDSNCLST<br/>DSNZ0.DZ0G.RUNLIB.LOAD<br/>DSNZ0.DZ0G.SRCLIB.DATA<br/>DSNZ0.DZ0G.DBRMLIB.DATA|DSNZ1.DZ1G.NEW.SDSNCLST<br/>DSNZ1.DZ1G.RUNLIB.LOAD<br/>DSNZ1.DZ1G.SRCLIB.DATA<br/>DSNZ1.DZ1G.DBRMLIB.DATA|

## Specifying input properties

The `dsntivin` and `dsntivia` input variable files define and describe many input properties that define the Db2 data sharing group and its members. At provisioning time, values are set for many of these variables based on the data sharing group and Db2 data sharing instance names being provisioned. The remaining variables are defined with default values from the sample template. Review these values carefully before you publish the template.

If you are using the sample artifacts before building your own template, you must edit the `dsntivin` and `dsntivia` input variable files, and update them according to your installation as follows:  

1. In `Section 1: Variables to support provisioning instantiation`, you do not need to change anything, unless you want to use a COMMAND PREFIX (AGSSIDPX) to use other character than `–` (hyphen)

2. In The following sections, no changes are required. The sample template is built on top of Db2 12 function level 504. 
  * `Section 2: Db2 function level`
  * `Section 3: Db2 install data sets prefix/HLQ` 

3. You must update the values in each of the following sections for your environment in: 

  * `Section 4: Db2 authorization IDs` 
  * `Section 5: Db2 product SMP/E target libraries` 
  * `Section 6: Db2 Java properties` 
  * `Section 7: Host language data sets`  
  * `Section 8: Other data sets` 

4. In `Section 9: Variables whose values will be generated at provisioning time`, do not change anything. The values of the variables in this section are built at provisioning time according to the data sharing group name ('groupname') and subsystem instance (`ssid`) being provisioned, and the [naming convention](#naming-conventions) rules for provisioning. 

5. In `Section 10: Variables with default values for provisioning a typical Db2 configuration`, you do not need to change any of these variables if you want the recommended configuration. The following table lists variables that use different default values than are used by the Db2 installation CLIST. 

|Variable name (parameter name if different) |Db2 CLIST default|Template default|
|----|----|----|
|`ABIND`|`YES`|`COEXIST`|
|`ACCUMACC`|`10`|`NO`|
|`ADMTPROC`|`ssidADMT`|blank|
|`ARCHDEVT` (`UNIT`)|`TAPE`|`SYSDA`|
|`ARCHDEV2` (`UNIT2`)|blank (no value)|`SYSDA`|
|`ARCHTS` (`TSTAMP`)|`NO`|`YES`|
|`ASCCSID`|blank (no value)|`819`|
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
|`DDSTART` (`DDF`)|`NO`|`AUTO`|
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

## Preparing and publishing the Db2 data sharing software service template

For general instructions adding standard templates in z/OSMF Cloud Provisioning Software Services, see [Prepare and publish a template](https://www.ibm.com/support/knowledgecenter/SSLTBW_2.3.0/com.ibm.zosmfcore.softwareconfig.help.doc/izuSChpHowToProvisionSP.html) and [Add a template and resource pool](https://www.ibm.com/support/knowledgecenter/SSLTBW_2.3.0/com.ibm.zos.v2r3.izsc300/izuRPhpAddTemplateandResourcePool.htm)

1. Add a standard template for the originating Db2 data sharing member, and specify the following file names, where `<service-base-dir>` is the directory where you unpaxed the `Db2ProvisionSystemDS.pax` file: 
     - For the workflow file, specify: `<service-base-dir>/dsntiwpc.xml` 
     - For the actions file, specify: `<service-base-dir>/actions.xml`
     - For the workflow variable input file, specify: `<service-base-dir>/dsntivin` 

2. Add a standard template for adding Db2 data sharing members, and specify the following file names, where `<service-base-dir>` is the directory where you unpaxed the `Db2ProvisionSystemDS.pax` file: 
     - For the workflow file, specify: `<service-base-dir>/dsntiwpc.xml` 
     - For the actions file, specify: `<service-base-dir>/actions.xml`
     - For the workflow variable input file, specify: `<service-base-dir>/dsntivia` 

3. Approve and publish the templates for the orignating and additional members.

4. Add a composite template for the data sharing group. 
    
    a. Add the **originating member** Published Template and specify 1 clustered instances to create from this template

    b. Add the **adding member** Published Template and specify `n` clustered instances, where `n` is the number of additional members to add to the data sharing group. <br/>When adding the **adding member** template, you are prompted to a set of variables. Do the following:
    
    - In the Variables table, select variable `AGFMRIN`, and select the **originating member** template as the **Source Template**. Then click **Add** to add `AGFMRIN` as a connector variable.
    - In the Connector Variables table select `registry-instance-name` as **Source Variable Name** for `AGFMRIN`. 

5. Associate the template with a tenant. When you associate the tenant, specify two leading characters where subsystem name prefix must be D, and the cluster instance name prefix is any character of your choice.
     
6. Use the network configuration assistant to specify the DVIPA and port ranges to use for the provisioned Db2 data sharing groups and members.      
7. Test the provisioning template and verify the provisioned Db2 data sharing groups, including the available actions, deprovisioning, and re-provisioning.
    
8. Publish the template to make it available to consumers. 
    
### Steps in the provisioning workflow (`dsntiwpc.xml`)

The following table indicates the steps that are excuted by the provisioning workflow for the originating member and for additional members of the data sharing group.

|Originating member| Additional members | Action 
|----              |----                |----
|No                |Yes                 |Obtain registryID of a DSG originating member (REST API)
|No	               |Yes                 |Update IRLMISEQ in registry of DSG originating member (REST API and inline shell-JCL)
|Yes               |Yes                 |Instantiate and validate Db2 SSID (DSNTRSSN)
|Yes               |Yes                 |Set variables for provisioning (Instructions only - setVariable)
|Yes               |Yes                 |Acquire Db2 DVIPAs and ports from Network Resource Pool - NRP
|Yes               |No                  |Allocate private proclib for instantiated Db2 system (DSNTIJPP)
|Yes               |Yes                 |Define aliases for the instantiated Db2 system (DSNTIJDA)
|Yes               |Yes                 |Assign IRLM SSID based on the instantiated Db2 system (Inline shell-JCL)
|Yes               |Yes                 |Define instantiated Db2 and IRLM systems to z/OS (DSNTIJMD)
|Yes               |No                  |Execute all mandatory steps to install the originating Db2 data sharing member, including creation of a storage group for user data, Java definitions, installation & verification of all Db2-supplied stored procedures, and run SQL install verification programs
|No                |Yes                 |Execute all mandatory steps to install additional Db2 data sharing members
|Yes              |Yes                  |Perform enablement of the optional features (REST services, ODBC, JDBC). Each optional feature can be invoked only one time in a data sharing group.

    
### Actions for the provisioned Db2 subsystems 

The following actions are available from z/OSMF Cloud Provisioning Software Services for the provisioned Db2 data sharing group:

#### At the Db2 subsystem (Db2 data sharing member level):
   * START DB2 - Start the Db2 subsystem, including the SETSSI ADD command in an IPL)  
   * STOP DB2 - normal stop of the Db2 system
   * DISPLAY DDF - display DDF information to the UI
   * DISPLAY GROUP - display data sharing group information to the UI
   * Enable optional features - (ODBC, JDBC, and REST services) 


#### At the cluster intance level (Db2 data sharing group level):
   * Deprovision the Db2 data sharing group - completley remove the provisioned Db2 data sharing system definitions including CF resources and all data sets in reverse order of provisioing, beginning with additional members followed by the originating member.


### Steps in the deprovision workflow (`dsndeprc.xml`)

The deprovision workflow removes all definitions and data sets related to the deprovisioned Db2 data sharing group. To deprovision a data sharing group, the sample template completes the following high-level actions: 

|Additional members|Originating member|Action
|----              |----              |---- 
|Yes               |Yes               |Stop Db2 system (DSNTIJSC)
|Yes               |Yes               |Release Db2 DVIPAs and ports back to Network Resource Pool – NRP (Rest)
|No                |Yes               |Delete IVP and non-VSAM install data sets (DSNTDJ1)
|No                |Yes               |Delete environment files for the Db2-supplied Java WLM environment (DSNTDJMJ)
|No                |Yes               |Delete Db2 image copy data sets (DSNTDJIC)
|No                |Yes               |Delete Db2 catalog, directory, BSDS, active and archive log data sets (DSNTDJIN)
|Yes               |No                |Delete Db2 BSDS, active and archive log data sets (DSNTXJIN)
|No                |Yes               |Delete Db2 and Db2-supplied WLM environments start up procs (DSNTDJMA)
|Yes               |No                |Delete Db2 start up procs (DSNTXJMA)
|Yes               |Yes               |Delete Db2 subsystem parameter module (DSNTDJUZ)
|No                |Yes               |Delete Db2 application defaults module (DSNTDJUA)
|No                |Yes               |Delete Db2-supplied WLM application environments (DSNTDJRW)
|Yes               |Yes               |Delete aliases defined when provisioning the Db2 system (DSNTDJDA)
|Yes               |Yes               |Delete Db2 and IRLM subsystem definitions from z/OS (DSNTDJMD)
|No                |Yes               |Release all Db2 CF resources (DSNTDJCF)

    
## Security considerations for the sample Db2 software service template

The “workflow executor” of the provisioning service must have RACF authority to execute the service, and must also have the following authority: 
* Authority to allocate data sets with the aliases (HLQ) assigned to that Db2 instance, as well as USS files 
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

The following example shows these commands for provisioning two Db2 data sharing groups, each with two-way data sharing. As described in the [Naming Convention](#naming-convention) section, the group name of the data sharing group being provisioned is used for the IPNAME value. Because we expect two data sharing group instances to be provisioned with two members each, you can activate them all in one single job, considering that they will be all under the same RACF database.

```
//STEP01 EXEC PGM=IKJEFT01                                                     
//SYSTSPRT DD SYSOUT=*                                                         
//SYSTSIN DD *                                                                 
  RDEL PTKTDATA (DSNZ1)                                                        
  RDEL PTKTDATA (DSNZ0)                                                        
  RDEL PTKTDATA (DZ00)                                                         
  RDEL PTKTDATA (DZ01)                                                         
  RDEL PTKTDATA (DZ10)                                                         
  RDEL PTKTDATA (DZ11)                                                         
  RDEL PTKTDATA (IRRPTAUTH.DZ*.*)                                              
RDEF PTKTDATA DSNZ0 -                                          
 SSIGNON(KEYMASKED(E001193519561977)) -                        
 UACC(NONE) APPLDATA('NO REPLAY PROTECTION')                   
RDEF PTKTDATA DSNZ1 -                                          
 SSIGNON(KEYMASKED(E001193519561977)) -                        
 UACC(NONE) APPLDATA('NO REPLAY PROTECTION')                   
RDEF PTKTDATA DZ00 -                                           
 SSIGNON(KEYMASKED(E001193519561977)) -                        
 UACC(NONE) APPLDATA('NO REPLAY PROTECTION')                   
RDEF PTKTDATA DZ01 -                                           
 SSIGNON(KEYMASKED(E001193519561977)) -                        
 UACC(NONE) APPLDATA('NO REPLAY PROTECTION')                   
RDEF PTKTDATA DZ10 -                                           
 SSIGNON(KEYMASKED(E001193519561977)) -                        
 UACC(NONE) APPLDATA('NO REPLAY PROTECTION')                   
RDEF PTKTDATA DZ11 -                                           
 SSIGNON(KEYMASKED(E001193519561977)) -                        
 UACC(NONE) APPLDATA('NO REPLAY PROTECTION')                   
RDEFINE PTKTDATA IRRPTAUTH.DZ*.*                               
PERMIT IRRPTAUTH.DZ*.* CLASS(PTKTDATA) ID(WFexecutorID) ACCESS(UPDATE)     
SETROPTS RACLIST(PTKTDATA) REFRESH                                  
RDEFINE PTKTDATA IRRPTAUTH.DSNZ*.*                                  
PERMIT IRRPTAUTH.DSNZ*.* CLASS(PTKTDATA) ID(WFexecutorID) ACCESS(UPDATE)   
SETROPTS RACLIST(PTKTDATA) REFRESH                                    
```
### Authorizations for the sample Db2 software service template workflows
The following tables show the authorizations required for certain steps of the sample template. All other steps run under the authorization ID that executes the workflow. You can specify the authorization ID that executes the workflow in the AGEXECID variable in section 4 of the `dsntivin` and `dsntivia` input variable files. If the AGEXECID value is blank, the sign-on ID executes the steps.    

#### Authorizations for the provisioning workflow (`dsntiwpc.xml`)

|Step name|Job name|Run as user|Job description|RACF authorization|
|----|----|----|----|----|
|s00DEFSS|`DSNTIJMD`|SYSADM1/${PROTADMN}|Defines Db2 and IRLM to z/OS by SETSSI|A console that has master authority, or a console operator with sufficient RACF authorization.|
|stepJTC|`DSNTIJTC`|SYSADM1/${PROTADMN}|CATMAINT |For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|stepIJTM<br/>stepAJTM|`DSNTIJTM`<br/>`DSNTAJTM`|SYSADM1 /${PROTADMN}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|stepJSG|`DSNTIJSG`|SYSADM1/${PROTADMN}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|stepJRT|`DSNTIJRT`|${AUTHID}||Db2 authorization: DSNTRIN accepts two auth parms <br>(1) AUTHID ... the authorization ID to use to create most objects specified in ROUTINES CREATOR field of DSNTIPG <br>(2) SECDEFID ... the authorization ID to use to create routines that require SECURITY DEFINER, specified in SEC DEF CREATOR field of DSNTIPG. The user ID needs to be able to SET CURRENT SQLID to these secondary IDs |
|stepJRV|`DSNTIJRV`|${AUTHID}||RACF auth: <br>  - If CLASS(FACILITY) is active and the profile MVSADMIN.WLM.POLICY exists then the user ID needs READ access to the profile. <br> - If CLASS(OPERCMDS) is active and the profile MVS.MCSOPER.* exists then the user ID needs READ access to the profile. <br> For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.<br> - AUTHID ... used as the CURRENT SQLID when issuing SQL statements and as the owner of the package and plan for program DSNTRVFY. Specified in ROUTINES CREATOR field of DSNTIPG.|
|stepEJ1|`DSNTEJ1`|${IVPSQLID}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority. IVPSQLID is specified in the IVP SQL ID field of DSNTIPG.|
|stepEJ1L|`DSNTEJ1L`|${IVPSQLID}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority. IVPSQLID is specified in the IVP SQL ID field of DSNTIPG.|
|stepEJ2A|`DSNTEJ2A`|${IVPSQLID}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority. IVPSQLID is specified in the IVP SQL ID field of DSNTIPG.|
|stepJTU|`DSNTIJTU`|${INSSQLID}|Creates and grants usage on STOGROUP for user data TO ${INSGRLST}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority. INSGRLST is specified in the INSTALL GRANTEE(S) field of DSNTIPG.|

#### Authorizations for the START DB2 action (`dsnstart.xml`)

|Step name|Job name|Run as user|Job description|RACF authorization|
|----|----|----|----|----|
|stepJMD|`DSNTIJMD`|SYSADM1/${PROTADMN}|Defines Db2 & IRLM to z/OS by SETSSI|A console that has master authority, or a console operator with sufficient RACF authorization.|
|stepJSA|`DSNTIJSA`|SYSADM1/${PROTADMN}||RACF authorization: If CLASS(OPERCMDS) is active and the profile MVS.MCSOPER.* exists then the user ID needs READ access to the profile. <br>Db2 Authorization: None.  However, the command can be executed only from a z/OS console with the START command capability.|


#### Authorizations for the STOP DB2 action (`dsnstop.xml`)

|Step name|Job name|Run as user|Job description|RACF authorization|
|----|----|----|----|----|
|stepJSC|`DSNTIJSC`|SYSADM1/${PROTADMN}||Db2 Authorization: The user ID must use a privilege set of the process that includes one of the following privileges or authorities: <br>STOPALL privilege <br>SYSOPR authority <br>SYSCTRL authority <br>SYSADM authority <br>Db2 commands that are issued from a logged-on z/OS console or TSO SDSF can be checked by Db2 authorization using primary and secondary authorization IDs.|


#### Authorizations for the deprovisioning workflow (`dsndeprc.xml`)

|Step name|Job name|Run as user|Job description|RACF authorization|
|----|----|----|----|----|
|stepJSC|`DSNTIJSC`|SYSADM1/${PROTADMN}||Db2 Authorization: The user ID must use a privilege set of the process that includes one of the following privileges or authorities: <br>STOPALL privilege <br>SYSOPR authority <br>SYSCTRL authority <br>SYSADM authority <br>Db2 commands that are issued from a logged-on z/OS console or TSO SDSF can be checked by Db2 authorization using primary and secondary authorization IDs.|
|stepDJMD|`DSNTDJMD`|SYSADM1/${PROTADMN}||A console that has master authority, or a console operator with sufficient RACF authorization.|
|stepDJCF|`DSNTDJCF`|SYSADM1/${PROTADMN}||Authority to issue `SETXCF FORCE,CONNECTION` and `SETXCF FORCE,STRUCTURE` commands.|

#### Authorizations for the optional features enablement action (`dsnopent.xml`)

|Step name|Job name|Run as user|Job description|RACF authorization|
|----|----|----|----|----|
|stepJRP|`DSNTIJRP`|SYSADM1/${PROTADMN}|Enables Db2 REST services|For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|stepODBCBIND|`DSNTIJCL`|SYSADM1/${PROTADMN}|Bind and grants usage of PKG/PLAN TO ${INSGRLST}|For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|stepODBCVerify|`DSNTEJ8`|SYSADM1/${PROTADMN}||For Db2 authorization, the user ID must have primary or secondary installation SYSADM authority.|
|stepJDBCBIND|Shell-JCL inline|Workflow executor|Uses DB2Binder utility, which binds the Db2 packages that are used at the data server by the IBM Data Server Driver for JDBC and SQLJ into the NULLID collection, and grants EXECUTE authority on the packages to PUBLIC.|1) The workflow executor ID MUST have RACF privilege to generate PassTickets for others <br> 2) The BIND will be performed under SYSADM1/${JCCSID} ID, using a generated PASSTICKET instead of sending clear text passwords to connect to the Db2 subsystem. <br>See more details in [Using RACF PassTickets for optional features](#using-racf-passtickets-for-optional-features)|
|stepJDBCVerifyT2|Shell-JCL inline|Workflow executor|Performs local connection (JCC Type-2) to the provisioned Db2 subsystem and perform SQL queries against the Db2 sample database. Records the output into /tmp/db2-ssid-tej91t2 ||
|stepJDBCVerifyT4|Shell-JCL inline|Workflow executor|Performs remote connection (JCC Type-4) to the provisioned Db2 subsystem and perform SQL queries against the Db2 sample database. Records the output into `/tmp/db2-ssid-tej91t4`|The connection and verification is performed under SYSADM1/${JCCSID} ID, using a generated PASSTICKET instead of sending clear text passwords to connect to the Db2 subsystem. <br> See more details in [Using RACF PassTickets for optional features](#using-racf-passtickets-for-optional-features)|


