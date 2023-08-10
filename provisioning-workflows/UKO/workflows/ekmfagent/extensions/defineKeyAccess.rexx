/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/
/***********************************************************************/
/* Define dynamic security profiles for the server                     */
/***********************************************************************/

AGENT_TASK_USER="${instance-EKMF_AGENT_TASK_USER}"
RACF_OWNER="${instance-EKMF_ADMIN_SECURITY}"

/* If &SYS-ECCSIGN-PREFIX and &SYS-RSAKEK-PREFIX are defined in KMGPARM, */
/* the agent needs access to the keys. */
/* In addition, the agent needs access to the PE keys that need to be */
/* installed into the CKDS*/
KEY_PREFIX="${instance-EKMF_KEY_PREFIX}"

Say "Defining key prefix profile "||KEY_PREFIX||".** in case this has not been done"
"RDEF CSFKEYS "||KEY_PREFIX||".** OWNER("||RACF_OWNER||") UACC(NONE) ICSF(SYMCPACFWRAP(YES),SYMCPACFRET(YES))"
Say "Granting access to "||AGENT_TASK_USER||" on "||KEY_PREFIX||" "
"PERMIT "||KEY_PREFIX||".**  CLASS(CSFKEYS) ACCESS(CONTROL) ID("||AGENT_TASK_USER||")"

Say "Refreshing CSFKEYS"
"SETROPTS RACLIST(CSFKEYS) REFRESH"

exit