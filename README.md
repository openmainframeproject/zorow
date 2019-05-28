# zOS-Workflow
This repository contains workflow definitions (XML files) and other material associated with the workflow that can be used with the z/OS Management Facility (z/OSMF).

In z/OSMF, a workflow is a guided set of steps that help you perform an activity on z/OS®, such as configuring a software product, managing a z/OS resource, or simplifying some relatively complex operation. To support these activities, a workflow can be designed to perform a wide variety of operations, such as configuring and starting z/OS subsystems using cloud provisioning and management, submitting jobs and scripts, submitting REST APIs and invoking TSO/E functions.

z/OSMF currently provides two different tasks that can execute the workflow. These tasks are z/OSMF Workflow task and Cloud Provisioning Software Services task. It is important to be aware of which z/OSMF task will be used to execute the workflow and workflow should be appropriately designed to run under that task. For example, if workflow is inteded to run under Cloud Provisioning Software Services task, the workflow definition must include 'Provisioning' metadata. 

Anyone can contribute z/OSMF workflows to this repository. Workflows provided in repository are covered under Apacha 2.0 license. Workflows contributed to this repository are expected to be well tested and free from any error. Please follow the governance described in 'governance.md' file. As a recommended practice, review carefully any materials that you download from this repository before using them on a live system. 

Though the workflows provided herein are not supported by any specific organization, your comments are welcomed by the developers, who reserve the right to revise or remove the materials at any time. To report a problem, you can open an issue in repository against a specific workflow. 
