/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

SERVER_STC_USER="${instance-UKO_SERVER_STC_USER}"
KEY_PREFIX="${instance-UKO_KEY_PREFIX}"
RACF_OWNER="${instance-UKO_ADMIN_SECURITY}"

Say "Defining key prefix profile "||KEY_PREFIX||".** in case this has not been done"
"RDEF CSFKEYS "||KEY_PREFIX||".** OWNER("||RACF_OWNER||") UACC(NONE) ICSF(SYMCPACFWRAP(YES),SYMCPACFRET(YES))"
Say "Granting access to "||SERVER_STC_USER||" on "||KEY_PREFIX||" "
"PERMIT "||KEY_PREFIX||".**  CLASS(CSFKEYS) ACCESS(CONTROL) ID("||SERVER_STC_USER||")"
/* "PERMIT "||KEY_PREFIX||".**  CLASS(CSFKEYS) ACCESS(CONTROL) ID("||KEY_ADMIN_GROUP||")" */

Say "Defining the recovery key label ${instance-UKO_RECOVERY_KEY}"
"RDEF CSFKEYS ${instance-UKO_RECOVERY_KEY} OWNER("||RACF_OWNER||") UACC(NONE)"
Say "Granting access to ${instance-UKO_RECOVERY_KEY} for "||SERVER_STC_USER||" "
"PERMIT ${instance-UKO_RECOVERY_KEY}  CLASS(CSFKEYS) ACCESS(CONTROL) ID("||SERVER_STC_USER||")"
/* "PERMIT ${instance-UKO_RECOVERY_KEY}  CLASS(CSFKEYS) ACCESS(CONTROL) ID("||KEY_ADMIN_GROUP||")" */

Say "Refreshing CSFKEYS"
"SETROPTS RACLIST(CSFKEYS) REFRESH"

exit