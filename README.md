## 🌟 **Project Overview**
M365 Service Request Center is a compact yet feature-rich Microsoft Power Apps project, meticulously designed to facilitate efficient management of service requests associated with Microsoft 365, specifically focusing on Power Platform environments, Power Apps, and Microsoft 365 Groups.

### **Scalability & Adaptability**
The project inherently holds scalability, allowing adaptations and expansions according to organizational needs. However, potential users should be mindful that due to the inherent limitations of Power Apps, scalability might necessitate multiple manual configurations and adjustments. It is crucial to evaluate the expansion needs against the required manual interventions to ensure optimal functionality and user experience.

## 🚀 **Project Overview**

### **Power App Application:**
- **Home Screen:** Allows users to submit requests, view open requests, and email themselves the list of open requests.
- **Detailed requests Screen:** Enables users to navigate and review all their submitted requests and email this information to themselves.

### **Requests Handling:**
- **Dynamically Created Forms:** Created through gallery control, allowing administrators to modify fields and add new types of requests as needed.
- **Request Storage:** Requests are stored in corresponding SharePoint lists, maintaining user privacy by displaying only the requests where they are the requester or submitter.

### **Automated Workflows:**
- **Eight Power Automate Workflows:** Six workflows correspond to different types of requests and are triggered upon item creation in SharePoint, and two workflows to send the request information.
- **Approval Process:** Incorporated in each workflow to manage and moderate requested operations.

## 🖥 **Features & Functions**

- **Versatile Request Submission:** Supports the creation or deletion of Power Platform environments, Power App deployment or deletion, and Microsoft 365 Group creation or deletion.
- **Efficient Tracking:** Provides users with the capability to view and manage both open and submitted requests effectively.
- **Automated Operations:** Simplifies processes like the creation/deletion of environments and Microsoft 365 Groups.
- **Restrained Automation:** Due to Power Platform limitations, some processes, like Power App deployment, still require admin intervention.

## ⚠️ **Disclaimer**

This project is provided "as is," without warranty, and is not maintained. Users should use this project at their own risk and are advised to review the codebase and test the application in a controlled environment before deploying it in live scenarios.

## 🛠 **Installation & Setup**

For a detailed installation guide, refer to [Configuration & Deployment](https://github.com/RodnerK/M365-Service-Request-Center/wiki/Configuration-&-Deployment) in the Wiki.

## 📁 **Project Structure**

M365-Service-Request-Center
│
├─── (Packed) Solutions --> Solution file in Zip format
│
├─── (Unpacked) CanvasApps
│ └─── new_m365servicerequestcenter_afdf0_DocumentUri --> Power App unpacked source files
│
├─── (Unpacked) Solutions
│ └─── Microsoft365Requests_1_0_0_0 --> Solution files
│
├─── Config --> XML and CSV configuration files
│
├─── Documents --> Documentation files including original color codes in the application, workflow graphical documentation
│
├─── Screenshots --> Screenshots of the application
│
└─── Utilities --> Deployment scripts to facilitate deployment and reduce manual work.


## 📘 **Documentation**

For comprehensive details on each component, please refer to the [Project Wiki](https://github.com/RodnerK/M365-Service-Request-Center/wiki).

## 📖 **Wiki Pages**

1. [Home](https://github.com/RodnerK/M365-Service-Request-Center/wiki)
2. [Application Screens](https://github.com/RodnerK/M365-Service-Request-Center/wiki/Application-Screens)
3. [Workflows](https://github.com/RodnerK/M365-Service-Request-Center/wiki/Workflows)
4. [Configuration & Deployment](https://github.com/RodnerK/M365-Service-Request-Center/wiki/Configuration-&-Deployment)
5. [SharePoint Database](https://github.com/RodnerK/M365-Service-Request-Center/wiki/SharePoint-Database)