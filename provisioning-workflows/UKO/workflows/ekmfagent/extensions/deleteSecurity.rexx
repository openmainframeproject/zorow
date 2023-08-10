/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/
/***********************************************************************/
/*                                                                     */
/* PLEASE READ                                                         */
/*                                                                     */
/* This script contains example security profiles for dynamically      */
/* configuring security as part of the deletion of an EKMF Web         */
/* server.                                                             */
/*                                                                     */
/* By default this script does nothing, as there is an 'exit 0'        */
/* statement directly under this comment.  Review the profiles being   */
/* deleted and remove the 'exit 0' if you wish to use this script.     */
/*                                                                     */
/***********************************************************************/

AGENT_TASK_USER="${instance-EKMF_AGENT_TASK_USER}"
AGENT_TASK_GROUP="${instance-EKMF_AGENT_TASK_GROUP}"

WEB_CLIENT_USER="${instance-EKMF_CLIENT_USER}"
WEB_CLIENT_GROUP="${instance-EKMF_CLIENT_GROUP}"


/***********************************************************************/
/* Delete the STARTED task for this server                             */
/***********************************************************************/

Say "Deleting STARTED task for the agent"
"RDELETE STARTED ${instance-EKMF_AGENT_STC}.*"

"SETROPTS RACLIST(STARTED) REFRESH"

#if($!{instance-EKMF_CREATE_USERIDS} == "TRUE" ) 
/***********************************************************************/
/***********************************************************************/
/* Remove userids from profiles                                        */
/* this is only done if the userid had been genererated                */
/***********************************************************************/
/***********************************************************************/

/***********************************************************************/
/* Delete access to APPL class profile                                 */
/***********************************************************************/
Say "Remove client id "||WEB_CLIENT_USER||" access to the profile in the APPL class"
"PERMIT EKMFWEB CLASS(APPL) DELETE ID("||WEB_CLIENT_USER||")"

Say "Removing access to KMGPRACF class(APPL) from "||WEB_CLIENT_USER||" "
"PERMIT KMGPRACF CLASS(APPL) DELETE ID("||WEB_CLIENT_USER||") "

"SETROPTS RACLIST(APPL) REFRESH"

/***********************************************************************/
/* Delete FACILITY class access */
/***********************************************************************/
Say "Removing access to KMG.EKMF.KMGPRACF class(FACILITY) from "||AGENT_TASK_GROUP||" "
"PERMIT KMG.EKMF.KMGPRACF CLASS(FACILITY) DELETE ID("||AGENT_TASK_GROUP||") "        

Say "Deleting KMG.EKMF.KMGPRACF."||AGENT_TASK_USER||" in the FACILITY class"
"RDELETE FACILITY KMG.EKMF.KMGPRACF."||AGENT_TASK_USER||" "

"SETROPTS RACLIST(FACILITY) REFRESH"

/***********************************************************************/
/* Remove access for SMF logging */
/***********************************************************************/
Say "Removing access to KMG.EKMF.SMF from "||AGENT_TASK_GROUP||" "
"PERMIT KMG.EKMF.SMF CLASS(FACILITY) DELETE ID("||AGENT_TASK_GROUP||") "

"SETROPTS RACLIST(FACILITY) REFRESH"

/***********************************************************************/
/* Remove access from XFACILIT class  */
/***********************************************************************/

Say "Deleting KMG.WEBCLIENT."||WEB_CLIENT_USER||" in the XFACILIT class"
"RDELETE XFACILIT KMG.WEBCLIENT."||WEB_CLIENT_USER||" "

"SETROPTS RACLIST(XFACILIT) REFRESH"

/***********************************************************************/
/* Diffie-Hellman */
/***********************************************************************/

Say "Removing access to KMG.WS.* class(XFACILIT) to "||AGENT_TASK_GROUP||" "
"PERMIT KMG.WS.* CLASS(XFACILIT) DELETE ID("||AGENT_TASK_GROUP||")"

Say "Removing access to KMG.LG.* class(XFACILIT) to "||AGENT_TASK_GROUP||" "
"PERMIT KMG.LG.* CLASS(XFACILIT) DELETE ID("||AGENT_TASK_GROUP||")"

"SETROPTS RACLIST(XFACILIT) REFRESH"

/***********************************************************************/
/***********************************************************************/
#end

exit