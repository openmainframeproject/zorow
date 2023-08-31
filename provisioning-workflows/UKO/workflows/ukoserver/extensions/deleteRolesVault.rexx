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

Say "Remove Permissions from Key Administrator"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".integrity:write CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".settings:write CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:install CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:reactivate CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:non_existing:import CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:delete CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:write CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:delete CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:write CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:delete CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:write CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"

/* to be verified for admin */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:change_expiration CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:update CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:unmark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:update CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:update CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed_compromised:remove CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed:remove CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:change_expiration CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:update CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:dates CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:tags CLASS(EJBROLE) REMOVE ID("||KEY_ADMIN||")"

Say "Remove Permissions from Key Custodian1"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".certificates:import CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".certificates:import:untrusted CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:deactivate CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:mark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:uninstall CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:destroy CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:uninstall CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:destroy CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:mark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:uninstall CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed:mark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:destroy CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:mark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:uninstall CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:distribute CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:generate CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:non_existing:generate CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:delete CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"

/* to be verified for custodian 1 */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:change_expiration CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:update CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:unmark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:update CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:update CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed_compromised:remove CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed:remove CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:change_expiration CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:update CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:dates CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:tags CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"

Say "Remove Permissions from Key Custodian2"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".certificates:import CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".certificates:import:untrusted CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:deactivate CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:install CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:mark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:uninstall CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:destroy CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:install CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:uninstall CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:destroy CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:install CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:mark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:uninstall CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:activate CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:destroy CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:mark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:uninstall CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed:mark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:distribute CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:delete CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"

/* to be verified for custodian 2*/

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:change_expiration CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:update CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:unmark_compromised CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:update CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:update CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed_compromised:remove CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed:remove CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:change_expiration CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:update CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:dates CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:tags CLASS(EJBROLE) REMOVE ID("||KEY_CUSTODIAN2||")"

Say "Remove Permissions from Auditor"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) REMOVE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) REMOVE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) REMOVE ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) REMOVE ID("||UKO_AUDITOR||")"

/* Refresh */
"SETROPTS RACLIST(EJBROLE) REFRESH"

exit