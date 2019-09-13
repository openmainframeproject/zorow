# ZORoW - z/OS® Open Repository of Workflows
This repository contains workflow definitions and other associated material that can be used with the z/OS® Management Facility (z/OSMF).

A z/OSMF workflow is a guided set of steps that help you perform an activity on z/OS®, such as configuring a software product, managing a z/OS® resource, or simplifying some relatively complex operation. To support these activities, a workflow can be designed to perform a wide variety of operations, such as configuring and starting z/OS® subsystems using the Cloud Provisioning and Management plug-in, submitting jobs and scripts, issuing REST APIs and invoking TSO/E functions.

A z/OSMF a workflow instance can be created from an XML file containing the z/OSMF workflow definition.  A workflow definition can utilized one or more file templates and an optional workflow variables properties file.

z/OSMF currently provides two different tasks that can create workflow instances from workflow definitions. These tasks are the *Workflow* task and the Cloud Provisioning and Management plug-in's *Software Services* task. It is important to understand which of these two z/OSMF tasks will be used to create and run the workflow's instance: the workflow definition should be appropriately designed to run under that task. For example, if workflow is intended to run under the Cloud Provisioning and Management's *Software Services* task, the workflow definition must include 'Provisioning' metadata. 

Anyone can contribute z/OSMF workflow definitions to this repository. Workflow definitions provided in this repository are covered under Eclipse Public License v2.0. Workflow definitions contributed to this repository are expected to be well tested and free from errors. Please follow the governance described in 'governance.md' file. As a recommended practice, review carefully any materials that you download from this repository before using them on a live system. 

Though the workflow definitions provided herein are not supported by any specific organization, your comments are welcomed by the maintainers of this repository, who reserve the right to revise or remove the materials at any time. To report a problem, you can open an issue in repository against a specific workflow. 
