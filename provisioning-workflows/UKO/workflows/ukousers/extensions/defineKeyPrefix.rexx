/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

/***********************************************************************/
/* Creating the required user IDs and groups                           */
/***********************************************************************/

KEY_PREFIX="${instance-UKO_KEY_PREFIX}"

Say "Defining key prefix profile "||KEY_PREFIX||".** "
"RDEF CSFKEYS "||KEY_PREFIX||".** UACC(NONE) ICSF(SYMCPACFWRAP(YES),SYMCPACFRET(YES))"
"PERMIT "||KEY_PREFIX||".**  CLASS(CSFKEYS) ACCESS(CONTROL) ID(ACSPSGRP)"

Say "Refreshing CSFKEYS"
"SETROPTS RACLIST(CSFKEYS) REFRESH"
