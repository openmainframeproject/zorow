/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/


KEY_ADMIN="${instance-UKO_KEY_ADMIN}"
KEY_ADMIN_GROUP="${instance-UKO_KEY_ADMIN_GROUP}"

KEY_CUSTODIAN1="${instance-UKO_KEY_CUSTODIAN1}"
KEY_CUSTODIAN1_GROUP="${instance-UKO_KEY_CUSTODIAN1_GROUP}"

KEY_CUSTODIAN2="${instance-UKO_KEY_CUSTODIAN2}"
KEY_CUSTODIAN2_GROUP="${instance-UKO_KEY_CUSTODIAN2_GROUP}"

UKO_AUDITOR="${instance-UKO_AUDITOR}"
UKO_AUDITOR_GROUP="${instance-UKO_AUDITOR_GROUP}"

#if($!{instance-UKO_CREATE_ROLE_GROUPS} == "true" ) 
/***********************************************************************/
/* Creating the required groups                                        */
/***********************************************************************/
Say "Creating the required groups"
Say "Creating the key administrator group"
"ADDGROUP "||KEY_ADMIN_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the key custodian1 group"
"ADDGROUP "||KEY_CUSTODIAN1_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the key custodian2 group"
"ADDGROUP "||KEY_CUSTODIAN2_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the auditor group"
"ADDGROUP "||UKO_AUDITOR_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
#end

#if($!{instance-UKO_CREATE_ROLE_USERIDS} == "true" ) 
/***********************************************************************/
/* Creating all required user ids                                      */
/***********************************************************************/

Say "Adding the key administrator user"
"ADDUSER "||KEY_ADMIN||" NOOIDCARD ",
   " DFLTGRP("||KEY_ADMIN_GROUP||") NAME('KEY ADMIN')",
   " PHRASE('pass4youpass4you')",
   " TSO( acctnum(DEFAULT) holdclass(H) ",
      "  msgclass(H) sysoutclass(H) proc(ISPFCCC) ",
      "  size(500000) unit(SYSALLDA)) ",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||KEY_ADMIN||"'"||")) "
"PERMIT DEFAULT CL(ACCTNUM ) ACCESS(READ) ID("||KEY_ADMIN||")" 
"PERMIT  * CL(TSOPROC ) ACCESS(READ) ID("||KEY_ADMIN||")" 
"SETROPTS RACLIST(TSOPROC) REFRESH "

Say "Adding the key administrator user"
"ADDUSER "||KEY_CUSTODIAN1||" NOOIDCARD ",
   " DFLTGRP("||KEY_CUSTODIAN1_GROUP||") NAME('KEY ADMIN')",
   " PHRASE('pass4youpass4you')",
   " TSO( acctnum(DEFAULT) holdclass(H) ",
      "  msgclass(H) sysoutclass(H) proc(ISPFCCC) ",
      "  size(500000) unit(SYSALLDA)) ",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||KEY_CUSTODIAN1||"'"||")) "
"PERMIT DEFAULT CL(ACCTNUM ) ACCESS(READ) ID("||KEY_CUSTODIAN1||")" 
"PERMIT  * CL(TSOPROC ) ACCESS(READ) ID("||KEY_CUSTODIAN1||")" 
"SETROPTS RACLIST(TSOPROC) REFRESH "


Say "Adding the key administrator user"
"ADDUSER "||KEY_CUSTODIAN2||" NOOIDCARD ",
   " DFLTGRP("||KEY_CUSTODIAN2_GROUP||") NAME('KEY ADMIN')",
   " PHRASE('pass4youpass4you')",
   " TSO( acctnum(DEFAULT) holdclass(H) ",
      "  msgclass(H) sysoutclass(H) proc(ISPFCCC) ",
      "  size(500000) unit(SYSALLDA)) ",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||KEY_CUSTODIAN2||"'"||")) "
"PERMIT DEFAULT CL(ACCTNUM ) ACCESS(READ) ID("||KEY_CUSTODIAN2||")" 
"PERMIT  * CL(TSOPROC ) ACCESS(READ) ID("||KEY_CUSTODIAN2||")" 
"SETROPTS RACLIST(TSOPROC) REFRESH "


Say "Adding the key administrator user"
"ADDUSER "||UKO_AUDITOR||" NOOIDCARD ",
   " DFLTGRP("||UKO_AUDITOR_GROUP||") NAME('KEY ADMIN')",
   " PHRASE('pass4youpass4you')",
   " TSO( acctnum(DEFAULT) holdclass(H) ",
      "  msgclass(H) sysoutclass(H) proc(ISPFCCC) ",
      "  size(500000) unit(SYSALLDA)) ",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||UKO_AUDITOR||"'"||")) "
"PERMIT DEFAULT CL(ACCTNUM ) ACCESS(READ) ID("||UKO_AUDITOR||")" 
"PERMIT  * CL(TSOPROC ) ACCESS(READ) ID("||UKO_AUDITOR||")" 
"SETROPTS RACLIST(TSOPROC) REFRESH "


#end 

