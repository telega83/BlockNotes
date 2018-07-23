# Test iOS application for management of personal notes

## Instructions
Clone repository
```
git clone git@github.com:telega83/BlockNotes.git
```
Open BlockNotes.xcodeproj with XCode. From **Product -> Destinations** menu select iOS simulator or real plugged in device. Click **Product -> Run** to install application and run.

To see how localizations works please do folowing: Click **Product -> Scheme -> Edit Scheme...**, than select **Run** scheme and select language from **Application Language** drop-down list. An application supports English, Russian and Czech languages. Default language is English.

## Description
While application starts it gets array of notes from the server (**GET /notes** method).
Main view with a list of avaiable notes has **Refresh** button (**GET /notes** method as well) and **Add** button (which calls **POST /notes** method). 
Swiping a cell from right to left gives access to **Delete** button for corresponding note (which calls **DELETE /notes/{id}** after user confirmation).
Tapping a cell will open an edit view of corresponding note. Edit view allows to refresh note's text (**GET /notes/{id}** method), to edit its test and to save text chages if they have reay took place (**PUT /notes/{id}**).

## Note
Had some UI lags while was tesing on simulators. But it works perfectly on real device (iPhone 5s).
