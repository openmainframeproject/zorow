/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/
/***********************************************************************/
/* Define dynamic security profiles for the server                     */
/***********************************************************************/

/***********************************************************************/
/*                                                                     */
/* PLEASE READ                                                         */
/*                                                                     */
/* This script contains example security profiles for dynamically      */
/* configuring security as part of the creation of an EKMF Web         */
/* server.                                                             */
/*                                                                     */
/* By default this script does nothing, as there is an 'exit 0'        */
/* statement directly under this comment.  Review the profiles being   */
/* created and remove the 'exit 0' if you wish to use this script.     */
/*                                                                     */
/***********************************************************************/

AGENT_TASK_USER="${instance-EKMF_AGENT_TASK_USER}"
AGENT_TASK_GROUP="${instance-EKMF_AGENT_TASK_GROUP}"

WEB_CLIENT_USER="${instance-EKMF_CLIENT_USER}"
WEB_CLIENT_GROUP="${instance-EKMF_CLIENT_GROUP}"

/***********************************************************************/
/* Setup the STARTED task for this server                              */
/***********************************************************************/
Say "Defining STARTED task for the agent"
"RDEF STARTED ${instance-EKMF_AGENT_STC}.* UACC(NONE)",
   " STDATA(USER("||AGENT_TASK_USER||") PRIVILEGED(NO) TRUSTED(NO) TRACE(YES))"

"SETROPTS RACLIST(STARTED) REFRESH"

/***********************************************************************/
/* APPL class setup                                                    */
/***********************************************************************/
Say "Define the server specific APPLID to RACF"
"RDEFINE APPL EKMFWEB UACC(NONE)"

Say "Activating the APPL class"
/* If not active, the domain is not restricted, which means anyone can authenticate to it */
"SETROPTS CLASSACT(APPL)"

Say "Grant the web client user "||WEB_CLIENT_USER||" READ access to the profile in the APPL class"
"PERMIT EKMFWEB CLASS(APPL)",
   " ACCESS(READ) ID("||WEB_CLIENT_USER||")"

/* When an EKMF client user logs on to the EKMF Agent, a check for the  */
/* KMGPRACF resource is done in the APPL class. If KMGPRACF  */
/* is defined in the APPL class, then the EKMF client user ID  */
/* needs READ access. */

Say "Create KMGPRACF in the APPL class"
"RDEFINE APPL KMGPRACF UACC(NONE) OWNER("||AGENT_TASK_GROUP||")"
Say "Granting access to KMGPRACF CLASS(APPL) web client userid "||WEB_CLIENT_USER||" "
"PERMIT KMGPRACF CLASS(APPL) ID("||WEB_CLIENT_USER||") ACC(READ)"

"SETROPTS RACLIST(APPL) REFRESH"

/***********************************************************************/
/* FACILITY class setup                                                */
/***********************************************************************/

/* The EKMF Agent <task-user> ID must have READ access  */
/* to KMG.EKMF.KMGPRACF to run an agent.  */

/* Allow access to EKMF Agent runtime and client access to agent */
Say "Defining KMG.EKMF.KMGPRACF class(FACILITY)"
"RDEFINE FACILITY KMG.EKMF.KMGPRACF UACC(NONE) OWNER("||AGENT_TASK_GROUP||")"
Say "Granting access to agent task group "||AGENT_TASK_GROUP||" "
"PERMIT KMG.EKMF.KMGPRACF CLASS(FACILITY) ID("||AGENT_TASK_GROUP||") ACCESS(READ)"        

