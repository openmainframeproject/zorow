/* REXX */
/************************************************************************
 *                                                                      *
 * <copyright                                                           *
 * notice="lm-source"                                                   *
 * pids="5650-DB2"                                                      *
 * years="2018">                                                        *
 * Licensed Materials - Property of IBM                                 *
 *                                                                      *
 * 5650-DB2                                                             *
 *                                                                      *
 * (C) Copyright IBM Corp. 2019 All Rights Reserved.                    *
 *                                                                      *
 *  STATUS = Version 12                                                 *
 *                                                                      *
 * </copyright>                                                         *
 *                                                                      *
 ************************************************************************
 *                                                                      *
 * IBM Db2 for z/OS                                                     *
 *                                                                      *
 * validateSSN.rexx                                                     *
 *                                                                      *
 * This rexx exec validates the length of the workflow Software Service *
 * Instance name.                                                       *
 ************************************************************************/

/************************************************************************/
/* Validate the workflow Software Service Instance Name.                */
/*                                                                                                             */
/* Note: The comma is a continuation character in REXX.                 */
/************************************************************************/
if ((length("${_workflow-softwareServiceInstanceName}") < 1) | ,
    (length("${_workflow-softwareServiceInstanceName}") > 4)) then do
  rc = 8
  say "*validateSSN* completed with rc="rc". The workflow Software",
      "Service Instance Name (${_workflow-softwareServiceInstanceName})",
      "length is not valid. Please supply a workflow Software Service",
      "Instance Prefix of up to 2 characters. The prefix is concatenated",
      "with a 2 character incremental unique value to form the Db2 ",
      "subsystem identifier."
end
else do
  rc = 0
  say "*validateSSN* completed with rc="rc". The workflow Software",
      "Service Instance Name length is valid."
end

exit rc 
