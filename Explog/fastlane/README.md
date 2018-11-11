fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios provision
```
fastlane ios provision
```
Creating a code signing certificate and provisioning profile
### ios screenshot
```
fastlane ios screenshot
```
Create Screnshots
### ios make_frame
```
fastlane ios make_frame
```
Cover Device Frame into exsting Images for App stroe 
### ios build
```
fastlane ios build
```
Create ipa
### ios upload
```
fastlane ios upload
```
Upload to App Stroe

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
