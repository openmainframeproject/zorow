
# IIB

Provision an IBM Integration Broker instance. Based on Message Broker v9.

## z/OSMF Version

This workflow has been tested with z/OSMF (V2R3) APAR PI96730 (PTF UI60773)

## SAF

All nessecary security definitions are in RACF format. 

## (Installation) Requirements

### Resource Pools
+ A Network Resource Pool (NRP) is required for the IIB workflow.
  - Each broker requires 2 TCP ports.

### USSBATCH

The IIB workflows make use of a simple procedure called 'USSBATCH'. USSBATCH is essentially an user-written enhanced version of BPXBATCH. The USSBATCH procedure is included in the IIB workflow folder and is required in order to run several workflow steps.

#### Installation instructions:
------------------------------

IIB workflow directory includes 2 files, _USSBATCH.rexx_ and _USSBATCH.proc_.
+ Place both files at locations that are appropriate for your site.
  - (Proclib dataset must be defined and accessible to JES2.)
+ Replace <Your.own.proclib.here> in _USSBATCH.proc_ to the location where you have placed _USSBATCH.rexx_.
