# RUMHousing
![RUMHousing](assets/images/logo/temp-logo.png)

## Flutter Project: semesterprojectuprmonlinemarketplace

### Project Structure

The following tree shows how files and directories are organized in the project root.

```
semester-project--uprm-online-marketplace/	# [project root]
├── .github/                  # [GitHub-related files]
├── assets/                   # [project assets directory]
│   └── images/
├── Documentation/
├── lib/                      # [flutter app source code]
│   └── src/                  # [developer source code]
│       ├── Classes/
│       ├── housing/
│       └── main.dart
├── test/                     # [flutter test directory]
├── web/                      # [flutter web directory]
├── README.md                 # [project readme file] 
├── ...
└── CONFIGURATION-FILES 
```

Here are the most important directories of this project:
- 'lib' - core of the Flutter application. All Dart code goes here.
- 'test' - Dart tests goes here.
- 'web' - contains necessary files to run the Flutter application in web browsers. **Developers must not touch anything in this directory.**

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

_You can read about various CONFIGURATION-FILES and a more complete description of the project structure [here](https://github.com/uprm-inso4101-2024-2025-s2/semester-project--uprm-online-marketplace/wiki/Project-Structure)._

## Flutter: Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
