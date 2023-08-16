/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/
/***********************************************************************/
/* Define dynamic security profiles for the server                     */
/***********************************************************************/

SERVER_STC_USER="${instance-UKO_SERVER_STC_USER}"
SERVER_TASK_GROUP="${instance-UKO_SERVER_STC_GROUP}"

SERVER_UNAUTHENTICATED_USER="${instance-UKO_UNAUTHENTICATED_USER}"
SERVER_UNAUTHENTICATED_GROUP="${instance-UKO_UNAUTHENTICATED_GROUP}"

KEY_ADMIN="${instance-UKO_KEY_ADMIN}"
KEY_ADMIN_GROUP="${instance-UKO_KEY_ADMIN_GROUP}"


/***********************************************************************/
/* SMF Logging */
/***********************************************************************/

/* This is required only if smf logging is enabled */
Say "Creating BPX.SMF in the FACILITY class to enable SMF logging"
"RDEFINE FACILITY BPX.SMF UACC(NONE)" 
Say "Granting access to BPX.SMF CLASS(FACILITY) to "||SERVER_TASK_GROUP||" "
"PERMIT BPX.SMF CLASS(FACILITY) ID("||SERVER_TASK_GROUP||") ACCESS(READ)"

Say "Refreshing FACILITY"
"SETROPTS RACLIST(FACILITY) REFRESH"

/***********************************************************************/
/* Setup the STARTED task for this server                              */
/***********************************************************************/
Say "Defining STARTED task for the server"
"RDEF STARTED ${instance-UKO_SERVER_STC_NAME}.* UACC(NONE)",
   " STDATA(USER("||SERVER_STC_USER||") PRIVILEGED(NO) TRUSTED(NO) TRACE(YES))"

Say "Refreshing STARTED"
"SETROPTS RACLIST(STARTED) REFRESH"

/***********************************************************************/
/* Setup the APPL class profile                                        */
/***********************************************************************/
Say "Define the server specific APPLID to RACF"
"RDEFINE APPL EKMFWEB UACC(NONE)"

Say "Activating the APPL class"
/* If not active, the domain is not restricted, which means anyone can authenticate to it */
"SETROPTS CLASSACT(APPL)"

Say "Grant an unauthenticated "||SERVER_UNAUTHENTICATED_USER||" user ID READ access to the profile in the APPL class"
"PERMIT EKMFWEB CLASS(APPL) ACCESS(READ) ID("||SERVER_UNAUTHENTICATED_USER||")"

Say "All users that will access UKO are required to have READ access to this resource."
Say "Grant access to UKO to "||KEY_ADMIN_GROUP||" "
"PERMIT EKMFWEB CLASS(APPL) ACCESS(READ) ID("||KEY_ADMIN_GROUP||")"

Say "Refreshing APPL"
"SETROPTS RACLIST(APPL) REFRESH"

/***********************************************************************/
/* Configure a security domain for server auth                         */
/***********************************************************************/

Say "Create the security domain for the server"
"RDEFINE SERVER BBG.SECPFX.EKMFWEB UACC(NONE)"

Say "Grant the servers id READ access to the security domain for the server"
"PERMIT BBG.SECPFX.EKMFWEB CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

/***********************************************************************/
/* Grant the server access to the angel process                        */
/***********************************************************************/

#if(${instance-UKO_ANGEL_NAME} && ${instance-UKO_ANGEL_NAME} != "")
Say "Define the class for the named angel process"
"RDEFINE SERVER BBG.ANGEL.${instance-UKO_ANGEL_NAME} UACC(NONE)"
Say "Permitting the server access to the angel process"
"PERMIT BBG.ANGEL.${instance-UKO_ANGEL_NAME} CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"
#else
Say "Define the class for the default angel process"
"RDEFINE SERVER BBG.ANGEL UACC(NONE)"
Say "Permitting the server access to the angel process"
"PERMIT BBG.ANGEL CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"
#end

/***********************************************************************/
/* Grant the server access to use the z/OS Authorized services         */
/***********************************************************************/

Say "Create a SERVER profile for the authorized module BBGZSAFM"
"RDEFINE SERVER BBG.AUTHMOD.BBGZSAFM UACC(NONE)"
Say "Permit "||SERVER_STC_USER||" READ access to the authorized module BBGZSAFM"
"PERMIT BBG.AUTHMOD.BBGZSAFM CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

Say "Create a profile for the SAF authorized user registry services and SAF authorization services"
"RDEFINE SERVER BBG.AUTHMOD.BBGZSAFM.SAFCRED UACC(NONE)"
Say "Permit "||SERVER_STC_USER||" READ access to the SAF authorized user registry services and SAF authorization services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.SAFCRED CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

