/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

ZKEY_GROUP="${instance-UKO_ZKEY_CLIENT_GROUP}"
/***********************************************************************/
/* Creating EJB Roles for ZKEY access */
/***********************************************************************/

"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.keys:export UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.keys:write:exportControl UACC(NONE)" 
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.keys:write:exportControl:allowedKeys:add UACC(NONE)" 
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.keys:write:exportControl:allowedKeys:remove UACC(NONE)" 
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.user:passcode:create UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.user:passcode:delete UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.certificates:import UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.certificates:import:untrusted UACC(NONE)"


"PERMIT EJBROLE EKMFWEB.ekmf-rest-api.keys:exportCLASS(EJBROLE) ACCESS(READ) ID("||ZKEY_GROUP||")"
"PERMIT EJBROLE EKMFWEB.ekmf-rest-api.keys:write:exportControlCLASS(EJBROLE) ACCESS(READ) ID("||ZKEY_GROUP||")" 
"PERMIT EJBROLE EKMFWEB.ekmf-rest-api.keys:write:exportControl:allowedKeys:addCLASS(EJBROLE) ACCESS(READ) ID("||ZKEY_GROUP||")" 
"PERMIT EJBROLE EKMFWEB.ekmf-rest-api.keys:write:exportControl:allowedKeys:removeCLASS(EJBROLE) ACCESS(READ) ID("||ZKEY_GROUP||")" 
"PERMIT EJBROLE EKMFWEB.ekmf-rest-api.user:passcode:createCLASS(EJBROLE) ACCESS(READ) ID("||ZKEY_GROUP||")"
"PERMIT EJBROLE EKMFWEB.ekmf-rest-api.user:passcode:deleteCLASS(EJBROLE) ACCESS(READ) ID("||ZKEY_GROUP||")"
"PERMIT EJBROLE EKMFWEB.ekmf-rest-api.certificates:importCLASS(EJBROLE) ACCESS(READ) ID("||ZKEY_GROUP||")"
"PERMIT EJBROLE EKMFWEB.ekmf-rest-api.certificates:import:untrustedCLASS(EJBROLE) ACCESS(READ) ID("||ZKEY_GROUP||")"

"SETROPTS REFRESH RACLIST(EJBROLE)"

"PERMIT EKMFWEB CLASS(APPL) ACCESS(READ) ID("||ZKEY_GROUP||")"
"SETROPTS REFRESH RACLIST(APPL)" 