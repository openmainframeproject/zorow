/* Rexx */                                                                    
trace commands                                                                                                              
address tso

#if(${instance-SIGN_WITH} != "" && ${instance-SIGN_WITH})
	#set($signCert = "TRUE")
#else
	#set($signCert = "FALSE")
#end
#if(${instance-CERTIFICATE_EXPIRATION_DATE} != "" && ${instance-CERTIFICATE_EXPIRATION_DATE})
	#set($expirationDate = "TRUE")
#else
	#set($expirationDate = "FALSE")
#end

"RACDCERT ADDRING(Keyring.WLP.${_workflow-softwareServiceInstanceName}) ID(${instance-WLP_USER})"
IF RC<>0 then exit 8

#if($signCert == "TRUE")
#if($expirationDate == "TRUE")
"RACDCERT ID (${instance-WLP_USER}) GENCERT SUBJECTSDN(CN('WLP.${_workflow-softwareServiceInstanceName}') OU('LIBERTY')) WITHLABEL('WLP.${_workflow-softwareServiceInstanceName}') SIGNWITH(CERTAUTH LABEL('${instance-SIGN_WITH}')) NOTAFTER(DATE(${instance-CERTIFICATE_EXPIRATION_DATE}))"
IF RC<>0 then exit 8

#else
"RACDCERT ID (${instance-WLP_USER}) GENCERT SUBJECTSDN(CN('WLP.${_workflow-softwareServiceInstanceName}') OU('LIBERTY')) WITHLABEL('WLP.${_workflow-softwareServiceInstanceName}') SIGNWITH(CERTAUTH LABEL('${instance-SIGN_WITH}'))"
IF RC<>0 then exit 8

#end
#else
#if($expirationDate == "TRUE")
"RACDCERT ID (${instance-WLP_USER}) GENCERT SUBJECTSDN(CN('WLP.${_workflow-softwareServiceInstanceName}') OU('LIBERTY')) WITHLABEL('WLP.${_workflow-softwareServiceInstanceName}') NOTAFTER(DATE(${instance-CERTIFICATE_EXPIRATION_DATE}))"
IF RC<>0 then exit 8

#else
"RACDCERT ID (${instance-WLP_USER}) GENCERT SUBJECTSDN(CN('WLP.${_workflow-softwareServiceInstanceName}') OU('LIBERTY')) WITHLABEL('WLP.${_workflow-softwareServiceInstanceName}')"
IF RC<>0 then exit 8

#end
#end

"RACDCERT ID(${instance-WLP_USER}) CONNECT (LABEL('WLP.${_workflow-softwareServiceInstanceName}') RING(Keyring.WLP.${_workflow-softwareServiceInstanceName}) DEFAULT)"
IF RC<>0 then exit 8

#if($signCert == "TRUE")
"RACDCERT ID(${instance-WLP_USER}) CONNECT (RING(Keyring.WLP.${_workflow-softwareServiceInstanceName}) LABEL('${instance-SIGN_WITH}') CERTAUTH)"
IF RC<>0 then exit 8

#end

"SETROPTS RACLIST(FACILITY) REFRESH"