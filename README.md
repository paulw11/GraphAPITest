# GraphiAPITest

This project demonstrates the use of the Microsoft Azure Graph API.

To get started, pull the repo or download a copy.  
Once you have the project on your computer, open a terminal window, change to the project directory and 
install the dependencies by running `pod update`.

In the Azure portal you need to create a new application:

- Select "add an application my organisation is developing"
- Give it a name and select *Native Client Application*
- Enter `GraphApiTest://me.wilko.graphapitest` as the redirect uri (You can change this but you will need to change `Settings.plist` and the URI registered in `Info.plist` accordingly

Now, open `GraphAPITest.xcworkspace` and customise the `Settings.plist` file.  You will need to change:

- The client id
- The tenant
- The redirect uri if you changed it above
 
At this point you should be good to go; run the app, click "login" and you should be prompted to authenticate.
Note that you must authenticate using a user from your tenancy directory; you cannot use a Windows Live account.


