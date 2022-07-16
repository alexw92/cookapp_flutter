# cookable_flutter
# Owner : Awesome CEO Alex
[flutter-fire](https://firebase.flutter.dev/docs/auth/overview)

##Run in web:
use
```bash
flutter run -d chrome --web-port 5000 . 
``` 
when adding new oauth origins in google. It takes some time to update (minutes). 
The port is important. Localhost:5000 is currently configured as Google's oauth accepted URL.

##Generate Android/IOS icons

```flutter pub run flutter_launcher_icons:main```
They dont look so good using this. Try another approach to generate the icons manually
using this [Android Asset Studio](https://romannurik.github.io/AndroidAssetStudio/index.html)

##Icons for notifications appearing in background and notification bar

Here a white icon with transparent background should be used (AndroidManifest.xml)
```xml
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_icon"
        android:resource="@mipmap/ic_launcher" />
```

##Icons for notifications appearing in foreground

Here a colored icon with transparent background should be used (main.dart)
```dart
NotificationDetails(
android: AndroidNotificationDetails(
channel.id,
channel.name,
channelDescription: channel.description,
//      one that already exists in example app.
icon: '@mipmap/ic_launcher' 
),
```

**Build release**

This will also fix some annoying issues occurring in debug build like laggy scrolling in lists
```
flutter run --release
```

**Firebase Sha-Certificate**

Happens if google-services.json is not up-to-date with Sha-Hash:

Unhandled Exception: PlatformException

Todo: 
```
./gradlew signingReport
```
Copy Sha1-Key to Firebase and then download new google-services.json and provide it in the app.

**Cors Config on Firebase Bucket to load imgs from flutter web while Testing:**

```
(cookable-flutter)$ touch cors.js
(cookable-flutter)$ nano cors.js
(cookable-flutter)$ mv cors.js cors.json
(cookable-flutter)$ gsutil cors set cors.json gs://cookable-flutter.appspot.com
```
## Hive
Possible solution for storing data from api
[Hive docs](https://docs.hivedb.dev/#/basics/hive_in_flutter)
[Hive pub.dev](https://pub.dev/packages/hive)
[Hive with rest](https://medium.com/flutter-community/flutter-cache-with-hive-410c3283280c)

To create model/adapter (and also to update it after making changes to it!)
```
flutter pub run build_runner build
```

Then import adapter

## Ingredient Recognition TFLite
Looks pretty promising! Let's add this if there is time
Check the [google automl docs](https://cloud.google.com/vision/automl/object-detection/docs), 
[Tensorflow Lite docs](https://www.tensorflow.org/lite/examples/object_detection/overview#example_applications_and_guides)
and [Flutter TFlite module](https://pub.dev/packages/tflite_flutter)
![sample](https://cloud.google.com/vision/automl/object-detection/docs/images/index_test_image.png)


# UI Ideas
Most notes are written directly in the image
## The current login page
This page is currently displayed on app start when no user is logged in.
If a user is logged in it is displayed as long as it takes to load the data (recipes and so on) from the backend
We plan to spare users from registration but we still need a page which displays during app start for loading.
I'd suggest a screen showing the app logo and a progress bar and if the backend says there are promotions, a promotion card
which we could display here

![loginpage](./current_loginpage.jpg)
## Use inventory screen/ fridge
This is the first screen displayed when loading has completed
Added some notes in the image. We should also consider using a better background (white is a bit boring). A customizable theme would be cool!
Later we could group this view into groups like meat, veggie, spices...

![userinventory](./grocery_user_inventory.jpg)
## Grocery Details screen
This screen is displayed when clicking on a grocery icon in the fridge/inventory screen

![grocery_details](./grocery_details_view.jpg)
## Add Grovery screen
This screen is displayed when clicking on the "plus" in the fridge/inventory screen.
It is really ugly. The barcode icon can be left out completely.
What I have in mind for this is a filterable list which requests the api on each input.
Then if the user has found what he wants he should be able to click on it and specify the desired amount he currently has.
Would be cool to display this and the grocery details screen on top of the inventory.

![addgrocery](./add_grocery_view.jpg)

## Current Behavior of "add grocery" screen

![addgrocery_combo](./add_food_combobox.jpg)

## Recipe view

Added some notes in the image. We should also consider using a better background (white is a bit boring). A customizable theme would be cool
The recipe view should apply a clear highlighting of cookable and now or weak highlighting of uncookable recipes.
Since this feature is the core of this app. We should think about a more stylish way than just applying a stronger color.
I could also imagine displaying recipes which only lack one single grocery differently. Also we should think about how to display
recipes with ingredients the user has in his inventory but in too low amounts.

![recipes_list](./cookable_uncookable_recipes_list.jpg)
## Recipe details screen

The next two images show the recipe details screen. We should use a cool light background here.

![recipe_details_unsuff](./recipe_details_insufficient.jpg)
![recipe_details_ok](./recipe_details_sufficient.jpg)
## Cook recipe stepper

This shows the instructions using a material stepper component. I can imagine a lot adjustments to what is displayed
in here. So we should keep it customizable

![instructions_stepper](./recipe_instructions_stepper.jpg)

## (Yet) Uncovered Features
* :x: **About Page: ** This should be accessable easily over the menu. We need to include a reference for the icons we currently use for groceries (Usage agreement)
* :x: **MISSING INGREDIENT:** Very often a user won't find a grocery he has! We need to offer our users a way (e.g. once filtering for groceries delivers no results) to just apply  for a grocery to be added to the db. Nethertheless the preprovided db should cover most cases
* :x: **MISSING RECIPE/ADD RECIPE:** Registered users should be able to add their own recipes including intructions and images. We will probably need a sophisticated stepper component. Recipes who are uploaded by a user should also by editable by him.
* :x: **RATE RECIPE:** Very important feature that should be implemented. Registered users should be able to rate a recipe once.
* :heavy_check_mark: **NUTRITON:** A super important issue for everyone I want to target with this app. Values should be calculated by the backend using the sum of of the ingredient nutritions

## Technical issues
* :x: All images should be cached with an appropriate framework (We currently use cached_network_image, but not sure if caching works^^)
* :x: We need to be able to handle errors from the backend at all time and should use material snackbars to display it (we can beautify later)
* :x: Since we dont use registration we should define the point when registration is mandatory
  + As long as the user is unverified we need some identifier for him to apply a preregistration [check this!!](https://firebase.google.com/docs/auth/web/anonymous-auth)
  + From the point when we want to register we can do Firebase auth to do a full registration [by linking the already existing account](https://firebase.flutter.dev/docs/auth/usage/#linking-user-accounts)
  + We might also need to include a data usage agreement
  + This is to check if user was signed in anonymously  
```dart
    var user = FirebaseAuth.instance.currentUser;
    print(user.isAnonymous);
```
  + This is to link anonymous account [link](https://firebase.google.com/docs/auth/web/anonymous-auth)
```dart
import { GoogleAuthProvider } from "firebase/auth";

const credential = GoogleAuthProvider.credential(
        googleUser.getAuthResponse().id_token);
```
* :x: The number of recipes, instructions could potentially very large - We should not load everything at the beginning, especially images need huge bandwith
* :heavy_check_mark: We need a good library for proper scaling of images
* :x: We should add a settings page offering config options for
  + UI - Theme
  + Checkbox - No image load on wifi


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
