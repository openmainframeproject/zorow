# z/OSMF workflow samples

This repository contains a number of sample workflow definitions (XML files) and other associated materials to help demonstrate various capabilities of z/OSMF workflows.

It is recommended that you load these samples and observe their behavior in the z/OSMF Workflows task as you read this information.

## Basic Workflow Definitions

Start with the following samples, which show a basic workflow definition, and demonstrate the use of language bundles and variables

|Filename|Description|
|--------|-----------|
|workflow_sample_basic.xml|Shows the most basic workflow. It contains one step with only the required elements.
|workflow_sample_variables.xml| Shows the use of variables that require user input.

## Advanced Workflow Definitions

More advanced concepts are illustrated in the following samples.

|Filename|Description|
|--------|-----------|
|workflow_sample_array_variables.xml|Shows the use of array variables in a workflow.
|workflow_sample_array_property.txt|Shows a sample workflow array variable input file, for use with workflow_sample_array_variables.xml.
|workflow_sample_automation.xml| Shows the use of automated steps in a workflow.
|workflow_sample_automation_property.txt| Shows a sample workflow variable input file, for use with workflow_sample_automation.xml.
|workflow_sample_calledwfBasic.xml| Shows an example of a called workflow. This workflow is called by specifying its workflow ID.
| workflow_sample_calledwfMD5.xml| Shows an example of a called workflow. This workflow is called by specifying its MD5 encrypted value (a 128-bit hash value).
| workflow_sample_calledwfVarMapping1.xml| Shows an example of a called workflow. This example shows how variables can be mapped from the calling workflow to the called workflow.
| workflow_sample_calledwfVarMapping2.xml| Shows an example of a called workflow. This example shows how variables can be mapped from the called workflow to the calling workflow.
| workflow_sample_condition.xml| Shows the use of conditional steps in a workflow.
| workflow_sample_feedback.xml| Shows an example of a feedback form that can be used to gather input on a step from the step owner.
| workflow_sample_file_template0.xml| Shows the use of a file creation template.
| workflow_sample_include_external.xml| Shows the use of a DTD to make references to the external files workflow_sample_fragment0.xml and workflow_sample_fragment1.xml. This sample also demonstrates other features of steps, and uses some HTML tags within a step description.
| workflow_sample_output.xml| Shows an example of writing generated variables to an output file.
| workflow_sample_parallel_steps.xml| Shows the use of parallel steps in a workflow.
| workflow_sample_program_execution.xml| Shows an example of running an inline executable program (a UNIX shell script) from within a step.
| workflow_sample_predefinedVariable.xml| Shows the use of predefined variables in workflow steps.
| MyTemplate.txt| Shows a sample workflow file template file, for use with workflow_sample_predefinedVariable.xml.
| workflow_sample_rexx_template0.txt| Shows how to invoke a REXX exec from a workflow.
| workflow_sample_substeps.xml| Shows the use of substeps and the use of step prerequisites to establish dependency chains.
| workflow_sample_translation.xml| Shows a basic workflow that refers to a language bundle file. This workflow is used with workflow_sample_bundle0.txt.
| workflow_sample_wf2wf.xml| Is a workflow that calls another workflow for processing.
| workflow_sample_wizards.xml| Shows the use of instructions and wizards that use input variables.
| workflow_sample_wizards_upgrade.xml| Shows the use of the workflow upgrade function. It upgrades the workflow that is created in the sample file workflow_sample_wizards.xml.
| workflow_sample_dataset.xml | Shows the use of REST steps to manipulate with z/OS data set.
| workflow_sample_smpe_report_missingfix.xml| Workflow to run an SMP REPORT MISSINGFIX command.  This is a sample step that can be used for running an SMP/E REPORT MISSINGFIX for any FIXCAT.