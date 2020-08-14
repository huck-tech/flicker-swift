------------------------------------------------------------------
Project Setup With Cocoapods (installing dependencies)
------------------------------------------------------------------

*This step can most likely be skipped as dependencies have been included in the repository for your convenience. If the project builds successfully in Xcode you are all set, if not revert back to this step.*

**open a terminal window (command line)**

1) Download Cocoapods.
```
#!BashLexersudo gem install cocoapods
sudo gem install cocoapods
```

2) Install dependencies.

```
#!BashLexercd
cd <REPO LOCATION>/Flicker/
ls
# you should see a file called *Podfile* here.
pod install
# if successful you should have created/regenerated the .xcworkspace and download all the dependencies for the project.
```

------------------------------------------------------------------
Opening The Project
------------------------------------------------------------------
 - Project requires using Xcode 9.2
 - Open the Flicker.**xcworkspace** with Xcode on a Mac

***
# Fastlane

This project uses Fastlane to automate the building, testing and deployment of this project. You must first install Fastlane on your mac and have the latest version of Xcode installed. Fastlane should handle updating provisioing profiles, running unit tests and most importantly archiving and uploading builds to TestFlight and the AppStore. 

##### Fastlane commands must be run in the root of the project

## Installing Fastlane

1) Download/Install
```
#!BashLexer
sudo gem install fastlane
```

2) Install latest Xcode Tools
```
#!BashLexer
sudo xcode-select --install
```

3) Add Path
```
#!BashLexer
export PATH="$HOME/.fastlane/bin:$PATH"
```

4) Check Installation
```
#!BashLexer
fastlane --version
```

##Testing
Run the unit tests manually.


```
#!BashLexer
fastlane test
```

##Archiving and Uploading

###AppStore
####The build that goes in the AppStore. The production build.

```
#!BashLexer
fastlane appstore
```
