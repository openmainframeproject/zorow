/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/
/***********************************************************************/
/*                                                                     */
/* PLEASE READ                                                         */
/*                                                                     */
/* This script contains an example for dynamically defining a keyring, */
/* generating a self signed certificate and connecting the certificate */
/* to the keyring.                                                     */
/*                                                                     */
/* By default this script does nothing, as there is an 'exit 0'        */
/* statement directly under this comment.  Review the example and      */
/* remove the 'exit 0' if you wish to use this script.                 */
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
/* Define the KEYRING and a certificate                               */
/**********************************************************************/

/* Use the RACDCERT GENCERT command to create server certificates. */ 
/* Change www.example.com to match the server */ 
/* to which you want to deploy EKMF Web. */ 
/* TODO: check what is the identifier of a cert as we are creating more*/



#if($!{instance-EKMF_CREATE_CA} == "TRUE" || $!{instance-EKMF_CREATE_CERTIFICATES} == "TRUE" ) 
"SETROPTS CLASSACT(DIGTCERT)"
#end 

#if($!{instance-EKMF_CREATE_CA} == "TRUE")
Say "Generate a new CA"
"RACDCERT CERTAUTH GENCERT", 
   " SUBJECTSDN(CN('EKMF-TEST-CA')",
      " OU('${instance-EKMF_TLS_KEY_STORE_SERVER_CERT_OU}')",
      " O('${instance-EKMF_TLS_KEY_STORE_SERVER_CERT_O}'))",
   " WITHLABEL("||"'"||CA_LABEL||"'"||")", 
   " NOTAFTER(DATE(2028-12-31) TIME(23:59:59))", 
   " RSA SIZE(2048)"
#end

#if($!{instance-EKMF_CREATE_CERTIFICATES} == "TRUE" ) 
/* ********************************************** */
/* certifivate generation section start           */
/* ********************************************** */
Say "Generate a server certificate"
"RACDCERT ID("||WEB_TASK_USER||") GENCERT",
   " SUBJECTSDN(CN('${instance-EKMF_TLS_KEY_STORE_SERVER_CERT_CN}')",
      " OU('${instance-EKMF_TLS_KEY_STORE_SERVER_CERT_OU}')",
      " O('${instance-EKMF_TLS_KEY_STORE_SERVER_CERT_O}'))",
   " WITHLABEL("||"'"||TLS_KEY_STORE_SERVER_CERT||"'"||")", 
   " SIGNWITH(CERTAUTH LABEL("||"'"||CA_LABEL||"'"||"))",
   " NOTAFTER(DATE(2023-12-31) TIME(23:59:59))",
   " RSA SIZE(2048)"
 if RC <> 0 then do
    exit RC
 end

Say "Generate an OIDC certificate"
"RACDCERT ID("||WEB_TASK_USER||") GENCERT",
   " SUBJECTSDN(CN('${instance-EKMF_TLS_KEY_STORE_SERVER_CERT_CN}')",
      " OU('${instance-EKMF_TLS_KEY_STORE_SERVER_CERT_OU}')",
      " O('${instance-EKMF_TLS_KEY_STORE_SERVER_CERT_O}'))",
   " WITHLABEL("||"'"||OIDC_PROVIDER_CERT||"'"||")", 
   " SIGNWITH(CERTAUTH LABEL("||"'"||CA_LABEL||"'"||"))",
   " NOTAFTER(DATE(2023-12-31) TIME(23:59:59))",
   " RSA SIZE(2048)"
 if RC <> 0 then do
    exit RC
 end

/* ********************************************** */
/* certifivate generation section end             */
/* ********************************************** */
#end


#if($!{instance-EKMF_CREATE_CA} == "TRUE" || $!{instance-EKMF_CREATE_CERTIFICATES} == "TRUE" ) 
Say "Refresh DIGTCERT"
"SETROPTS RACLIST(DIGTCERT) REFRESH"
#end

/* ********************************************** */
/* keyring section start                          */
/* ********************************************** */

"SETROPTS CLASSACT(DIGTRING)"

#if($!{instance-EKMF_CREATE_KEYRING} == "TRUE" ) 
Say "Generate the key ring"
"RACDCERT ADDRING("||TLS_KEY_STORE_KEY_RING||")",
   " ID("||WEB_TASK_USER||")"
 if RC <> 0 then do
    exit RC
 end

   #if($!{instance-EKMF_TLS_KEY_STORE_KEY_RING} != $!{instance-EKMF_TLS_TRUST_STORE_KEY_RING} )

Say "Generate the trust ring"
"RACDCERT ADDRING("||TLS_TRUST_STORE_KEY_RING||")",
   " ID("||WEB_TASK_USER||")"
 if RC <> 0 then do
    exit RC
 end
   #end
#end


