# RUMHousing
![RUMHousing](assets/images/logo/temp-logo.png)

## Flutter Project: semesterprojectuprmonlinemarketplace

### Project Structure

The following tree shows how files and directories are organized in the project root.

```
semester-project--uprm-online-marketplace/	# [project root]
├── .github/		# [GitHub-related files]
├── assets/		 # [project assets directory]
│   └── images/
├── Documentation/
├── images/
├── lib/		    # [flutter app source code]
│   └── src/		# [developer source code]
│       ├── Classes/
│       ├── housing/
│       └── main.dart
├── test/		   # [flutter test directory]
├── web/		    # [flutter web directory]
├── .gitignore	      # [files to ignore]
├── .gitmessage.txt	 # [commit template file]
├── .metadata 	      # [flutter project file]
├── LICENSE.metrics 	# [metric files license]
├── README.md	       # [project readme file]
├── analysis_options.yaml   # [flutter project file]
├── gh_metrics_config.json  # [metric configuration file]
├── pubspec.lock 	   # [flutter project file]
└── pubspec.yaml 	   # [flutter project file]
```

Here are the most important directories of this project:
- 'lib' - core of the Flutter application. All Dart code goes here.
- 'test' - Dart tests goes here.
- 'web' - contains necessary files to run the Flutter application in web browsers. **Developers must not touch anything in this directory.**

*Read more about Flutter project structure [here](https://medium.com/@logeshgcp/understanding-the-flutter-project-structure-84de4ec3ce5f).*

### Source Code Main Directory

Code created by develpers goes inside the directory 'lib/src'.

```
├── lib/
│   └── src/
│       ├── Classes/
│       ├── housing/
│       └── main.dart
```

From the previous tree:
- 'lib' will only have a directory 'src'. This is to make it clear to developers where the source code must go.
- 'src' will contain all source code created by developers.
- 'main.dart' is the starting point of the application.
- 'Classes/' and 'housing/' are directories created by developers. These will have code related to their names. Developers may create as many as needed, these directories will keep the source code organized.

## Overview
The **RUMHousing Marketplace** is a centralized platform designed to help students at the University of Puerto Rico at Mayagüez (UPRM) find housing more efficiently. It aims to streamline the rental process by offering clear listings, direct communication with landlords, and verified profiles to reduce fraudulent listings.

## Features
- **User Authentication**: Secure login and user role management (students, landlords, and administrators).
- **Property Listings**: Landlords can list available properties with images, pricing, and amenities.
- **Search & Filtering**: Advanced filtering options based on price, location, and housing type.
- **Messaging System**: Secure in-app communication between landlords and tenants.
- **Verification System**: Ensures legitimacy of landlords and property listings.
- **Interactive Map**: Displays available properties using Google Maps API.
- **Reviews & Ratings**: Tenants can rate landlords and provide feedback.

## Technology Stack
- **Frontend**: Flutter (Dart) for cross-platform development (Web, iOS, Android)
- **Backend & Database**: Firebase Firestore (NoSQL) for real-time data storage
- **Authentication & Security**: Firebase Authentication for user verification
- **Messaging System**: Firebase Realtime Database for live chat functionality
- **Location Services**: Google Maps API for property mapping

## Installation
To run the project locally, follow these steps:

1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo-name/marketplace.git
   cd marketplace
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the project:
   ```sh
   flutter run
   ```

## Usage
1. **Sign Up/Login**: Create an account as a student or landlord.
2. **Browse Listings**: Use filters to find suitable housing.
3. **Contact Landlords**: Use the built-in chat feature.
4. **Post a Listing** (Landlords only): Upload housing details and manage availability.
5. **Review & Rate**: Provide feedback on landlords or properties.

## License
This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details.

