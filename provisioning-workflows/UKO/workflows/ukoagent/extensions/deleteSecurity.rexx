/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

AGENT_STC_USER="${instance-UKO_AGENT_STC_USER}"
AGENT_STC_GROUP="${instance-UKO_AGENT_STC_GROUP}"

AGENT_CLIENT_USER="${instance-UKO_AGENT_CLIENT_USER}"
AGENT_CLIENT_GROUP="${instance-UKO_AGENT_CLIENT_GROUP}"


/***********************************************************************/
/* Delete the STARTED task for this server                             */
/***********************************************************************/

Say "Deleting STARTED task for the agent"
"RDELETE STARTED ${instance-UKO_AGENT_STC_NAME}.*"

"SETROPTS RACLIST(STARTED) REFRESH"

#if($!{instance-UKO_CREATE_TECHNICAL_USERIDS} == "true" ) 
/***********************************************************************/
/***********************************************************************/
/* Remove userids from profiles                                        */
/* this is only done if the userid had been genererated                */
/***********************************************************************/
/***********************************************************************/

/***********************************************************************/
/* Delete access to APPL class profile                                 */
/***********************************************************************/
Say "Remove client id "||AGENT_CLIENT_USER||" access to the profile in the APPL class"
"PERMIT EKMFWEB CLASS(APPL) DELETE ID("||AGENT_CLIENT_USER||")"

Say "Removing access to KMGPRACF class(APPL) from "||AGENT_CLIENT_USER||" "
"PERMIT KMGPRACF CLASS(APPL) DELETE ID("||AGENT_CLIENT_USER||") "

"SETROPTS RACLIST(APPL) REFRESH"

/***********************************************************************/
/* Delete FACILITY class access */
/***********************************************************************/
Say "Removing access to KMG.EKMF.KMGPRACF class(FACILITY) from "||AGENT_STC_GROUP||" "
"PERMIT KMG.EKMF.KMGPRACF CLASS(FACILITY) DELETE ID("||AGENT_STC_GROUP||") "        

Say "Deleting KMG.EKMF.KMGPRACF."||AGENT_STC_USER||" in the FACILITY class"
"RDELETE FACILITY KMG.EKMF.KMGPRACF."||AGENT_STC_USER||" "

"SETROPTS RACLIST(FACILITY) REFRESH"

/***********************************************************************/
/* Remove access for SMF logging */
/***********************************************************************/
Say "Removing access to KMG.EKMF.SMF from "||AGENT_STC_GROUP||" "
"PERMIT KMG.EKMF.SMF CLASS(FACILITY) DELETE ID("||AGENT_STC_GROUP||") "

#if(${instance-WORKSTATION_ACCESS_REQUIRED} && ${instance-WORKSTATION_ACCESS_REQUIRED} == "true")
/* Only for Workstation use: */
Say "Removing access to KMG.EKMF.AUDITOFF from "||AGENT_STC_GROUP||" "
"PERMIT KMG.EKMF.AUDITOFF CLASS(FACILITY) DELETE ID("||AGENT_STC_GROUP||")"
#end 

"SETROPTS RACLIST(FACILITY) REFRESH"

/***********************************************************************/
/* Remove access from XFACILIT class  */
/***********************************************************************/

Say "Deleting KMG.WEBCLIENT."||AGENT_CLIENT_USER||" in the XFACILIT class"
"RDELETE XFACILIT KMG.WEBCLIENT."||AGENT_CLIENT_USER||" "

"SETROPTS RACLIST(XFACILIT) REFRESH"

#if(${instance-WORKSTATION_ACCESS_REQUIRED} && ${instance-WORKSTATION_ACCESS_REQUIRED} == "true")
/***********************************************************************/
/* Removing access from Db2 DSNR */
/***********************************************************************/
Say "Removing access to BATCH profile from "||AGENT_STC_USER||" "
"PERMIT ${instance-DB2_JCC_SSID}.BATCH CLASS(DSNR)",
   " DELETE ID("||AGENT_STC_USER||")"                 

Say "Refreshing DSNR"
"SETROPTS RACLIST(DSNR) REFRESH"
#end

/***********************************************************************/
/***********************************************************************/
#end

exit