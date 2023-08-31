/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

/***********************************************************************/
/* Creating the required groups for the schema                         */
/***********************************************************************/

AGENT_STC_USER="${instance-UKO_AGENT_STC_USER}"
SERVER_STC_USER="${instance-UKO_SERVER_STC_USER}"
SERVER_UNAUTHENTICATED_USER="${instance-UKO_UNAUTHENTICATED_USER}"

DB_CURRENT_SCHEMA="${instance-DB_CURRENT_SCHEMA}"


Say "Creating the database group"
"ADDGROUP "||DB_CURRENT_SCHEMA||" SUPGROUP(CCCAGRP) OMVS(AUTOGID)"
"CONNECT  "||SERVER_UNAUTHENTICATED_USER||" GROUP("||DB_CURRENT_SCHEMA||")",
   " AUTH(USE) UACC(NONE)"
"CONNECT  "||SERVER_STC_USER||" GROUP("||DB_CURRENT_SCHEMA||")",
   " AUTH(USE) UACC(NONE)"
"CONNECT  "||AGENT_STC_USER||" GROUP("||DB_CURRENT_SCHEMA||")",
   " AUTH(USE) UACC(NONE)"
"CONNECT  ${instance-UKO_ADMIN_DB} GROUP("||DB_CURRENT_SCHEMA||")",
   " AUTH(USE) UACC(NONE)"


