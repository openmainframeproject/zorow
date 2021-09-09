/* Rexx */
trace commands
address tso

/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/

#if(${instance-SIGN_WITH} != "" && ${instance-SIGN_WITH})
	#set($signCert = "TRUE")
#else
	#set($signCert = "FALSE")
#end
"RACDCERT LISTRING(Keyring.WLP.${_workflow-softwareServiceInstanceName}) ID(${instance-WLP_USER})"
IF RC=0 THEN DO
"RACDCERT DELRING(Keyring.WLP.${_workflow-softwareServiceInstanceName}) ID(${instance-WLP_USER})"
#if($signCert == "TRUE")
"RACDCERT ID(${instance-WLP_USER}) DELETE (LABEL('WLP.${_workflow-softwareServiceInstanceName}'))"
#else
"RACDCERT ID(${instance-WLP_USER}) DELETE (LABEL('WLP.${_workflow-softwareServiceInstanceName}'))"
#end
"SETROPTS RACLIST(FACILITY) REFRESH"
END
