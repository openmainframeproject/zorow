/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

KEY_PREFIX="${instance-EKMF_KEY_PREFIX}"
AGENT_TASK_USER="${instance-EKMF_AGENT_TASK_USER}"

Say "Remove access to "||KEY_PREFIX||".** from "||AGENT_TASK_USER||" "
"PERMIT "||KEY_PREFIX||".**   CLASS(CSFKEYS) DELETE ID("||AGENT_TASK_USER||")"

Say "Refreshing CSFKEYS"
"SETROPTS RACLIST(CSFKEYS) REFRESH"

exit