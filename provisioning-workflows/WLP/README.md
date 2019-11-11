# sample.zos.provision.wlp
Sample workflows to dynamically provision WebSphere Liberty servers using IBM Cloud Provisioning and Management for z/OS

# Getting Started
	
IBM Cloud Provisioning and Management for z/OS is a feature within z/OSMF. It provides the capability for users to dynamically provision middleware resources in a cloud environment. Workflows (made up of XML files,   scripts, and properties files) plugin and can be dynamically executed to provision and deprovision resource instances as well as perform various actions on them. These sample workflows are for provisioning WebSphere Liberty and can be configured and customized.
	
# Prerequisites 

 * IBM Cloud Provisioning and Management for z/OS is required.
 
 * An installation of WebSphere Liberty 8.5.5.8, 8.5.5.7 w/ iFix PI47476, or 16.x.x.x is required.
 
 
# Setup

1. Download the workflow files to a z/OS system running IBM Cloud Provisioning and Management. (workflows/templates/wlp-provisioning.sh may need to be converted to EBCDIC. This is due to how this script is executed at runtime.)
2. Use the Setup_and_Configuration PDF for a list of capabilities and configuration options.
3. Configure the workflow_variables.properties file.
3. Create a new template for the Liberty workflows following the instructions in IBM Cloud Provisioning and Management.
