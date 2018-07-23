# Test iOS application for management of personal notes

## Instructions
Clone repository
```
git clone git@github.com:telega83/BlockNotes.git
```
Open BlockNotes.xcodeproj with XCode. From **Product -> Destinations** menu select iOS simulator or real plugged in device. Click **Product -> Run** to install application and run.

To see how localizations works please do folowing: Click **Product -> Scheme -> Edit Scheme...**, than select **Run** scheme and select language from **Application Language** drop-down list. An application supports English, Russian and Czech languages. Default language is English.

## Description
While application starts it gets array of notes from the server (* *GET /notes method* *).
