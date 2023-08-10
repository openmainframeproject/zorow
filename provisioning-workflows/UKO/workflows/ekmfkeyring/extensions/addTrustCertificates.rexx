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
TLS_TRUST_STORE_KEY_RING="${instance-EKMF_TLS_TRUST_STORE_KEY_RING}"

/* ********************************************** */
/* keyring section start                          */
/* ********************************************** */
/* Connect certificates to keyring */

Say "Connect certificates to trust ring"
Say "Connect GoogleTrustCert"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL('GoogleTrustCert')",
      " RING("||TLS_TRUST_STORE_KEY_RING||")",
      " DEFAULT USAGE(CERTAUTH))"

Say "Connect IBMDigiCertGlobalRootCA"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL('IBMDigiCertGlobalRootCA')",
      " RING("||TLS_TRUST_STORE_KEY_RING||")",
      " DEFAULT USAGE(CERTAUTH))"

Say "Connect IBMDigiCertGlobalRootG2"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL('IBMDigiCertGlobalRootG2')",
      " RING("||TLS_TRUST_STORE_KEY_RING||")",
      " DEFAULT USAGE(CERTAUTH))"

Say "Connect DIGICERT-ROOT-CA"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL('DIGICERT-ROOT-CA')",
      " RING("||TLS_TRUST_STORE_KEY_RING||")",
      " DEFAULT USAGE(CERTAUTH))"
Say "Connect DIGICERT-SHA2-SECURE-SERVER-CA"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL('DIGICERT-SHA2-SECURE-SERVER-CA')",
      " RING("||TLS_TRUST_STORE_KEY_RING||")",
      " DEFAULT USAGE(CERTAUTH))"

/* Azure Certificates */                               
Say "Connect AZURE-BALTCTRT"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL('AZURE-BALTCTRT')",
      " RING("||TLS_TRUST_STORE_KEY_RING||")",
      " DEFAULT USAGE(CERTAUTH))"
Say "Connect AZURE-DCGLBRG2"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL('AZURE-DCGLBRG2')",
      " RING("||TLS_TRUST_STORE_KEY_RING||")",
      " DEFAULT USAGE(CERTAUTH))"
Say "Connect AZURE-DTRTC3CA"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL('AZURE-DTRTC3CA')",
      " RING("||TLS_TRUST_STORE_KEY_RING||")",
      " DEFAULT USAGE(CERTAUTH))"
Say "Connect AZURE-MSECCRCA"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL('AZURE-MSECCRCA')",
      " RING("||TLS_TRUST_STORE_KEY_RING||")",
      " DEFAULT USAGE(CERTAUTH))"
Say "Connect AZURE-MSRSARCA"
"RACDCERT ID("||WEB_TASK_USER||")",
   " CONNECT(CERTAUTH LABEL('AZURE-MSRSARCA')",
      " RING("||TLS_TRUST_STORE_KEY_RING||")",
      " DEFAULT USAGE(CERTAUTH))"

Say "Refresh DIGTRING in RACF"
"SETROPTS RACLIST(DIGTRING) REFRESH"

Say "List the final trust keyring"
"RACDCERT ID("||WEB_TASK_USER||")",
   " LISTRING("||TLS_TRUST_STORE_KEY_RING||")"