/* An EKMF <client-user> needs access to KMG.EKMF.KMGPRACF.<task-user>  */
/* to connect to a specific EKMF Agent which executes  */
/* using the <task-user> as user ID. */
Say "Creating KMG.EKMF.KMGPRACF.* in the FACILITY class"
"RDEFINE FACILITY KMG.EKMF.KMGPRACF.* UACC(NONE) OWNER("||AGENT_TASK_GROUP||")"
Say "Creating KMG.EKMF.KMGPRACF."||AGENT_TASK_USER||" in the FACILITY class"
"RDEFINE FACILITY KMG.EKMF.KMGPRACF."||AGENT_TASK_USER||" UACC(NONE) OWNER("||AGENT_TASK_GROUP||")"
Say "Granting access to web client user "||WEB_CLIENT_USER||" "
"PERMIT KMG.EKMF.KMGPRACF."||AGENT_TASK_USER||" CLASS(FACILITY) ID("||WEB_CLIENT_USER||") ACCESS(READ)"

"SETROPTS RACLIST(FACILITY) REFRESH"
/***********************************************************************/
/* SMF Logging */
/***********************************************************************/
/* Create profile for EKMF Agent SMF logging, this is required */
/* even if SMF logging is not enabled */
Say "Creating KMG.EKMF.SMF in the FACILITY class to enable SMF logging"
"RDEFINE FACILITY KMG.EKMF.SMF UACC(NONE) AUDIT(ALL(READ))"
Say "Granting access to KMG.EKMF.SMF to "||AGENT_TASK_GROUP||" "
"PERMIT KMG.EKMF.SMF CLASS(FACILITY) ID("||AGENT_TASK_GROUP||") ACCESS(READ)"

"SETROPTS RACLIST(FACILITY) REFRESH"

/***********************************************************************/
/* XFACILIT class setup */
/***********************************************************************/

/* The Agent requires access to KMG.WEBCLIENT.<client-user> */
/* in the XFACILIT class. The <client-user> must match  */
/* the value specified for the &WEBCLIENT parameter in KMGPARM. */
Say "Creating KMG.WEBCLIENT."||WEB_CLIENT_USER||" in the XFACILIT class"
"RDEFINE XFACILIT KMG.WEBCLIENT."||WEB_CLIENT_USER||" "
Say "Granting "||AGENT_TASK_GROUP||" access to KMG.WEBCLIENT."||WEB_CLIENT_USER||" "
"PERMIT KMG.WEBCLIENT."||WEB_CLIENT_USER||" CLASS(XFACILIT)",
   " ACC(READ) ID("||AGENT_TASK_GROUP||")"

"SETROPTS RACL(XFACILIT) REFRESH"

/* If ICSF keystore policy checking is active and the  */
/* CSF.PKDS.TOKEN.CHECK.DEFAULT.LABEL resource in XFACILIT class is  */
/* defined, the CSF-PKDS-DEFAULT resource in CSFKEYS class must also  */
/* be defined and the the Agent's <task-user> needs access.*/

/***********************************************************************/
/* Diffie-Hellman */
/***********************************************************************/

/* The EKMF Agent will accept the client's public key token by having */
/* access to the XFACILIT class resources */
/* KMG.WS.<publicKeyHash> and KMG.LG.<publicKeyHash> */
/* RDEFINE XFACILIT KMG.WS.<publicKeyHash> */
/* PERMIT KMG.WS.<publicKeyHash> CLASS(XFACILIT) ACC(READ) ID("||AGENT_TASK_GROUP||") */
/* TODO: replace generic profile with actual publicKeyHash*/
Say "Granting access to KMG.WS.* class(XFACILIT) to "||AGENT_TASK_GROUP||" "
"PERMIT KMG.WS.* CLASS(XFACILIT) ACC(READ) ID("||AGENT_TASK_GROUP||")"

/* RDEFINE XFACILIT KMG.LG.<publicKeyHash> */
/* PERMIT KMG.LG.<publicKeyHash> CLASS(XFACILIT) ACC(READ) ID("||AGENT_TASK_GROUP||") */
/* TODO: replace generic profile with actual publicKeyHash*/
Say "Granting access to KMG.LG.* class(XFACILIT) to "||AGENT_TASK_GROUP||" "
"PERMIT KMG.LG.* CLASS(XFACILIT) ACC(READ) ID("||AGENT_TASK_GROUP||")"

"SETROPTS RACL(XFACILIT) REFRESH"


exit