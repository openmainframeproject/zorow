/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

KEY_ADMIN="${instance-UKO_KEY_ADMIN_GROUP}"
KEY_CUSTODIAN1="${instance-UKO_KEY_CUSTODIAN1_GROUP}"
KEY_CUSTODIAN2="${instance-UKO_KEY_CUSTODIAN2_GROUP}"
UKO_AUDITOR="${instance-UKO_AUDITOR_GROUP}"

/***********************************************************************/
/* deleting access from the different user roles                         */
/***********************************************************************/

Say "Delete Permissions from Key Administrator "||KEY_ADMIN||" "
"PERMIT EKMFWEB.ekmf-rest-api.auditlog:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:install CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:reactivate CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:non_existing:import CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.logs:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.settings:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"

Say "Delete Permissions from Key Custodian1 "||KEY_CUSTODIAN1||" "
"PERMIT EKMFWEB.ekmf-rest-api.datasets:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:deactivate CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:compromised:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:compromised:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:destroyed:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:distribute CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:generate CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:non_existing:generate CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:write CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.certificates:import CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.certificates:import:untrusted CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"

Say "Delete Permissions from Key Custodian1 "||KEY_CUSTODIAN2||" "
"PERMIT EKMFWEB.ekmf-rest-api.datasets:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:deactivate CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:install CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:active:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:compromised:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:compromised:install CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:compromised:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:install CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:deactivated:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:destroyed:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:distribute CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:activate CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:pre_activation:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:write CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.certificates:import CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.certificates:import:untrusted CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"

Say "Delete Permissions from Key Custodian1 "||KEY_AUDITOR||" "
"PERMIT EKMFWEB.ekmf-rest-api.auditlog:read CLASS(EJBROLE) DELETE ID("||KEY_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.datasets:read CLASS(EJBROLE) DELETE ID("||KEY_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:read CLASS(EJBROLE) DELETE ID("||KEY_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:read CLASS(EJBROLE) DELETE ID("||KEY_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:read CLASS(EJBROLE) DELETE ID("||KEY_AUDITOR||")"

/* Refresh */
"SETROPTS RACLIST(EJBROLE) REFRESH"

exit