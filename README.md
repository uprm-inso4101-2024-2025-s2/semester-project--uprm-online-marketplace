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

*[This article](https://codewithandrea.com/articles/flutter-project-structure/) had influence in choosing 'lib/src' as the directory for source code.*

## Flutter: Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
