//******************************************************************
//* Copyright Contributors to the zOS-Workflow Project.            *
//* PDX-License-Identifier: Apache-2.0                             *
//******************************************************************
//STEP1       EXEC  PGM=IKJEFT1A,DYNAMNBR=20
//SYSTSPRT    DD    SYSOUT=A
//SYSTSIN     DD    *
 ALLOCATE FILE(VPIN) PATH('${instance-WLP_USER_DIR}/servers/${_workflow-softwareServiceInstanceName}/${_workflow-softwareServiceInstanceName}.jcl')
 ALLOCATE FILE(VPOUT) DATASET('${instance-PROCLIB}(${_workflow-softwareServiceInstanceName})') SHR
 OCOPY INDD(VPIN) OUTDD(VPOUT) TEXT
 FREE FILE(VPOUT)
 FREE FILE(VPIN)
/*
