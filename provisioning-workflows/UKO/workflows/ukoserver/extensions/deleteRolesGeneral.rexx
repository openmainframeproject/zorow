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
"PERMIT EKMFWEB.auditlog:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.keystores:list CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.keys:list CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.templates:list CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.vaults:list CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.meta:cache-rebuild CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.meta:logs-download CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"

Say "Delete Permissions from Key Custodian1"
"PERMIT EKMFWEB.datasets:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.keystores:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.keys:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.templates:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.vaults:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"

Say "Delete Permissions from Key Custodian2"
"PERMIT EKMFWEB.datasets:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.keystores:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.keys:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.templates:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.vaults:list CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"

Say "Delete Permissions from Auditor"
"PERMIT EKMFWEB.auditlog:read CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.datasets:read CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.keystores:list CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.keys:list CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.templates:list CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.vaults:list CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"


/* Refresh */
"SETROPTS RACLIST(EJBROLE) REFRESH"

exit