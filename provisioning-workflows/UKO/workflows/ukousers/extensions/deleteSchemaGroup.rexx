/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

DB_CURRENT_SCHEMA="${instance-DB_CURRENT_SCHEMA}"

#if($!{instance-UKO_CREATE_TECHNICAL_USERIDS} == "TRUE" ) 

"REMOVE  ${instance-UKO_ADMIN_DB} GROUP("||DB_CURRENT_SCHEMA||")"
"DELGROUP "||DB_CURRENT_SCHEMA||" " 

#end

