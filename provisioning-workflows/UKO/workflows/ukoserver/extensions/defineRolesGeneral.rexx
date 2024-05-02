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
/* Creating genera EJB Roles */
/***********************************************************************/

"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.keystores:list UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.keys:list UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.templates:list UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.vaults:list UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.datasets:read UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.auditlog:read UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.meta:cache-rebuild UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api.meta:logs-download UACC(NONE)"


/***********************************************************************/
/* Key admin, who sets up the key hierarchy, and controls keystores    */
/* and templates, as well as performs special key state actions.       */
/***********************************************************************/

Say "Grant Permissions to Key Administrator"
"PERMIT EKMFWEB.ekmf-rest-api.auditlog:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.meta:cache-rebuild CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api.meta:logs-download CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"

Say "Grant Permissions to Key Custodian1"
"PERMIT EKMFWEB.ekmf-rest-api.datasets:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"

Say "Grant Permissions to Key Custodian2"
"PERMIT EKMFWEB.ekmf-rest-api.datasets:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:list CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"

Say "Grant Permissions to Auditor"
"PERMIT EKMFWEB.ekmf-rest-api.auditlog:read CLASS(EJBROLE) ACCESS(READ) ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.datasets:read CLASS(EJBROLE) ACCESS(READ) ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.keystores:list CLASS(EJBROLE) ACCESS(READ) ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.keys:list CLASS(EJBROLE) ACCESS(READ) ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.templates:list CLASS(EJBROLE) ACCESS(READ) ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api.vaults:list CLASS(EJBROLE) ACCESS(READ) ID("||UKO_AUDITOR||")"

/* Refresh */
"SETROPTS RACLIST(EJBROLE) REFRESH"

exit