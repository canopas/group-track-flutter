<p align="center"> <a href="https://canopas.com/contact"><img src="screenshots/cta_banner.png" alt=""></a></p>

# GroupTrack - Stay connected, Anywhere!
Enhancing family safety and communication with real-time location sharing and modern UIs.

<img src="screenshots/cover_image.png"  alt="cover"  width="100%"/>

## Overview
Welcome to GroupTrack, an open-source Flutter application designed to enhance family safety 👫 through real-time location sharing 📍 and communication features 💬. GroupTrack aims to provide peace of mind by ensuring the safety 🛣 of your loved ones while facilitating seamless communication regardless of their location.

GroupTrack adopts a declarative UI approach with Flutter and utilizes [flutter riverpod](https://pub.dev/packages/flutter_riverpod) for state management. This architecture promotes a clear separation of concerns, making the codebase more maintainable, scalable, and testable. Flutter’s widget-based system allows for the creation of highly responsive UIs, while flutter riverpod ensures efficient state handling across different components, leading to a smooth and intuitive user experience.

## Download App
<a href="https://play.google.com/store/apps/details?id=com.canopas.yourspace"><img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" width="200"></img></a>


## Features
GroupTrack is currently in active development 🚧, with plans to incorporate additional features shortly.

GroupTrack ensures your loved ones' well-being with:

- Create and Join Spaces: Set up your own personalised spaces and invite others to join, or become part of an existing group to stay connected.
- Live Location Sharing: Share your real-time location with members of your space, allowing them to follow your journey and stay informed about your whereabouts.
- Track Journeys: Whether it's your own route or someone else's, track journeys in real-time to ensure smooth navigation and timely arrivals.
- Place Notifications: Add specific places within your space, and get notified whenever a member enters or leaves that location, making coordination effortless.
- Real-Time Chat: Stay in touch with other space members through built-in chat functionality, enabling you to coordinate, plan, or simply catch up in real-time.

## Screenshots

<table>
  <tr>
    <th width="33%" >Create/Join Space</th>
    <th  width="33%" >Share Location</th>
  </tr>
  <tr>
    <td><img src="screenshots/create_space.gif"  alt="Family Safety At Your Fingertips"/></td>
    <td> <img src="screenshots/location_tracking.gif"   alt="Say Goodbye to 'Where are You?' Texts "/> </td>
  </tr>
</table>

<table>
  <tr>
    <th width="33%" >Geofencing</th>
    <th  width="33%" >Communication</th>
  </tr>
  <tr align="center">
    <td><img src="screenshots/place.gif"  alt="Customize Your Places According to Your Needs"/></td>
    <td> <img src="screenshots/message.gif"   alt="Chat with Your Loved Ones Anytime, Anywhere"/> </td>
  </tr>
</table>

## Requirements
Ensure you have the latest stable version of Android Studio installed
You can then proceed by either cloning this repository or importing the project directly into Android Studio, following the steps provided in the [documentation](https://developer.android.com/jetpack/compose/setup#sample).
<details>
     <summary> Click to expand </summary>

### Google Maps SDK
To enable the MapView functionality, obtaining an API key as instructed in the [documentation](https://developers.google.com/maps/documentation/android-sdk/get-api-key) is required. This key should then be included in the local.properties for android and Info.plist for ios file as follows:

Android:
```
MAPS_API_KEY=your_map_api_key
```

IOS:
```
<key>ApiMapKey</key>
<string>your_map_api_key</string>
```
Note: Set iOS minimum deployment target to 14.0 or higher

### Add config.dart
Inside the `data/lib` directory, create a new file named `config.dart`. This file will store your place API key, follow format:
```
class AppConfig {
  static const String placeApiKey = 'YOUR PLACE API KEY';
}
```

### Firebase Setup
To enable Firebase services, you will need to create a new project in the [Firebase Console](https://console.firebase.google.com/).
Use the `applicationId` value specified in the `app/build.gradle` file of the app as the Android package name.
Once the project is created, you will need to add the `google-services.json` file to the `android/app` module for android and `ios/Runner` module for IOS.
For more information, refer to the [Firebase documentation](https://firebase.google.com/docs/flutter/setup?platform=android).

GroupTrack uses the following Firebase services, Make sure you enable them in your Firebase project:
- Authentication (Phone, Google, Apple)
- Firestore (To store user data)
</details>

## Tech stack

GroupTrack utilizes the latest Flutter technologies and adheres to industry best practices. Below is the current tech stack used in the development process:

- Flutter Riverpod
- Dart
- async + Stream
- Go Router
- SQLite
- Freezed
- Firebase Authentication
- Firebase Firestore
- Cloud Functions
- Google Maps Flutter

## Contribution
Currently, we are not accepting any contributions.

## Credits
GroupTrack is owned and maintained by the [Canopas team](https://canopas.com/). You can follow them on Twitter at [@canopassoftware](https://twitter.com/canopassoftware) for project updates and releases. If you are interested in building apps or designing products, please let us know. We'd love to hear from you!

<a href="https://canopas.com/contact"><img src="./screenshots/cta_btn.png" width=300></a>

## License

GroupTrack is licensed under the Apache License, Version 2.0.

```
Copyright 2024 Canopas Software LLP

Licensed under the Apache License, Version 2.0 (the "License");
You won't be using this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
