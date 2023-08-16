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


#if($!{instance-UKO_CREATE_KEYRING} != "TRUE" && $!{instance-UKO_CREATE_CERTIFICATES} != "TRUE")
/* if certificates and key ring are already existing, assume that the certificates */
/* have been added to the key ring*/
#else 
/* Connect certificates to keyring */
Say "Connect TLS server  certificate to key ring"
"RACDCERT ID("||SERVER_STC_USER||")",
   " CONNECT(LABEL("||"'"||TLS_KEY_STORE_SERVER_CERT||"'"||")",
      " RING("||TLS_KEY_STORE_KEY_RING||")",
      " DEFAULT USAGE(PERSONAL))"
 if RC <> 0 then do
    exit RC
 end

Say "Connect OIDC provider certificate to key ring"
"RACDCERT ID("||SERVER_STC_USER||")",
   " CONNECT(LABEL("||"'"||OIDC_PROVIDER_CERT||"'"||")",
   " RING("||TLS_KEY_STORE_KEY_RING||")",
   " USAGE(PERSONAL))"
 if RC <> 0 then do
    exit RC
 end

   #if($!{instance-UKO_TLS_KEY_STORE_KEY_RING} != $!{instance-UKO_TLS_TRUST_STORE_KEY_RING} )
Say "Connect OIDC provider certificate to trust ring"
"RACDCERT ID("||SERVER_STC_USER||")",
   " CONNECT(LABEL("||"'"||OIDC_PROVIDER_CERT||"'"||")",
   " RING("||TLS_TRUST_STORE_KEY_RING||")",
   " USAGE(PERSONAL))"
 if RC <> 0 then do
    exit RC
 end
   #end

#end

#if($!{instance-UKO_CREATE_KEYRING} != "TRUE" && $!{instance-UKO_CREATE_CA} != "TRUE")
/* if CA and key ring are already existing, assume that the CA */
/* has been added to the trust ring*/
#else 
Say "Connect CA to trust ring"
"RACDCERT ID("||SERVER_STC_USER||")",
   " CONNECT(CERTAUTH LABEL("||"'"||CA_LABEL||"'"||")",
   " RING("||TLS_TRUST_STORE_KEY_RING||")",
   " USAGE(CERTAUTH))"
 if RC <> 0 then do
    exit RC
 end

#end

Say "Refreshing DIGTRING"
"SETROPTS RACLIST(DIGTRING) REFRESH"

Say "List the key ring for diagnostics"
"RACDCERT ID("||SERVER_STC_USER||")",
   " LISTRING("||TLS_KEY_STORE_KEY_RING||")"
 if RC <> 0 then do
    exit RC
 end

#if($!{instance-UKO_TLS_KEY_STORE_KEY_RING} != $!{instance-UKO_TLS_TRUST_STORE_KEY_RING} )
Say "List the trust ring for diagnostics"
"RACDCERT ID("||SERVER_STC_USER||")",
   " LISTRING("||TLS_TRUST_STORE_KEY_RING||")"
 if RC <> 0 then do
    exit RC
 end
#end

