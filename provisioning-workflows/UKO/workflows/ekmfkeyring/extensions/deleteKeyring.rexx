/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/
/***********************************************************************/
/*                                                                     */
/* PLEASE READ                                                         */
/*                                                                     */
/* This script contains an example for deleting the dynamic keyring    */
/* and certificate as part of the deletion of an EKMF Web server.      */
/*                                                                     */
/* By default this script does nothing, as there is an 'exit 0'        */
/* statement directly under this comment.  Review the keyring and      */
/* certificate being deleted and remove the 'exit 0' if you wish to    */
/* use this script.                                                    */
/*                                                                     */
/***********************************************************************/

/* exit 0 */ 

WEB_TASK_USER="${instance-EKMF_WEB_TASK_USER}"
CA_LABEL="${instance-EKMF_CA_LABEL}"
/* Name of the server certificate */
TLS_KEY_STORE_SERVER_CERT="${instance-EKMF_TLS_KEY_STORE_SERVER_CERT}"
/* Name of the OpenID certificate */
OIDC_PROVIDER_CERT="${instance-EKMF_OIDC_PROVIDER_CERT}"
/* Name of the key ring */
TLS_KEY_STORE_KEY_RING="${instance-EKMF_TLS_KEY_STORE_KEY_RING}"
TLS_TRUST_STORE_KEY_RING="${instance-EKMF_TLS_TRUST_STORE_KEY_RING}"

/**********************************************************************/
/* Delete the KEYRING and the certificates                            */
/**********************************************************************/

#if($!{instance-EKMF_CREATE_CA} == "TRUE" ) 
"RACDCERT CERTAUTH DELETE",
    " (LABEL("||"'"||CA_LABEL||"'"||"))"
#end


#if($!{instance-EKMF_CREATE_CERTIFICATES} == "TRUE" ) 
Say "Delete TLS Server Certificate"
"RACDCERT ID("||WEB_TASK_USER||") DELETE",
    " (LABEL("||"'"||TLS_KEY_STORE_SERVER_CERT||"'"||"))"
Say "Delete OIDC provider Certificate"
"RACDCERT ID(${instance-EKMF_WEB_TASK_USER}) DELETE",
    " (LABEL("||"'"||OIDC_PROVIDER_CERT||"'"||"))"
#end

#if($!{instance-EKMF_CREATE_CA} == "TRUE" || $!{instance-EKMF_CREATE_CERTIFICATES} == "TRUE" ) 
Say "Refresh DIGTCERT"
"SETROPTS RACLIST(DIGTCERT) REFRESH"
#end

#if($!{instance-EKMF_CREATE_KEYRING} == "TRUE" ) 
Say "Delete key ring"
"RACDCERT DELRING("||TLS_KEY_STORE_KEY_RING||")",
    " ID(${instance-EKMF_WEB_TASK_USER})"
Say "Refresh DIGTRING"
"SETROPTS RACLIST(DIGTRING) REFRESH"
Say "Remove key ring entry from RDATALIB"
"RDELETE RDATALIB",
   " ${instance-EKMF_WEB_TASK_USER}."||TLS_KEY_STORE_KEY_RING||".LST"
Say "Refresh RDATALIB"
"SETROPTS RACLIST(RDATALIB) REFRESH"

   #if($!{instance-EKMF_TLS_KEY_STORE_KEY_RING} != $!{instance-EKMF_TLS_TRUST_STORE_KEY_RING} )
Say "Delete trust ring"
"RACDCERT DELRING("||TLS_TRUST_STORE_KEY_RING||")",
    " ID(${instance-EKMF_WEB_TASK_USER})"
Say "Refresh DIGTRING"
"SETROPTS RACLIST(DIGTRING) REFRESH"
Say "Remove trust ring entry from RDATALIB"
"RDELETE RDATALIB",
   " ${instance-EKMF_WEB_TASK_USER}."||TLS_TRUST_STORE_KEY_RING||".LST"
Say "Refresh RDATALIB"
"SETROPTS RACLIST(RDATALIB) REFRESH"

    #end
#end

#if($!{instance-EKMF_CREATE_USERIDS} == "TRUE" ) 
Say "Removing access to IRR.DIGTCERT.LISTRING profile from "||WEB_TASK_USER||" "
"PERMIT IRR.DIGTCERT.LISTRING CLASS(FACILITY)",
   " DELETE ID("||WEB_TASK_USER||")"                 
Say "Refreshing Facility"
"SETROPTS RACLIST(FACILITY) REFRESH"
#end

