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

#if($!{instance-UKO_CREATE_TECHNICAL_USERIDS} == "TRUE" ) 
"DELUSER "||AGENT_STC_USER||" "
"DELUSER "||AGENT_CLIENT_USER||" "
"DELUSER "||SERVER_STC_USER||" "
"DELUSER "||SERVER_UNAUTHENTICATED_USER||" "

#end

#if($!{instance-UKO_CREATE_TECHNICAL_GROUPS} == "TRUE" ) 
"DELGROUP "||AGENT_STC_GROUP||" "
"DELGROUP "||AGENT_CLIENT_GROUP||" "
"DELGROUP "||SERVER_STC_GROUP||" "
"DELGROUP "||SERVER_UNAUTHENTICATED_GROUP||" "
#end



