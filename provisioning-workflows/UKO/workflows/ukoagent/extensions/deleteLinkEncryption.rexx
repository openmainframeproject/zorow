/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

AGENT_STC_USER="${instance-UKO_AGENT_STC_USER}"
AGENT_STC_GROUP="${instance-UKO_AGENT_STC_GROUP}"

AGENT_CLIENT_USER="${instance-UKO_AGENT_CLIENT_USER}"
AGENT_CLIENT_GROUP="${instance-UKO_AGENT_CLIENT_GROUP}"

PUBLIC_KEY_HASH="${instance-UKO_SERVER_PUBLIC_KEY_HASH}"

/***********************************************************************/
/* Diffie-Hellman */
/***********************************************************************/


#if($!{instance-UKO_CREATE_TECHNICAL_USERIDS} == "true" ) 

Say "Removing access to KMG.WS."||PUBLIC_KEY_HASH||" class(XFACILIT) from "||AGENT_STC_GROUP||" "
"PERMIT KMG.WS."||PUBLIC_KEY_HASH||" CLASS(XFACILIT) DELETE ID("||AGENT_STC_GROUP||")"

Say "Removing access to KMG.LG."||PUBLIC_KEY_HASH||" class(XFACILIT) from "||AGENT_STC_GROUP||" "
"PERMIT KMG.LG."||PUBLIC_KEY_HASH||" CLASS(XFACILIT) DELETE ID("||AGENT_STC_GROUP||")"

"SETROPTS RACLIST(XFACILIT) REFRESH"

/***********************************************************************/
/***********************************************************************/
#end

exit