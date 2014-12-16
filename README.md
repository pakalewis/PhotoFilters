Week 2 project for the Code Fellows iOS Development Accelerator

![](https://github.com/pakalewis/PhotoFilters/blob/master/screenshot1.png)
---------------------------------------------------------------------------------------------------
____________________________________________________________________________________________________________________
![](https://github.com/pakalewis/PhotoFilters/blob/master/screenshot2.png)

This app interacts with photos in various ways.
The user can:
- choose a photo from a gallery or take a picture from the device's camera or library
- apply a CIFilter
- save the filtered photo to the native Photos app
- post a tweet from the App via the Twitter account


Features:
- Action sheet alerts
- Custom pinch gesture recognizer class that is used in multiple ViewControllers
- Protocols
- CoreData
- AVFoundation
- UICollectionView with header and footer (UICollectionReusableView)
- UIImagePickerController
- Photos framework



Monday
- Add an action sheet to the home view controller that gives the user options of choosing a photo from the gallery or the camera.
- Create the gallery view controller that displays the photos provided in a collection view.
- Create a custom protocol for when a user selects a photo from the gallery. The protocol method should pass back the UIImage they select and then the home view controller should display the photo.
- Implement UIImagePickerController for the camera and allow the user to take a picture with the camera and then have the photo show up in the image view on the home view controller.

Tuesday
- Implement core data and store at least 10 filters in your data store.
- Create a collection view that displays thumbnails of the selected photo with each filter applied to it.
- When a user selects a filtered thumbnail it should apply the filter to the primary image.

Wednesday
- Incorporate the photos framework into your app. Create a separate view control that is used just for displaying photos fetched from the framework.
- Create a way to get the selected photo from the photos framework back to the main view controller. Remember each photo is represented by a PHAsset. And you will want to request a new photo since the size will be much bigger for the main image view.

Thursday
- Implement the pinch to zoom recognizer for zooming in and out of your gallery and/or photos frame work view controller. Make sure there is some sort of restriction on it, so i can't zoom in and out forever.
- Plug in the AVFoundationSwift view controller provided in the class repo. Run it on your device and see how it works.


Challenges:
- Use the social framework to post the filtered photo to a social network.
- Use the Photos Framework to save the filtered photo to the users Photos collection.
- Add a filter not mentioned in the gitter.im chat room that needs extra input keys.
