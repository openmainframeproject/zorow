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


#if($!{instance-UKO_CREATE_ROLE_USERIDS} == "true" ) 
"DELUSER "||KEY_ADMIN||" "
"DELUSER "||KEY_CUSTODIAN1||" "
"DELUSER "||KEY_CUSTODIAN2||" "
"DELUSER "||UKO_AUDITOR||" "
"PERMIT DEFAULT CL(ACCTNUM ) DELETE ID("||KEY_ADMIN||")" 
"PERMIT DEFAULT CL(ACCTNUM ) DELETE ID("||KEY_CUSTODIAN1||")" 
"PERMIT DEFAULT CL(ACCTNUM ) DELETE ID("||KEY_CUSTODIAN2||")" 
"PERMIT DEFAULT CL(ACCTNUM ) DELETE ID("||UKO_AUDITOR||")" 
"PERMIT  * CL(TSOPROC ) DELETE ID("||KEY_ADMIN||")" 
"PERMIT  * CL(TSOPROC ) DELETE ID("||KEY_CUSTODIAN1||")" 
"PERMIT  * CL(TSOPROC ) DELETE ID("||KEY_CUSTODIAN2||")" 
"PERMIT  * CL(TSOPROC ) DELETE ID("||UKO_AUDITOR||")" 
"SETROPTS RACLIST(TSOPROC) REFRESH "

#end

#if($!{instance-UKO_CREATE_ROLE_GROUPS} == "true" ) 
"DELGROUP "||KEY_ADMIN_GROUP||" "
"DELGROUP "||KEY_CUSTODIAN1_GROUP||" "
"DELGROUP "||KEY_CUSTODIAN2_GROUP||" "
"DELGROUP "||UKO_AUDITOR_GROUP||" "
#end

