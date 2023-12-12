/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

KEY_PREFIX="${instance-UKO_KEY_PREFIX}"
AGENT_STC_USER="${instance-UKO_AGENT_STC_USER}"

Say "Remove access to "||KEY_PREFIX||".** from "||AGENT_STC_USER||" "
"PERMIT "||KEY_PREFIX||".**   CLASS(CSFKEYS) DELETE ID("||AGENT_STC_USER||")"

Say "Refreshing CSFKEYS"
"SETROPTS RACLIST(CSFKEYS) REFRESH"

exit