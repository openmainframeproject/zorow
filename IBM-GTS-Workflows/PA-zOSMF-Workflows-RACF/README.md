# PA-zOSMF-Workflows-RACF
z/OSMF workflows for RACF

This repository contains workflow definitions (XML files) that can be used with the Workflows task of the z/OS Management Facility (z/OSMF).

In z/OSMF, a workflow is a guided set of steps that help you perform an activity on z/OS®, such as configuring a software product, managing a z/OS resource, or simplifying some relatively complex operation. To support these activities, a workflow can be designed to perform a wide variety of operations, such as starting z/OS subsystems, submitting jobs and scripts, and invoking TSO/E functions.

There are no warranties of any kind, and there is no service or technical support available for these materials from IBM. As a recommended practice, review carefully any materials that you download from this site before using them on a live system.

Though the materials provided herein are not supported by the IBM Service organization, your comments are welcomed by the developers, who reserve the right to revise or remove the materials at any time. 

In our repositories we have our supported workflows and user contributed workflows:

<table width=100%>  <caption>IBM Mainframe Automation team supported workflows</caption>
   <tr>
      <td>IBM-MF-AUTO-RACF-RESETPW.xml</td>
      <td>Workflow designed to resume and reset the password for a given userID.</td>
   </tr>
   <tr>
      <td>IBM-MF-AUTO-RACF-RESETPW-SNOW.xml</td>
      <td>Workflow to be user with SNOW designed to resume and reset the password for a given userID.</td>
   </tr> 
   <tr>
      <td>IBM-MF-AUTO-RACF-USER-DEL.xml</td>
      <td>Workfloe designed to remove a user from a system (can be customized)</td>
   </tr>
   <tr>
      <td>IBM-MF-AUTO-RACF-USER-ADD.xml</td>
      <td>Workflow designed to add a userID to the system, you can choose between different roles</td>
   </tr>  
</table>

<table width=100%>  <caption>User Contributed Tested Workflows</caption>
   <tr>
      <td>IBM-MF-AUTO.....</td>
      <td>To be uploaded</td>
   </tr> 
</table>

<table><caption><b>Disclaimer</b></caption>
   <tr>
      <td>All zOSMF Workflows with IBM-MF-AUTO prefix were developed and are supported by Mainframe Service Line Engineering team.</td>
	</tr><tr>
      <td>All zOSMF Workflows with IBM-MF-USR prefix were developed by the z community and shared for global re-use, however there is no ongoing support on them. By uploading the them into your system, you will be responsible to maintain it.</td>
	</tr>
</table>

IBM Z Systems - Workflow Repository: https://github.com/IBM/IBM-Z-zOS/tree/master/zOS-Workflow
