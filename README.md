# Petbooking iOS


### App architeture

The architeture used on PetBooking iOS is the [Viper architeture](https://www.objc.io/issues/13-architecture/viper/).

SDKs and 3rd party libraries are installed using [Cocoapods](https://cocoapods.org/)

### Project Structure Folder
The application is organized by feature in following folders structure:

+ **_Webservices_**:  Contains all classes and interfaces that is use to communicate with rest service.
+ **_Modules_**: Contains the Viper modules.
+ **_Models_**: Contains all interfaces used in the app as Callbacks and UI Responses.
+ **_Extensions_**: Constants used in many places of app grouped by SharedPreferences, Analytics and General constants.
+ **_Managers_**: Classes to manage objects stored on the mobile database, like User and Session.
+ **_Libraries_**: 3rd party libraries used by the app.
+ **_Helpers_** - Utilities classes used in many places.
 
### Patterns
+ **_Webservice_** layer is done by:
  - Alamofire as *Rest Service* manager.
  - Mantle as *Json Parser*.
+ **_Strings_** are into Localizable.strings

 
### Libraries
The application uses the libraries below:
+ [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP networking library.
+ [Mantle](https://github.com/Mantle/Mantle) - Mantle makes it easy to write a simple model layer for your Cocoa or Cocoa Touch application.
+ [Realm](https://realm.io) - Realm is a mobile database that runs directly inside phones, tablets or wearables.
+ [Facebook](https://github.com/facebook/facebook-sdk-swift) - SDK to Use Facebook API.
+ [FabricIO](https://get.fabric.io/) - Fabric is a platform that helps your mobile team build better apps, understand your users, and grow your business.
+ [Viper Module](https://github.com/Juanpe/Swift-VIPER-Module) - Xcode template for creating Viper modules.

