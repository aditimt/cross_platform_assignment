# cross_platform_assignment

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.


Project SetUp

Flutter SetUp
 - Download flutter installation bundle from https://docs.flutter.dev/get-started/install/macos
 - Unzip bundle in your desired location 
    cd ~/development
    unzip ~/Downloads/flutter_macos_3.16.0-stable.zip
 - Add the flutter tool to your path:
    export PATH="$PATH:`pwd`/flutter/bin"
 - Command to check there are any dependencies you need to install  
    flutter doctor
If all dependencies are installed, then 
 - Created project using command: flutter create cross_platform_assignment
                              cross_platform_assignment is PROJECT_NAME
 - To run project used command: flutter run


SetUp for Back4App Database:
  - Create account in Back4App website https://dashboard.back4app.com
  - Go to app > build new app > Backend as a service > enter app name (crossPlatformAssignment) > Database (NoSQL database)
  - Once app setup is done, create a class 'Task', add coloumn to class 'title' and 'description' of data type String.

Databse setup in Flutter code:
 - Add Parse sdk in "pubspec.yaml" under "dependencies", parse_server_sdk_flutter: ^7.0.0
 - Install dependencies using command "flutter pub get"
 - Go to main.dart file, import Parse sdk file, 
           import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
 - Add keyApplicationId, keyClientKey and keyParseServerUrl in main() function
               final keyApplicationId = '90hhlwIoaixMRVx1cESXcTBArw6hWMNxukoZdgtD';
               final keyClientKey = 'GcRd2yBkJobW0hfenKrbqpss24YxIhz55cs8eSII';
               final keyParseServerUrl = 'https://parseapi.back4app.com';   
               we will get application key and client key from back4app website. Go to CrossPlatformAssignment app > AppSettings > Security & Keys > Application Id / Client key  
 - Now initlialize Parse sdk in main method
              await Parse().initialize(keyApplicationId, keyParseServerUrl, clientKey: keyClientKey, debug: true);

Features included in app:
- Fetch tasks list from DB
- Create new task and save in DB
- get task details on tap of Task
- Edit and update task (Bonus feature)
- Delete task (Bonus feature)            
