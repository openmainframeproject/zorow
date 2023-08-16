/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/


CA_LABEL="${instance-UKO_CA_LABEL}"


"SETROPTS CLASSACT(DIGTCERT)"

Say "Generate a new CA"
"RACDCERT CERTAUTH GENCERT", 
   " SUBJECTSDN(CN('UKO-TEST-CA')",
      " OU('${instance-UKO_TLS_KEY_STORE_SERVER_CERT_OU}')",
      " O('${instance-UKO_TLS_KEY_STORE_SERVER_CERT_O}'))",
   " WITHLABEL("||"'"||CA_LABEL||"'"||")", 
   " NOTAFTER(DATE(2028-12-31) TIME(23:59:59))", 
   " RSA SIZE(2048)"


Say "Refresh DIGTCERT"
"SETROPTS RACLIST(DIGTCERT) REFRESH"
