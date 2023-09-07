/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

SERVER_STC_USER="${instance-UKO_SERVER_STC_USER}"
CA_LABEL="${instance-UKO_CA_LABEL}"
/* Name of the server certificate */
TLS_KEY_STORE_SERVER_CERT="${instance-UKO_TLS_KEY_STORE_SERVER_CERT}"
/* Name of the OpenID certificate */
OIDC_PROVIDER_CERT="${instance-UKO_OIDC_PROVIDER_CERT}"
/* Name of the key ring */
TLS_KEY_STORE_KEY_RING="${instance-UKO_TLS_KEY_STORE_KEY_RING}"
TLS_TRUST_STORE_KEY_RING="${instance-UKO_TLS_TRUST_STORE_KEY_RING}"

/**********************************************************************/
/* Delete the KEYRING and the certificates                            */
/**********************************************************************/

#if($!{instance-UKO_CREATE_CA} == "true" ) 
"RACDCERT CERTAUTH DELETE",
    " (LABEL("||"'"||CA_LABEL||"'"||"))"
#end


#if($!{instance-UKO_CREATE_CERTIFICATES} == "true" ) 
Say "Delete TLS Server Certificate"
"RACDCERT ID("||SERVER_STC_USER||") DELETE",
    " (LABEL("||"'"||TLS_KEY_STORE_SERVER_CERT||"'"||"))"
Say "Delete OIDC provider Certificate"
"RACDCERT ID(${instance-UKO_SERVER_STC_USER}) DELETE",
    " (LABEL("||"'"||OIDC_PROVIDER_CERT||"'"||"))"
#end

#if($!{instance-UKO_CREATE_CA} == "true" || $!{instance-UKO_CREATE_CERTIFICATES} == "true" ) 
Say "Refresh DIGTCERT"
"SETROPTS RACLIST(DIGTCERT) REFRESH"
#end

#if($!{instance-UKO_CREATE_KEYRING} == "true" ) 
Say "Delete key ring"
"RACDCERT DELRING("||TLS_KEY_STORE_KEY_RING||")",
    " ID(${instance-UKO_SERVER_STC_USER})"
Say "Refresh DIGTRING"
"SETROPTS RACLIST(DIGTRING) REFRESH"
Say "Remove key ring entry from RDATALIB"
"RDELETE RDATALIB",
   " ${instance-UKO_SERVER_STC_USER}."||TLS_KEY_STORE_KEY_RING||".LST"
Say "Refresh RDATALIB"
"SETROPTS RACLIST(RDATALIB) REFRESH"

   #if($!{instance-UKO_TLS_KEY_STORE_KEY_RING} != $!{instance-UKO_TLS_TRUST_STORE_KEY_RING} )
Say "Delete trust ring"
"RACDCERT DELRING("||TLS_TRUST_STORE_KEY_RING||")",
    " ID(${instance-UKO_SERVER_STC_USER})"
Say "Refresh DIGTRING"
"SETROPTS RACLIST(DIGTRING) REFRESH"
Say "Remove trust ring entry from RDATALIB"
"RDELETE RDATALIB",
   " ${instance-UKO_SERVER_STC_USER}."||TLS_TRUST_STORE_KEY_RING||".LST"
Say "Refresh RDATALIB"
"SETROPTS RACLIST(RDATALIB) REFRESH"

    #end
#end

#if($!{instance-UKO_CREATE_TECHNICAL_USERIDS} == "true" ) 
Say "Removing access to IRR.DIGTCERT.LISTRING profile from "||SERVER_STC_USER||" "
"PERMIT IRR.DIGTCERT.LISTRING CLASS(FACILITY)",
   " DELETE ID("||SERVER_STC_USER||")"                 
Say "Refreshing Facility"
"SETROPTS RACLIST(FACILITY) REFRESH"
#end

