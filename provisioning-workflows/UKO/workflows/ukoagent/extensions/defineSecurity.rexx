/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/
/***********************************************************************/
/* Define security profiles for the agent                              */
/***********************************************************************/

AGENT_STC_USER="${instance-UKO_AGENT_STC_USER}"
AGENT_STC_GROUP="${instance-UKO_AGENT_STC_GROUP}"

AGENT_CLIENT_USER="${instance-UKO_AGENT_CLIENT_USER}"
AGENT_CLIENT_GROUP="${instance-UKO_AGENT_CLIENT_GROUP}"

/***********************************************************************/
/* Setup the STARTED task for this server                              */
/***********************************************************************/
Say "Defining STARTED task for the agent"
"RDEF STARTED ${instance-UKO_AGENT_STC_NAME}.* UACC(NONE)",
   " STDATA(USER("||AGENT_STC_USER||") PRIVILEGED(NO) TRUSTED(NO) TRACE(YES))"

"SETROPTS RACLIST(STARTED) REFRESH"

/***********************************************************************/
/* APPL class setup                                                    */
/***********************************************************************/

/* When an EKMF client user logs on to the UKO agent, a check for the  */
/* KMGPRACF resource is done in the APPL class. If KMGPRACF  */
/* is defined in the APPL class, then the EKMF client user ID  */
/* needs READ access. */

Say "Create KMGPRACF in the APPL class"
"RDEFINE APPL KMGPRACF UACC(NONE) OWNER("||AGENT_STC_GROUP||")"
Say "Granting access to KMGPRACF CLASS(APPL) web client userid "||AGENT_CLIENT_GROUP||" "
"PERMIT KMGPRACF CLASS(APPL) ID("||AGENT_CLIENT_GROUP||") ACC(READ)"

"SETROPTS RACLIST(APPL) REFRESH"

/***********************************************************************/
/* FACILITY class setup                                                */
/***********************************************************************/

/* The UKO agent <task-user> ID must have READ access  */
/* to KMG.EKMF.KMGPRACF to run an agent.  */

/* Allow access to UKO agent runtime and client access to agent */
Say "Defining KMG.EKMF.KMGPRACF class(FACILITY)"
"RDEFINE FACILITY KMG.EKMF.KMGPRACF UACC(NONE) OWNER("||AGENT_STC_GROUP||")"
Say "Granting access to agent task group "||AGENT_STC_GROUP||" "
"PERMIT KMG.EKMF.KMGPRACF CLASS(FACILITY) ID("||AGENT_STC_GROUP||") ACCESS(READ)"        

/* An EKMF <client-user> needs access to KMG.EKMF.KMGPRACF.<task-user>  */
/* to connect to a specific UKO agent which executes  */
/* using the <task-user> as user ID. */
Say "Creating KMG.EKMF.KMGPRACF.* in the FACILITY class"
"RDEFINE FACILITY KMG.EKMF.KMGPRACF.* UACC(NONE) OWNER("||AGENT_STC_GROUP||")"
Say "Creating KMG.EKMF.KMGPRACF."||AGENT_STC_USER||" in the FACILITY class"
"RDEFINE FACILITY KMG.EKMF.KMGPRACF."||AGENT_STC_USER||" UACC(NONE) OWNER("||AGENT_STC_GROUP||")"
Say "Granting access to web client user "||AGENT_CLIENT_GROUP||" "
"PERMIT KMG.EKMF.KMGPRACF."||AGENT_STC_USER||" CLASS(FACILITY) ID("||AGENT_CLIENT_GROUP||") ACCESS(READ)"

"SETROPTS RACLIST(FACILITY) REFRESH"
/***********************************************************************/
/* SMF Logging */
/***********************************************************************/
/* Create profile for UKO agent SMF logging, this is required */
/* even if SMF logging is not enabled */
Say "Creating KMG.EKMF.SMF in the FACILITY class to enable SMF logging"
"RDEFINE FACILITY KMG.EKMF.SMF UACC(NONE) AUDIT(ALL(READ))"
Say "Granting access to KMG.EKMF.SMF to "||AGENT_STC_GROUP||" "
"PERMIT KMG.EKMF.SMF CLASS(FACILITY) ID("||AGENT_STC_GROUP||") ACCESS(READ)"


#if(${instance-WORKSTATION_ACCESS_REQUIRED} && ${instance-WORKSTATION_ACCESS_REQUIRED} == "true")
/* Only for Workstation use: */
/* If the client user ID should be able to disable logging to SMF for */
/* EKMF events, the Agent user ID must be permitted to */ 
/* FACILITY resource KMG.EKMF.AUDITOFF*/
Say "Creating KMG.EKMF.AUDITOFF (FACILITY) to allow disabling of SMF logging"
"RDEFINE FACILITY KMG.EKMF.AUDITOFF UACC(NONE) AUDIT(ALL(READ))"
Say "Granting access to KMG.EKMF.AUDITOFF to "||AGENT_STC_GROUP||" "
"PERMIT KMG.EKMF.AUDITOFF CLASS(FACILITY) ID("||AGENT_STC_GROUP||") ACCESS(READ)"
Say "Granting access to KMG.EKMF.AUDITOFF to "||AGENT_CLIENT_GROUP||" "
"PERMIT KMG.EKMF.AUDITOFF CLASS(FACILITY) ID("||AGENT_CLIENT_GROUP||") ACCESS(READ)"
#end 

"SETROPTS RACLIST(FACILITY) REFRESH"

/***********************************************************************/
/* XFACILIT class setup */
/***********************************************************************/

/* The Agent requires access to KMG.WEBCLIENT.<client-user> */
/* in the XFACILIT class. The <client-user> must match  */
/* the value specified for the &WEBCLIENT parameter in KMGPARM. */
Say "Creating KMG.WEBCLIENT."||AGENT_CLIENT_USER||" in the XFACILIT class"
"RDEFINE XFACILIT KMG.WEBCLIENT."||AGENT_CLIENT_USER||" "
Say "Granting "||AGENT_STC_GROUP||" access to KMG.WEBCLIENT."||AGENT_CLIENT_USER||" "
"PERMIT KMG.WEBCLIENT."||AGENT_CLIENT_USER||" CLASS(XFACILIT)",
   " ACC(READ) ID("||AGENT_STC_GROUP||")"

"SETROPTS RACL(XFACILIT) REFRESH"

/* If ICSF keystore policy checking is active and the  */
/* CSF.PKDS.TOKEN.CHECK.DEFAULT.LABEL resource in XFACILIT class is  */
/* defined, the CSF-PKDS-DEFAULT resource in CSFKEYS class must also  */
/* be defined and the Agent's <task-user> needs access.*/

#if(${instance-WORKSTATION_ACCESS_REQUIRED} && ${instance-WORKSTATION_ACCESS_REQUIRED} == "true")
/***********************************************************************/
/* Granting access to Db2 DSNR */
/***********************************************************************/
Say "Defining BATCH profile in DSNR class"
"RDEFINE DSNR ${instance-DB2_JCC_SSID}.BATCH UACC(NONE)"
Say "Granting access to BATCH profile to "||AGENT_STC_USER||" "
"PERMIT ${instance-DB2_JCC_SSID}.BATCH CLASS(DSNR)",
   " ACCESS(READ) ID("||AGENT_STC_USER||")"                 

Say "Refreshing DSNR"
"SETROPTS RACLIST(DSNR) REFRESH"
#end

exit