/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

KEY_ADMIN="${instance-EKMF_KEY_ADMIN_GROUP}"

/***********************************************************************/
/* Key admin, who sets up the key hierarchy, and controls keystores    */
/* and templates, as well as performs special key state actions.       */
/***********************************************************************/

Say "Removing Permissions from Key Administrator"
"PERMIT EKMFWEB.ekmf-rest-api.auditlog:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.integrity:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:change_expiration CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:install CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:update CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:compromised:unmark_compromised CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:compromised:update CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:reactivate CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:delete CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:destroyed_compromised:remove CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:destroyed:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:destroyed:remove CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:distribute CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:non_existing:import CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:non_existing:generate CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:activate CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:change_expiration CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:uninstall CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:update CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.logs:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.settings:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:delete CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"

/* Refresh */
"SETROPTS RACLIST(EJBROLE) REFRESH"

exit