#if($!{instance-EKMF_CREATE_KEYRING} != "TRUE" && $!{instance-EKMF_CREATE_CERTIFICATES} != "TRUE")
/* if certificates and key ring are already existing, assume that the certificates */
/* have been added to the key ring*/
#else 
/* Connect certificates to keyring */
Say "Connect TLS server  certificate to key ring"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(LABEL("||"'"||TLS_KEY_STORE_SERVER_CERT||"'"||")",
      " RING("||TLS_KEY_STORE_KEY_RING||")",
      " DEFAULT USAGE(PERSONAL))"
 if RC <> 0 then do
    exit RC
 end

Say "Connect OIDC provider certificate to key ring"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(LABEL("||"'"||OIDC_PROVIDER_CERT||"'"||")",
   " RING("||TLS_KEY_STORE_KEY_RING||")",
   " USAGE(PERSONAL))"
 if RC <> 0 then do
    exit RC
 end

   #if($!{instance-EKMF_TLS_KEY_STORE_KEY_RING} != $!{instance-EKMF_TLS_TRUST_STORE_KEY_RING} )
Say "Connect OIDC provider certificate to trust ring"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(LABEL("||"'"||OIDC_PROVIDER_CERT||"'"||")",
   " RING("||TLS_TRUST_STORE_KEY_RING||")",
   " USAGE(PERSONAL))"
 if RC <> 0 then do
    exit RC
 end
   #end

#end

#if($!{instance-EKMF_CREATE_KEYRING} != "TRUE" && $!{instance-EKMF_CREATE_CA} != "TRUE")
/* if CA and key ring are already existing, assume that the CA */
/* has been added to the key ring*/
#else 
Say "Connect CA to trust ring"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL("||"'"||CA_LABEL||"'"||")",
   " RING("||TLS_TRUST_STORE_KEY_RING||")",
   " USAGE(CERTAUTH))"
 if RC <> 0 then do
    exit RC
 end

#end

"SETROPTS RACLIST(DIGTRING) REFRESH"
/* ********************************************** */
/* keyring section end                            */
/* ********************************************** */


/* ********************************************** */
/* keyring access section start                   */
/* ********************************************** */

Say "List the key ring for diagnostics"
"RACDCERT ID("||WEB_TASK_USER||")",
   " LISTRING("||TLS_KEY_STORE_KEY_RING||")"
 if RC <> 0 then do
    exit RC
 end

#if($!{instance-EKMF_TLS_KEY_STORE_KEY_RING} != $!{instance-EKMF_TLS_TRUST_STORE_KEY_RING} )
Say "List the trust ring for diagnostics"
"RACDCERT ID("||WEB_TASK_USER||")",
   " LISTRING("||TLS_TRUST_STORE_KEY_RING||")"
 if RC <> 0 then do
    exit RC
 end
#end

/* Enable the Liberty user to use the key ring */
Say "Define "||WEB_TASK_USER||"."||TLS_KEY_STORE_KEY_RING||" "
"RDEFINE RDATALIB",
   " "||WEB_TASK_USER||"."||TLS_KEY_STORE_KEY_RING||".LST",
   " UACC(NONE)"

Say "Grant access to "||WEB_TASK_USER||" "
"PERMIT",
   " "||WEB_TASK_USER||"."||TLS_KEY_STORE_KEY_RING||".LST",
   " CLASS(RDATALIB)",
   " ACCESS(READ) ID("||WEB_TASK_USER||")"

#if($!{instance-EKMF_TLS_KEY_STORE_KEY_RING} != $!{instance-EKMF_TLS_TRUST_STORE_KEY_RING} )
Say "Define "||WEB_TASK_USER||"."||TLS_TRUST_STORE_KEY_RING||" "
"RDEFINE RDATALIB",
   " "||WEB_TASK_USER||"."||TLS_TRUST_STORE_KEY_RING||".LST",
   " UACC(NONE)"

Say "Grant access to "||WEB_TASK_USER||" "
"PERMIT",
   " "||WEB_TASK_USER||"."||TLS_TRUST_STORE_KEY_RING||".LST",
   " CLASS(RDATALIB)",
   " ACCESS(READ) ID("||WEB_TASK_USER||")"
#end

Say "Refresh RDATALIB"
"SETROPTS RACLIST(RDATALIB) REFRESH"

/* It is recommended to use the RDATALIB class, */
/* however if it is not active then instead access to the */
/* IRR.DIGTCERT.LISTRING FACILITY resource can be used */
/* TODO: conditional formatting*/

Say "Define IRR.DIGTCERT.LISTRING in FACILITY"
"RDEFINE FACILITY IRR.DIGTCERT.LISTRING UACC(NONE)"

Say "Grant access to "||WEB_TASK_USER||" "
"PERMIT IRR.DIGTCERT.LISTRING CLASS(FACILITY) ACCESS(READ)",
   " ID("||WEB_TASK_USER||")"

Say "Refresh FACILITY"
"SETROPTS RACLIST(FACILITY) REFRESH"
/* ********************************************** */
/* keyring access section end                     */
/* ********************************************** */
