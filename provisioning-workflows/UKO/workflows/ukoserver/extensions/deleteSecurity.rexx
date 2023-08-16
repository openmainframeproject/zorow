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
/* configuring security as part of the deletion of a UKO         */
/* server.                                                             */
/*                                                                     */
/* By default this script does nothing, as there is an 'exit 0'        */
/* statement directly under this comment.  Review the profiles being   */
/* deleted and remove the 'exit 0' if you wish to use this script.     */
/*                                                                     */
/***********************************************************************/

SERVER_STC_USER="${instance-UKO_SERVER_STC_USER}"
SERVER_TASK_GROUP="${instance-UKO_SERVER_STC_GROUP}"

SERVER_UNAUTHENTICATED_USER="${instance-UKO_UNAUTHENTICATED_USER}"
SERVER_UNAUTHENTICATED_GROUP="${instance-UKO_UNAUTHENTICATED_GROUP}"

KEY_ADMIN="${instance-UKO_KEY_ADMIN}"
KEY_ADMIN_GROUP="${instance-UKO_KEY_ADMIN_GROUP}"


/***********************************************************************/
/* Delete the STARTED task for this server                             */
/***********************************************************************/
Say "Deleting STARTED task for the server"
"RDELETE STARTED ${instance-UKO_SERVER_STC_NAME}.*"

Say "Refreshing STARTED"
"SETROPTS RACLIST(STARTED) REFRESH"

#if($!{instance-UKO_CREATE_USERIDS} == "TRUE" ) 
/***********************************************************************/
/***********************************************************************/
/* Remove userids from profiles                                        */
/* this is only done if the userid had been genererated                */
/***********************************************************************/
/***********************************************************************/

/***********************************************************************/
/* Removing access to Db2 Naming protected access profiles */
/***********************************************************************/
Say "Removing access to RRSAF profile from "||SERVER_STC_USER||" "
"PERMIT ${instance-DB2_JCC_SSID}.RRSAF CLASS(DSNR)",
   " DELETE ID("||SERVER_STC_USER||")"                 

Say "Refreshing DSNR"
"SETROPTS RACLIST(DSNR) REFRESH"

/***********************************************************************/
/* Delete access to APPL class profile                                 */
/***********************************************************************/
Say "Remove client id "||AGENT_CLIENT_USER||" access to the profile in the APPL class"
"PERMIT EKMFWEB CLASS(APPL)",
   " DELETE ID("||AGENT_CLIENT_USER||")"

Say "Remove unauthenticated user "||SERVER_UNAUTHENTICATED_USER||" access to the profile in the APPL class"
"PERMIT EKMFWEB CLASS(APPL)",
   " DELETE ID("||SERVER_UNAUTHENTICATED_USER||")"

Say "Remove access to UKO from "||KEY_ADMIN_GROUP||" "
"PERMIT EKMFWEB CLASS(APPL)",
   " DELETE ID("||KEY_ADMIN_GROUP||")"

Say "Refreshing APPL"
"SETROPTS RACLIST(APPL) REFRESH"

/***********************************************************************/
/* Delete the security domain for server auth                          */
/***********************************************************************/
Say "Remove "||SERVER_STC_USER||" access from security domain for the server"
"PERMIT BBG.SECPFX.EKMFWEB CLASS(SERVER)",
   " DELETE ID("||SERVER_STC_USER||")"  

/***********************************************************************/
/* Delete the servers access to the angel process                      */
/***********************************************************************/
Say "Removing the servers access to the angel process"
#if(${instance-UKO_ANGEL_NAME} && ${instance-UKO_ANGEL_NAME} != "")
"PERMIT BBG.ANGEL.${instance-UKO_ANGEL_NAME} CLASS(SERVER)",
   " DELETE ID("||SERVER_STC_USER||")"
#else
"PERMIT BBG.ANGEL CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"
#end
/***********************************************************************/
/* Remove the servers access to use the z/OS Authorized services       */
/***********************************************************************/

Say "Removing the server ids READ access to the authorized module BBGZSAFM"
"PERMIT BBG.AUTHMOD.BBGZSAFM CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"

Say "Removing the server ids READ access to the SAF authorized user registry services and SAF authorization services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.SAFCRED CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"

Say "Removing the server ids READ access to the SVCDUMP services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.ZOSDUMP CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"

Say "Removing the server ids READ access to the optimized local adapter authorized service"
"PERMIT BBG.AUTHMOD.BBGZSAFM.LOCALCOM CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"
"PERMIT BBG.AUTHMOD.BBGZSAFM.WOLA CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"

Say "Removing the server ids READ access to the authorized module BBGZSCFM"
"PERMIT BBG.AUTHMOD.BBGZSCFM CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"

Say "Removing the server ids READ access to the optimized local adapter authorized client service"
"PERMIT BBG.AUTHMOD.BBGZSCFM.WOLA CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"

Say "Removing the server ids READ access to the WLM services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.ZOSWLM CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"

Say "Removing the server ids READ access to the TXRRS services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.TXRRS CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"

Say "Removing the server ids READ access to the IFAUSAGE services (PRODMGR)"
"PERMIT BBG.AUTHMOD.BBGZSAFM.PRODMGR CLASS(SERVER) DELETE ID("||SERVER_STC_USER||")"    

Say "Refreshing SERVER"
"SETROPTS RACLIST(SERVER) GENERIC(SERVER) REFRESH"

/***********************************************************************/
/* SMF Logging */
/***********************************************************************/
Say "Removing access to BPX.SMF CLASS(FACILITY) from "||SERVER_TASK_GROUP||" "
"PERMIT BPX.SMF CLASS(FACILITY) DELETE ID("||SERVER_TASK_GROUP||") "

Say "Refreshing FACILITY"
"SETROPTS RACLIST(FACILITY) REFRESH"


/***********************************************************************/
/***********************************************************************/
#end

exit