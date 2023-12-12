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

Say "Delete Permissions from Key Administrator"
"PERMIT EKMFWEB.ekmf-rest-api.auditlog:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:list CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:list CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:list CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:list CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.meta:cache-rebuild CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.meta:logs-download CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"

Say "Delete Permissions from Key Custodian1"
"PERMIT EKMFWEB.ekmf-rest-api.datasets:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"

Say "Delete Permissions from Key Custodian2"
"PERMIT EKMFWEB.ekmf-rest-api.datasets:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"

Say "Delete Permissions from Auditor"
"PERMIT EKMFWEB.ekmf-rest-api.auditlog:read CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.datasets:read CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:list CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:list CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:list CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:list CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"


/* Refresh */
"SETROPTS RACLIST(EJBROLE) REFRESH"

exit