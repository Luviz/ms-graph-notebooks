# Service Principle 

In order to use the Script or the notebook we need get read permissions to SharePoint/OneDrive.

## Create Service principle

Start by going to **Entra** or **AzureAD**, under **Mange** section you'll find **App registration** 

When in **App registration** click the **New registration**, that will take you the **Register an application** 

![app reg path](./assets/app-reg-path.png)

Form **Register an application** to give you app a any name you like and leave all other setting as is. The other options are for other uses of Service Principles that we will not be using this app for.

![app reg path](./assets/app-reg-form.png)

## Give your app permissions

Form the APP page find **API permissions** under the **Mange** section in left nav.

![app prem path](./assets/app-prem-path.png)

There you will find a button called Add a permission

> note: you can remove the user read permission

