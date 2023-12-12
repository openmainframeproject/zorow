/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

AGENT_STC_USER="${instance-UKO_AGENT_STC_USER}"
AGENT_STC_GROUP="${instance-UKO_AGENT_STC_GROUP}"

AGENT_CLIENT_USER="${instance-UKO_AGENT_CLIENT_USER}"
AGENT_CLIENT_GROUP="${instance-UKO_AGENT_CLIENT_GROUP}"

SERVER_STC_USER="${instance-UKO_SERVER_STC_USER}"
SERVER_STC_GROUP="${instance-UKO_SERVER_STC_GROUP}"

SERVER_UNAUTHENTICATED_USER="${instance-UKO_UNAUTHENTICATED_USER}"
SERVER_UNAUTHENTICATED_GROUP="${instance-UKO_UNAUTHENTICATED_GROUP}"


#if($!{instance-UKO_CREATE_TECHNICAL_GROUPS} == "true" ) 
/***********************************************************************/
/* Creating the required groups                                        */
/***********************************************************************/
Say "Creating the required groups"
Say "Creating the Agent started task group"
"ADDGROUP "||AGENT_STC_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the Client group for authentication with the agent"
"ADDGROUP "||AGENT_CLIENT_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the Liberty started task group"
"ADDGROUP "||SERVER_STC_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
Say "Creating the unauthenticated user group for the Liberty server"
"ADDGROUP "||SERVER_UNAUTHENTICATED_GROUP||" SUPGROUP(SYS1) OMVS(AUTOGID)"
#end

#if($!{instance-UKO_CREATE_TECHNICAL_USERIDS} == "true" ) 
/***********************************************************************/
/* Creating all required user ids                                      */
/***********************************************************************/
Say "Creating the Agent started task user ID and group"
"ADDUSER "||AGENT_STC_USER||" NOPASSWORD",
   " DFLTGRP("||AGENT_STC_GROUP||") NAME('UKO agent')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||AGENT_STC_USER||"'"||"))"

Say "Creating the Client user for authentication with the agent"
"ADDUSER "||AGENT_CLIENT_USER||" NOPASSWORD",
   " DFLTGRP("||AGENT_CLIENT_GROUP||") NAME('UKO Client')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||AGENT_CLIENT_USER||"'"||"))"

Say "Creating the Liberty started task user ID and group"
"ADDUSER "||SERVER_STC_USER||" NOPASSWORD",
   " DFLTGRP("||SERVER_STC_GROUP||") NAME('UKO Liberty SERVER')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||SERVER_STC_USER||"'"||"))"

Say "Adding the unauthenticated user ID for the Liberty server (WSGUEST by default)"
"ADDUSER "||SERVER_UNAUTHENTICATED_USER||" RESTRICTED NOOIDCARD NOPASSWORD",
   " DFLTGRP("||SERVER_UNAUTHENTICATED_GROUP||") NAME('WAS DEFAULT USER')",
   " OMVS(AUTOUID PROGRAM('/bin/sh')",
   " HOME("||"'"||"/u/"||SERVER_UNAUTHENTICATED_USER||"'"||")) "

#end 