Say "Create a profile for the SVCDUMP services"
"RDEFINE  SERVER BBG.AUTHMOD.BBGZSAFM.ZOSDUMP UACC(NONE)"
Say "Permit "||SERVER_STC_USER||" READ access to the SVCDUMP services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.ZOSDUMP CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

Say "Create profiles for the optimized local adapter authorized service"
"RDEFINE  SERVER BBG.AUTHMOD.BBGZSAFM.LOCALCOM UACC(NONE)"
"RDEFINE  SERVER BBG.AUTHMOD.BBGZSAFM.WOLA UACC(NONE)"
Say "Permit "||SERVER_STC_USER||" READ access to the optimized local adapter authorized service"
"PERMIT BBG.AUTHMOD.BBGZSAFM.LOCALCOM CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"
"PERMIT BBG.AUTHMOD.BBGZSAFM.WOLA CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

Say "Create a SERVER profile for the authorized module BBGZSCFM"
"RDEFINE SERVER BBG.AUTHMOD.BBGZSCFM UACC(NONE)"
Say "Permit "||SERVER_STC_USER||" READ access to the authorized module BBGZSCFM"
"PERMIT BBG.AUTHMOD.BBGZSCFM CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

Say "Create profiles for the optimized local adapter authorized client service"
"RDEFINE  SERVER BBG.AUTHMOD.BBGZSCFM.WOLA UACC(NONE)"
Say "Permit "||SERVER_STC_USER||" READ access to the optimized local adapter authorized client service"
"PERMIT BBG.AUTHMOD.BBGZSCFM.WOLA CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

Say "Create a profile for WLM services"
"RDEFINE  SERVER BBG.AUTHMOD.BBGZSAFM.ZOSWLM UACC(NONE)"
Say "Permit "||SERVER_STC_USER||" READ access to the WLM services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.ZOSWLM CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

Say "Create a profile for the TXRRS services"
"RDEFINE  SERVER BBG.AUTHMOD.BBGZSAFM.TXRRS UACC(NONE)"
Say "Permit "||SERVER_STC_USER||" READ access to the TXRRS services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.TXRRS CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

Say "Create a profile for the IFAUSAGE services (PRODMGR)"
"RDEFINE  SERVER BBG.AUTHMOD.BBGZSAFM.PRODMGR UACC(NONE)"
Say "Permit "||SERVER_STC_USER||" READ access to the IFAUSAGE services (PRODMGR)"
"PERMIT BBG.AUTHMOD.BBGZSAFM.PRODMGR CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

Say "Create a profile for the ZOSAIO services"
"RDEFINE SERVER BBG.AUTHMOD.BBGZSAFM.ZOSAIO UACC(NONE)"
Say "Permit "||SERVER_STC_USER||" READ access to the ZOSAIO services"
"PERMIT BBG.AUTHMOD.BBGZSAFM.ZOSAIO CLASS(SERVER)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"

Say "Refreshing SERVER"
"SETROPTS RACLIST(SERVER) GENERIC(SERVER) REFRESH"

/***********************************************************************/
/* Creating common EJB Roles */
/***********************************************************************/

Say "Defining the UKOss role class"
"RDEFINE EJBROLE EKMFWEB.*.* UACC(NONE)"

Say "Defining EJB roles for authentication"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.authenticated UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.com.ibm.ws.security.oauth20.* UACC(NONE)"

Say "Grant access to the EJB roles for authentication to every user"
"PERMIT EKMFWEB.ekmf-rest-api.authenticated CLASS(EJBROLE) ACCESS(READ) ID(*)"
"PERMIT EKMFWEB.com.ibm.ws.security.oauth20.* CLASS(EJBROLE) ACCESS(READ) ID(*)"

Say "Refreshing EJBROLE"
"SETROPTS RACLIST(EJBROLE) REFRESH"

/***********************************************************************/
/* Granting access to Db2 Naming protected access profiles */
/***********************************************************************/
Say "Defining RRSAF profile in DSNR class"
"RDEFINE DSNR ${instance-DB2_JCC_SSID}.RRSAF UACC(NONE)"
Say "Granting access to RRSAF profile to "||SERVER_STC_USER||" "
"PERMIT ${instance-DB2_JCC_SSID}.RRSAF CLASS(DSNR)",
   " ACCESS(READ) ID("||SERVER_STC_USER||")"                 

Say "Refreshing DSNR"
"SETROPTS RACLIST(DSNR) REFRESH"

exit