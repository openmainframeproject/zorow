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

WEB_TASK_USER="${instance-EKMF_WEB_TASK_USER}"
WEB_TASK_GROUP="${instance-EKMF_WEB_TASK_GROUP}"

WEB_UNAUTHENTICATED_USER="${instance-EKMF_WEB_UNAUTHENTICATED_USER}"
WEB_UNAUTHENTICATED_GROUP="${instance-EKMF_WEB_UNAUTHENTICATED_GROUP}"

KEY_ADMIN="${instance-EKMF_KEY_ADMIN}"
KEY_ADMIN_GROUP="${instance-EKMF_KEY_ADMIN_GROUP}"


/***********************************************************************/
/* Delete the STARTED task for this server                             */
/***********************************************************************/
Say "Deleting STARTED task for the server"
"RDELETE STARTED ${instance-EKMF_WEB_STC}.*"

Say "Refreshing STARTED"
"SETROPTS RACLIST(STARTED) REFRESH"

#if($!{instance-EKMF_CREATE_USERIDS} == "TRUE" ) 
/***********************************************************************/
/***********************************************************************/
/* Remove userids from profiles                                        */
/* this is only done if the userid had been genererated                */
/***********************************************************************/
/***********************************************************************/

/***********************************************************************/
/* Removing access to Db2 Naming protected access profiles */
/***********************************************************************/
Say "Removing access to RRSAF profile from "||WEB_TASK_USER||" "
"PERMIT ${instance-DB2_JCC_SSID}.RRSAF CLASS(DSNR)",
   " DELETE ID("||WEB_TASK_USER||")"                 

Say "Refreshing DSNR"
"SETROPTS RACLIST(DSNR) REFRESH"

/***********************************************************************/
/* Delete access to APPL class profile                                 */
/***********************************************************************/
Say "Remove client id "||WEB_CLIENT_USER||" access to the profile in the APPL class"
"PERMIT EKMFWEB CLASS(APPL)",
   " DELETE ID("||WEB_CLIENT_USER||")"

Say "Remove unauthenticated user "||WEB_UNAUTHENTICATED_USER||" access to the profile in the APPL class"
"PERMIT EKMFWEB CLASS(APPL)",
   " DELETE ID("||WEB_UNAUTHENTICATED_USER||")"

Say "Remove access to EKMFWEB from "||KEY_ADMIN_GROUP||" "
"PERMIT EKMFWEB CLASS(APPL)",
   " DELETE ID("||KEY_ADMIN_GROUP||")"

Say "Refreshing APPL"
"SETROPTS RACLIST(APPL) REFRESH"

/***********************************************************************/
/* Delete the security domain for server auth                          */
/***********************************************************************/
Say "Remove "||WEB_TASK_USER||" access from security domain for the server"
"PERMIT BBG.SECPFX.EKMFWEB CLASS(SERVER)",
   " DELETE ID("||WEB_TASK_USER||")"  

/***********************************************************************/
/* Delete the servers access to the angel process                      */
/***********************************************************************/
Say "Removing the servers access to the angel process"
#if(${instance-EKMF_ANGEL_NAME} && ${instance-EKMF_ANGEL_NAME} != "")
"PERMIT BBG.ANGEL.${instance-EKMF_ANGEL_NAME} CLASS(SERVER)",
   " DELETE ID("||WEB_TASK_USER||")"
#else
"PERMIT BBG.ANGEL CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"
#end
/***********************************************************************/
/* Remove the servers access to use the z/OS Authorized services       */
/***********************************************************************/

Say "Removing the server ids READ access to the authorized module BBGZSAFM"
"PERMIT BBG.AUTHMOD.BBGZSAFM CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"

Say "Removing the server ids READ access to the SAF authorized user registry services and SAF authorization services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.SAFCRED CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"

Say "Removing the server ids READ access to the SVCDUMP services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.ZOSDUMP CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"

Say "Removing the server ids READ access to the optimized local adapter authorized service"
"PERMIT BBG.AUTHMOD.BBGZSAFM.LOCALCOM CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"
"PERMIT BBG.AUTHMOD.BBGZSAFM.WOLA CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"

Say "Removing the server ids READ access to the authorized module BBGZSCFM"
"PERMIT BBG.AUTHMOD.BBGZSCFM CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"

Say "Removing the server ids READ access to the optimized local adapter authorized client service"
"PERMIT BBG.AUTHMOD.BBGZSCFM.WOLA CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"

Say "Removing the server ids READ access to the WLM services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.ZOSWLM CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"

Say "Removing the server ids READ access to the TXRRS services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.TXRRS CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"

Say "Removing the server ids READ access to the IFAUSAGE services (PRODMGR)"
"PERMIT BBG.AUTHMOD.BBGZSAFM.PRODMGR CLASS(SERVER) DELETE ID("||WEB_TASK_USER||")"    

Say "Refreshing SERVER"
"SETROPTS RACLIST(SERVER) GENERIC(SERVER) REFRESH"

/***********************************************************************/
/* SMF Logging */
/***********************************************************************/
Say "Removing access to BPX.SMF CLASS(FACILITY) from "||WEB_TASK_GROUP||" "
"PERMIT BPX.SMF CLASS(FACILITY) DELETE ID("||WEB_TASK_GROUP||") "

Say "Refreshing FACILITY"
"SETROPTS RACLIST(FACILITY) REFRESH"


/***********************************************************************/
/***********************************************************************/
#end

exit