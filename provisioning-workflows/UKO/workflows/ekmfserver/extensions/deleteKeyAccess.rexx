/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

KEY_PREFIX="${instance-EKMF_KEY_PREFIX}"
WEB_TASK_USER="${instance-EKMF_WEB_TASK_USER}"

#if($!{instance-EKMF_CREATE_USERIDS} == "TRUE" ) 
Say "Remove access to recovery key"
"PERMIT GENERATE.EKMFWEB.DRK  CLASS(CSFKEYS) DELETE ID("||WEB_TASK_USER||")"
/* "PERMIT GENERATE.EKMFWEB.DRK  CLASS(CSFKEYS) DELETE ID("||KEY_ADMIN_GROUP||")" */
#end 

Say "Remove access to "||KEY_PREFIX||".** from "||WEB_TASK_USER||" "
"PERMIT "||KEY_PREFIX||".**   CLASS(CSFKEYS) DELETE ID("||WEB_TASK_USER||")"

Say "Refreshing CSFKEYS"
"SETROPTS RACLIST(CSFKEYS) REFRESH"

exit