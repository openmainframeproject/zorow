
# IIB

Provision an IBM Integration Broker instance. Based on Message Broker v9.

## z/OSMF Version

This workflow has been tested with:

+ z/OSMF (V2R3) APAR PH11190 (PTF LEVEL UI63275)

## SAF

All nessecary security definitions are in RACF format. 

## (Installation) Requirements

### Run-As-User

Workflow steps are performed by a RunAsUser defined by the ZOSMF_INSTALL_USER variable. This variable is resolved via the input properties file _provisionIIB.properties_ . 

This RunAsUser should be able to perform the security related tasks:

+ Create, Modify and Connect a new RACF userid. (ADDUSER, ALTUSER and CONNECT command)
+ Define and Alter new resources in the STARTED class. (RDEFINE and RALTER command)
+ Adding permits to resources in the ZMFAPLA, MQCONN and MQCMDS class. (PERMIT command)

### Resource Pools
+ A Network Resource Pool (NRP) is required for the IIB workflow.
  - Each broker requires 1 TCP port.

### USSBATCH

The IIB workflows make use of a simple procedure called 'USSBATCH'. USSBATCH is essentially an user-written enhanced version of BPXBATCH. The USSBATCH procedure is included in the IIB workflow folder and is required in order to run several workflow steps.

#### Installation instructions:

IIB workflow directory includes 2 files, _USSBATCH.rexx_ and _USSBATCH.proc_.
+ Place both files at locations that are appropriate for your site.
  - (Proclib dataset must be defined and accessible to JES2.)
+ Replace <Your.own.proclib.here> in _USSBATCH.proc_ to the location where you have placed _USSBATCH.rexx_.
