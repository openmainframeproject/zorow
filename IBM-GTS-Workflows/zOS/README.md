# PA-zOSMF-Workflows-zOS

## z/OSMF workflows for the z/OS platform

This repository contains workflow definitions (XML files) that can be used with the Workflows task of the z/OS Management Facility (z/OSMF).

In z/OSMF, a workflow is a guided set of steps that help you perform an activity on z/OS®, such as configuring a software product, managing a z/OS resource, or simplifying some relatively complex operation. To support these activities, a workflow can be designed to perform a wide variety of operations, such as starting z/OS subsystems, submitting jobs and scripts, and invoking TSO/E functions.

There are no warranties of any kind, and there is no service or technical support available for these materials from IBM. As a recommended practice, review carefully any materials that you download from this site before using them on a live system.

Though the materials provided herein are not supported by the IBM Service organization, your comments are welcomed by the developers, who reserve the right to revise or remove the materials at any time. 

## SLE Developed Workflows:
| File Name | Description | 
| ------    | ------      |
|IBM-MF-AUTO-ZOS-CONSCMD|An example on how to call the z/OSMF Consoles REST Interface to issue a MVS command|
|IBM-MF-AUTO-ZOS-DASDINIT|This workflow can be used to initialize (or format) a dasd **!! USE WITH CAUTION !!**|
|IBM-MF-AUTO-ZOS-IPLTEXT|This workflow can be used to write IPL Text|
|IBM-MF-AUTO-ZOS-LINKLIST-ADD|Quickly add a dataset to Linklist|
|IBM-MF-AUTO-ZOS-LINKLIST-DEL|Quickly delete a dataset from Linklist|
|IBM-MF-AUTO-ZOS-PDSEMPTY|A workflow designed to delete all members of a Partitioned Dataset **!! USE WITH CAUTION !!**|
|IBM-MF-AUTO-ZOS-REXXVARS|An example on how to manipulate workflow variables in REXX using a properties file, this was a little hard to figure out because of the lack of documentation of the $_output function, it is only fair that I share this|
|IBM-MF-AUTO-ZOS-SADMP|This workflow will initialize the volumes, create the new SYS1.SADMP stripe dataset and the SAD program plus IPL Text|
|IBM-MF-AUTO-ZOS-SADMP.txt|**Optional** Sample input file to use with IBM-MF-AUTO-ZOS-SADMP.xml workflow|

## User Contributed Code:
| File Name | Description | 
| ------    | ------      |
|IBM-MF-USR-ZOS-ADD-LOCAL-PAGE-DATASET|This workflow can be used to add a new Local Page Space dataset to be used when increase of auxiliary storage is required.|

* All zOSMF Workflows with **IBM-MF-AUTO prefix** were developed and are supported by Mainframe Service Line Engineering team.
* All zOSMF Workflows with **IBM-MF-USR prefix** were developed by the z community and shared for global re-use, however there is no ongoing support on them. By uploading the them into your system, you will be responsible to maintain it.

IBM Z Systems - Workflow Repository: https://github.com/IBM/IBM-Z-zOS/tree/master/zOS-Workflow
