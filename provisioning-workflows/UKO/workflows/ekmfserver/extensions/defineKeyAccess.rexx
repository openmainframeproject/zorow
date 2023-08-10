/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

WEB_TASK_USER="${instance-EKMF_WEB_TASK_USER}"
KEY_PREFIX="${instance-EKMF_KEY_PREFIX}"
RACF_OWNER="${instance-EKMF_ADMIN_SECURITY}"

Say "Defining key prefix profile "||KEY_PREFIX||".** in case this has not been done"
"RDEF CSFKEYS "||KEY_PREFIX||".** OWNER("||RACF_OWNER||") UACC(NONE) ICSF(SYMCPACFWRAP(YES),SYMCPACFRET(YES))"
Say "Granting access to "||WEB_TASK_USER||" on "||KEY_PREFIX||" "
"PERMIT "||KEY_PREFIX||".**  CLASS(CSFKEYS) ACCESS(CONTROL) ID("||WEB_TASK_USER||")"
/* "PERMIT "||KEY_PREFIX||".**  CLASS(CSFKEYS) ACCESS(CONTROL) ID("||KEY_ADMIN_GROUP||")" */

Say "Defining the recovery key label GENERATE.EKMFWEB.DRK"
"RDEF CSFKEYS GENERATE.EKMFWEB.DRK OWNER("||RACF_OWNER||") UACC(NONE)"
Say "Granting access to GENERATE.EKMFWEB.DRK for "||WEB_TASK_USER||" "
"PERMIT GENERATE.EKMFWEB.DRK  CLASS(CSFKEYS) ACCESS(CONTROL) ID("||WEB_TASK_USER||")"
/* "PERMIT GENERATE.EKMFWEB.DRK  CLASS(CSFKEYS) ACCESS(CONTROL) ID("||KEY_ADMIN_GROUP||")" */

Say "Refreshing CSFKEYS"
"SETROPTS RACLIST(CSFKEYS) REFRESH"

exit