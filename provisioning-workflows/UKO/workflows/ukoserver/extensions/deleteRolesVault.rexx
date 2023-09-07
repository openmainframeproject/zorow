/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

KEY_ADMIN="${instance-UKO_KEY_ADMIN_GROUP}"
KEY_CUSTODIAN1="${instance-UKO_KEY_CUSTODIAN1_GROUP}"
KEY_CUSTODIAN2="${instance-UKO_KEY_CUSTODIAN2_GROUP}"
UKO_AUDITOR="${instance-UKO_AUDITOR_GROUP}"
VAULT_ID="${instance-UKO_VAULT_ID}"
/***********************************************************************/
/* Key admin, who sets up the key hierarchy, and controls keystores    */
/* and templates, as well as performs special key state actions.       */
/***********************************************************************/

Say "Remove Permissions from Key Administrator "||KEY_ADMIN||" "
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".integrity:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".settings:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:install CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:reactivate CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:non_existing:import CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:non_existing:generate CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:delete CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:delete CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:delete CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:write CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:delete CLASS(EJBROLE) DELETE ID("||KEY_ADMIN||")"

Say "Remove Permissions from Key Custodian1 "||KEY_CUSTODIAN1||" "
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:deactivate CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:unmark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:distribute CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:delete CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"

/* only custodian 1 is allowed to generate keys */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:generate CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:non_existing:generate CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"

/* only custodian 1 is allowed to change dates and tags, after a key is created */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:dates CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:tags CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"

Say "Remove Permissions from Key Custodian2 "||KEY_CUSTODIAN2||" "
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:deactivate CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:unmark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:destroy CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:uninstall CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed:mark_compromised CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:distribute CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
/* "PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:dates CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")" */
/* "PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:tags CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")" */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:delete CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"

/* only custodian 2 is allowed to install or activate keys */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:install CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:install CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:install CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:activate CLASS(EJBROLE) DELETE ID("||KEY_CUSTODIAN2||")"

Say "Remove Permissions from Auditor "||UKO_AUDITOR||" "
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) DELETE ID("||UKO_AUDITOR||")"

/* Refresh */
"SETROPTS RACLIST(EJBROLE) REFRESH"

exit