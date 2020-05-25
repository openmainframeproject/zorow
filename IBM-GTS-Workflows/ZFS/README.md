# PA-zOSMF-ZFS-Workflows

z/OSMF workflows for the z/OS platform

This repository contains workflow definitions (XML files) that can be used with the Workflows task of the z/OS Management Facility (z/OSMF).

In z/OSMF, a workflow is a guided set of steps that help you perform an activity on z/OS®, such as configuring a software product, managing a z/OS resource, or simplifying some relatively complex operation. To support these activities, a workflow can be designed to perform a wide variety of operations, such as starting z/OS subsystems, submitting jobs and scripts, and invoking TSO/E functions.

There are no warranties of any kind, and there is no service or technical support available for these materials from IBM. As a recommended practice, review carefully any materials that you download from this site before using them on a live system.

Though the materials provided herein are not supported by the IBM Service organization, your comments are welcomed by the developers, who reserve the right to revise or remove the materials at any time. 

Here is a Brief description of the workflows contained in this repository :

<table width=100%><caption>IBM Mainframe Automation team supported workflows</caption>
   <tr>
      <td>IBM-MF-AUTO-ZFS-CONVERT</td>
      <td>This workflow can be used to convert one or more HFS datasets in ZFS. It is based in the IBM provided BPXWH2Z program. </td>
   </tr> 
   <tr>
	<td>IBM-MF-AUTO-ZFS-DEFINE-AMS</td>
	<td>This workflow uses the IDCAMS Access Method Services APIs to define a new ZFS file.</td>
   </tr>
   <tr> 
	<td>IBM-MF-AUTO-ZFS-DEFINE </td>
        <td>This workflow uses the tradicional IDCAMS JCL statements as an inline template to define a new ZFS file.</td>
   </tr>
   <tr>		      
      <td>IBM-MF-AUTO-ZFS-DELETE</td>
      <td>This workflow uses the IDCAMS Access Method Services APIs to delete a ZFS from the system.</td>
   </tr>
   <tr>
      <td>IBM-MF-AUTO-ZFS-GROW</td>
      <td>This workflow uses the zfsadm command to grow a ZFS aggregate.</td>
   </tr>
   <tr>
      <td>IBM-MF-AUTO-ZFS-MOUNT</td>
      <td>This workflow uses the zfsadm command to mount a ZFS aggregate.</td>
   </tr>
   <tr>
      <td>IBM-MF-AUTO-ZFS-PROV-APPL-MOUNTPOINT</td>
      <td>This workflow is a more complex example that combines steps from other workflows contained here, it can be used to
create a new ZFS, a new Unix directory and mount that ZFS on the desired directory.</td>
   </tr>
   <tr>
      <td>IBM-MF-AUTO-ZFS-SHRINK</td>
      <td>This workflow uses the zfsadm command to shrink a ZFS aggregate.</td>
   </tr>
   <tr>
      <td>IBM-MF-AUTO-ZFS-UNMOUNT</td>
      <td>This workflow uses the zfsadm command to Unmount a ZFS aggregate.</td>
   </tr>
</table>

<table width=100%>  <caption>User Contributed Tested Workflows</caption>
   <tr>
      <td>IBM-MF-USR-ZFS-ADDVOL</td>
      <td>This workflow can be used to add more volumes to a given HFS/zFS filesystem so it can expand successfully
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
