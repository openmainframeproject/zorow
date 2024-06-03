/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

GKLM_GROUP="${instance-UKO_GKLM_CLIENT_GROUP}"
/***********************************************************************/
/* Creating EJB Roles for GKLM access */
/***********************************************************************/

"PERMIT EKMFWEB.ekmf-rest-api.keys:generate CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:read CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:write CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:delete CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:distribute CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:non_existing:generate CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:activate CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:update CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:deactivate CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:install CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:uninstall CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:destroy CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:destroyed:remove CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:destroyed_compromised:remove CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:destroyed:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:read CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:write CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:read CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.crypto-connect.operations:data:encrypt CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"
"PERMIT EKMFWEB.crypto-connect.operations:data:decrypt CLASS(EJBROLE) ACCESS(READ) ID("||GKLM_GROUP||")"

"SETROPTS REFRESH RACLIST(EJBROLE)"

"PERMIT EKMFWEB CLASS(APPL) ACCESS(READ) ID("||GKLM_GROUP||")"
"SETROPTS REFRESH RACLIST(APPL)" 