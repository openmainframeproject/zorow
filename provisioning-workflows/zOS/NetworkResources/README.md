# Provision Network Resources
Sample workflows to dynamically provision z/OS network resources such as Dynamic VIPA, Port and VTAM Application ID (APPLID)  using IBM Cloud Provisioning and Management for z/OS

# Getting Started
	
IBM Cloud Provisioning and Management for z/OS is a feature within z/OSMF. It provides the capability for users to dynamically provision middleware resources in a cloud environment. Workflows (made up of XML files, scripts, and properties files) can be dynamically executed to provision and deprovision resource instances as well as perform various actions on them. These sample workflows are for provisioning and deprovisioning z/OS network resources such as Dynamic VIPA, Port and VTAM Application ID (APPLID).
	
# Prerequisites 

 * IBM Cloud Provisioning and Management for z/OS is required.
 
 
# Setup

1. Download the workflow files to a z/OS system running IBM Cloud Provisioning and Management.
2. Create a new template for the Network Resource Provisioning following the instructions in IBM Cloud Provisioning and Management.
3. Associate the template to a tenant (user or group of users) who will be requesting network resources and create network resource pool.
4. Work with network administrator to complete network resource pool in z/OSMF Network Configuration Assistance plugin identifying IP ranges, port ranges and SNA APPL ID ranges.
5. Test the template. The workflow provided in "Provision_Network_Resource.xml" will be driven to provision the requested network resource.
6. Publish the template.


# Provision Network Resource (Run the template)

Provision Network Resource service provides capablity to provision network resources based on properties provided by the user. Following properties can be provided at the provisioning time. 

* OBTAIN_DVIPA - Identifies whether dynamic VIPA should be obtained. Specify "YES" or "NO". If no value is specified, dynamic VIPA will not be provisioned.
* OBTAIN_PORT - Identifies whether TCP/IP port should be obtained. Specify "YES" or "NO". If no value is specified, TCP/IP port will not be provisioned.
* OBTAIN_APPLID - Identifies whether VTAM Application ID (APPLID) should be obtained. Specify "YES" or "NO". If no value is specified, VTAM APPLID will not be provisioned.
* JOB_NAME - Identifies z/OS job that will be utilizing the allocated port. This property is required when TCP/IP port is requested. If job name is not known, "*" can be specified as value.
* USAGE_TYPE - Optional property that identifies type of application (e.g. WLP, CICS or Node) for which port needs to be provisioned. When pool of port ranges defined in z/OSMF Network Configuration Assistant, network administrator can identify usage type for specific port ranges. USAGE_TYPE property must match with usage type defined in z/OSMF Network Configuration Assistant otherwise the port provisioning request will fail. When USAGE_TYPE property is not specified, port is provisioned from a port ranges pool that is defined with out usage type. 


# Output - Provisioned Network Resources

Once provisioning request completes, following properties are available in the provisioned instance based on the type of network resource requested at the provisioning time

* IP_ADDRESS - This property provides the provisioned dynamic VIPA  when OBTAIN_DVIPA property was set at the provisioning time
* PORT - This property provides the provisioned TCP/IP port when OBTAIN_PORT property was set at the provisioning time
* APPLID - This property provides the provisioned VTAM Application ID (APPLID) when OBTAIN_APPLID property was set at the provisioning time


# Deprovisioning Network Resource

When network resources are no longer needed, user can perform "Deprovision" action associated with the provisioned instance. This action drives the workflow provided in "Deprovision_Network_Resource.xml" and returns the network resources back to the pool. 
