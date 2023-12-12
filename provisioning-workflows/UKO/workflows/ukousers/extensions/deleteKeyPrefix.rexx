/* REXX */
/*----------------------------------------------------------------*/
/* Copyright Contributors to the zOS-Workflow Project.            */
/* PDX-License-Identifier: Apache-2.0                             */
/*----------------------------------------------------------------*/



KEY_PREFIX="${instance-UKO_KEY_PREFIX}"

Say "Deleting "||KEY_PREFIX||".** entry in CSFKEYS class"
"PERMIT "||KEY_PREFIX||".**   CLASS(CSFKEYS) DELETE ID(ACSPSGRP)"
"RDELETE CSFKEYS "||KEY_PREFIX||".** "

Say "Refreshing CSFKEYS"
"SETROPTS RACLIST(CSFKEYS) REFRESH"

