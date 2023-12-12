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
/* Creating EJB Roles specific for the vault key management */
/***********************************************************************/

Say "Defing roles for the vauld ID: "||VAULT_ID||" "
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".integrity:write UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".settings:write UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:deactivate UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:install UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:mark_compromised UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:uninstall UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:destroy UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:install UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:uninstall UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:unmark_compromised UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:destroy UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:install UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:mark_compromised UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:reactivate UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:uninstall UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:delete UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed:mark_compromised UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:distribute UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:generate UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:non_existing:generate UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:non_existing:import UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:activate UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:destroy UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:mark_compromised UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:uninstall UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:dates UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:tags UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:delete UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:write UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:delete UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:write UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:delete UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read UACC(NONE)"
"RDEFINE EJBROLE EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:write UACC(NONE)"


/***********************************************************************/
/* Key admin, who sets up the key hierarchy, and controls keystores    */
/* and templates, as well as performs special key state actions.       */
/***********************************************************************/

Say "Grant Permissions to Key Administrator "||KEY_ADMIN||" "
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".integrity:write CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".settings:write CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:install CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:reactivate CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:non_existing:import CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
/* to be able to create the KEKs */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:non_existing:generate CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:delete CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:write CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:delete CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:write CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:delete CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:write CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:delete CLASS(EJBROLE) ACCESS(READ) ID("||KEY_ADMIN||")"

Say "Grant Permissions to Key Custodian1 "||KEY_CUSTODIAN1||" "
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:deactivate CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:uninstall CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:destroy CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:uninstall CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:unmark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:destroy CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:uninstall CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:destroy CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:uninstall CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:distribute CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:delete CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"

/* only custodian 1 is allowed to generate keys */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:generate CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:non_existing:generate CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"

/* only custodian 1 is allowed to change dates and tags, after a key is created */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:dates CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:tags CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"

Say "Grant Permissions to Key Custodian2 "||KEY_CUSTODIAN2||" "
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:deactivate CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:uninstall CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:destroy CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:uninstall CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:unmark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:destroy CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:uninstall CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:destroy CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:uninstall CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN1||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:destroyed:mark_compromised CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:distribute CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
/* "PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:dates CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")" */
/* "PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:write:tags CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")" */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:delete CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"

"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"

/* only custodian 2 is allowed to install or activate keys */
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:active:install CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:compromised:install CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:deactivated:install CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:pre_activation:activate CLASS(EJBROLE) ACCESS(READ) ID("||KEY_CUSTODIAN2||")"

Say "Grant Permissions to Auditor "||UKO_AUDITOR||" "
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keys:read CLASS(EJBROLE) ACCESS(READ) ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".keystores:read CLASS(EJBROLE) ACCESS(READ) ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".templates:read CLASS(EJBROLE) ACCESS(READ) ID("||UKO_AUDITOR||")"
"PERMIT EKMFWEB.ekmf-rest-api."||VAULT_ID||".vaults:read CLASS(EJBROLE) ACCESS(READ) ID("||UKO_AUDITOR||")"

/* Refresh */
"SETROPTS RACLIST(EJBROLE) REFRESH"

exit



