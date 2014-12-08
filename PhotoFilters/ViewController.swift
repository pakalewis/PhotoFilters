//
//  ViewController.swift
//  PhotoFilters
//
//  Created by Parker Lewis on 10/13/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import UIKit
import CoreData
import CoreImage
import OpenGLES
import Photos
import Social

class ViewController: UIViewController, ImageSelectedProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var thumbnailsCollection: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var filterNameLabel: UILabel!
    // constraint outlets
    @IBOutlet weak var mainImageViewLeading: NSLayoutConstraint!
    @IBOutlet weak var mainImageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mainImageViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var filterCollectionBottom: NSLayoutConstraint!
    
    var mainImage = UIImage(named: "default_image")
    var mainImageWithFilters = UIImage(named: "default_image")
    var mainThumbnail : UIImage?
    var filters = [Filter]()
    var thumbnailsArray : [ThumbnailContainer]?
    var context : CIContext?
    let imageQueue = NSOperationQueue()
    var tweetButton = UIBarButtonItem()
    var saveButton = UIBarButtonItem()
    
    override func viewWillAppear(animated: Bool) {
        println("viewWillAppear fired")
        // load default image
        self.mainImageView.image = self.mainImage
        
        // make thumbnail
        self.makeThumbnailFromMainImage()
        
        // create array of thumbnails coupled with filters
        self.setUpThumbnailsArray()

        // refresh collection view of the filtered thumbnails
        self.thumbnailsCollection.reloadData()
        
        self.resetNavBarButtons()
        
        self.filterNameLabel.text = "No filter applied"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up for thumbnailsCollection View
        self.thumbnailsCollection.delegate = self
        self.thumbnailsCollection.dataSource = self
        
        // set up context for images
        var options = [kCIContextWorkingColorSpace : NSNull()]
        var myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.context = CIContext(EAGLContext: myEAGLContext, options: options)
        
        // set up activity indicator
        self.activityIndicator.layer.cornerRadius = self.activityIndicator.frame.size.width / 2
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.backgroundColor = UIColor.grayColor()
        self.activityIndicator.opaque = false
        self.activityIndicator.alpha = 0.75
        
        
        // set up core data storage
        // get reference to the appDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        // grab its MOC (where all the Filter entities are made)
        let managedObjectContext = appDelegate.managedObjectContext!
        
        // create a Seeder Object and pass it the MOC (this is where the entities are made and saved)
        let seeder = CoreDataSeeder(context: managedObjectContext)
        
        // fetch Filter objects from Core Data database (create if not already saved)
        var fetchRequest = NSFetchRequest(entityName: "Filter")
        // this will sort the fetch request in alpha order
        var sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: nil)
        if fetchResult?.count == 0 {
            println("There are no Filter objects saved in Core Data yet. Now creating Filter objects and saving to Core Data.")
            // call the Seeder's func that creates the Filter Entities and saves the MOC
            seeder.seedCoreData()
            // populate array with the fetch result
            fetchResult = managedObjectContext.executeFetchRequest(fetchRequest, error: nil)
            self.filters = fetchResult as [Filter]
        } else {
            println("Filter objects are already saved to Core Data")
            // populate array with the fetch result
            self.filters = fetchResult as [Filter]
        }
    }
    
    
    func resetNavBarButtons() {
        saveButton = UIBarButtonItem(title: "Save to Photos", style: UIBarButtonItemStyle.Plain, target: self, action: "saveToPhotoCollections")
        self.navigationItem.leftBarButtonItem = saveButton
        
        self.tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Plain, target: self, action: "postaTweet")
        self.navigationItem.rightBarButtonItem = tweetButton
    }
    
    
    func saveToPhotoCollections() {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            println()
            PHAssetChangeRequest.creationRequestForAssetFromImage(self.mainImageWithFilters)
        }, completionHandler: nil)
    }
    
    
    func postaTweet() {
        if  SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            println("is available")
            
            var tweetSheet : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetSheet.setInitialText("I posted this photo from an app I built using Swift!")
            tweetSheet.addImage(self.mainImageWithFilters)
            
            self.presentViewController(tweetSheet, animated: true, completion: nil)
        } else {
            // present alert controller to say that twitter is unavailable
        }
    }
    
    
    func makeThumbnailFromMainImage() {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        self.mainImage?.drawInRect(CGRect(x: 0, y: 0, width: 100, height: 100))
        self.mainThumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    
    func setUpThumbnailsArray() {
        var thumbnailContainers = [ThumbnailContainer]()
        for filter in self.filters {
            var newThumbnailContainer = ThumbnailContainer(thumb: self.mainThumbnail!, name: filter.name, queue: self.imageQueue, context: self.context!)
            thumbnailContainers.append(newThumbnailContainer)
        }
        self.thumbnailsArray = thumbnailContainers
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_GALLERY" {
            let destinationVC = segue.destinationViewController as GalleryVC
            destinationVC.delegate = self
        }
        if segue.identifier == "SHOW_FRAMEWORK_VC" {
            let destinationVC = segue.destinationViewController as PhotoFrameworkVC
            destinationVC.delegate = self
        }
        if segue.identifier == "SHOW_AVFOUNDATION_VC" {
            let destinationVC = segue.destinationViewController as AVFoundationCameraVC
            destinationVC.delegate = self
        }
    }

    
    @IBAction func myButton(sender: UIButton) {
        // create alert view
        let alertController = UIAlertController(title: nil, message: "Choose photo from:", preferredStyle: UIAlertControllerStyle.ActionSheet)

        // create buttons for the various alert actions
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("SHOW_GALLERY", sender: self)
        }
        let frameworkAction = UIAlertAction(title: "Photos Framework", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("SHOW_FRAMEWORK_VC", sender: self)
        }
        let avFoundationAction = UIAlertAction(title: "AV Foundation", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("SHOW_AVFOUNDATION_VC", sender: self)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.allowsEditing = true
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
            } else {
                var noCameraAlert = UIAlertController(title: "", message: "No camera is available on this device", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                noCameraAlert.addAction(okAction)
                self.presentViewController(noCameraAlert, animated: true, completion: nil)
            }
        }
        let filterAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.morphToFilterMode()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        alertController.addAction(galleryAction)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(frameworkAction)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            alertController.addAction(avFoundationAction)
        }
        alertController.addAction(filterAction)
        alertController.addAction(cancelAction)
        alertController.modalPresentationStyle = UIModalPresentationStyle.PageSheet
        
        // alert controllers need extra info on where to display when on ipad
        // this if only gets entered if device is ipad
        if let pageSheet = alertController.popoverPresentationController {
            pageSheet.sourceView = sender
            pageSheet.sourceRect = sender.bounds
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var imagePicked = info[UIImagePickerControllerEditedImage] as? UIImage
        self.mainImage = imagePicked!
        self.mainImageWithFilters = imagePicked!
        self.mainImageView.image = self.mainImage
        println("image selected from imagePicker")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // this gets called from the various other VCs according to the ImageSelectedProtocol
    func didSelectPicture(image : UIImage) {
        self.mainImage = image
        self.mainImageWithFilters = image
        self.mainImageView.image = self.mainImage
        println("didSelectPicture fired")
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.thumbnailsCollection.dequeueReusableCellWithReuseIdentifier("filteredImageCell", forIndexPath: indexPath) as ThumbnailCell
        let currentCellTag = cell.tag
        
        // get the appropriate thumbnailContainer
        let thumbnailContainer = self.thumbnailsArray![indexPath.row]
        
        // if the thumb has already been filtered, show it in the cell's image
        if thumbnailContainer.filteredThumbnail != nil {
            println("thumb at indexPath \(indexPath.row) already filtered")
            cell.imageView.image = thumbnailContainer.filteredThumbnail
        } else {
            // filtered thumb is not available yet
            println("display original thumb first, then apply filter")
            cell.imageView.image = thumbnailContainer.originalThumbnail
            
            // apply filter to thumb, provided the cell is still visible
            thumbnailContainer.applyFilter({ (filteredThumb) -> Void in
                if currentCellTag == cell.tag {
                    println("filter was applied to thumb, and now is displayed")
                    cell.imageView.image = filteredThumb
                }
            })
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // add button to nav bar to allow user to show original image
        var showOriginal = UIBarButtonItem(title: "Show Original", style: UIBarButtonItemStyle.Bordered, target: self, action: "showOriginalImage")
        self.navigationItem.leftBarButtonItem = showOriginal
        
        // get the name of the filter and apply to the main image
        var filterName = filters[indexPath.row].name
        println("applying this filter to main image: \(filterName)")
        self.applyFilterToMainImage(filterName)
    }
    
    
    func showOriginalImage() {
        self.mainImageView.image = self.mainImage
        self.filterNameLabel.text = "No filter applied"
        self.navigationItem.leftBarButtonItem = nil
    }


    func applyFilterToMainImage(filterName : String) {
        self.activityIndicator.startAnimating()
        
        imageQueue.addOperationWithBlock { () -> Void in
            var ciImage = CIImage(image: self.mainImage)
            var imageFilter = CIFilter(name: filterName)
            imageFilter.setDefaults()
            imageFilter.setValue(ciImage, forKey: kCIInputImageKey)
            
            // additional settings for the added filter
            if imageFilter.name() == "CIBloom" {
                imageFilter.setValue(150.0, forKey: kCIInputRadiusKey)
                imageFilter.setValue(50.0, forKey: kCIInputIntensityKey)
            }
            
            var result = imageFilter.valueForKey(kCIOutputImageKey) as CIImage
            var extent = result.extent()
            var imageRef = self.context?.createCGImage(result, fromRect: extent)
            self.mainImageWithFilters = UIImage(CGImage: imageRef)

            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.mainImageView.image = self.mainImageWithFilters
                self.filterNameLabel.text = "\(filterName) filter applied"
                self.activityIndicator.stopAnimating()
            })
        }
    }

    
    // these two funcs do the animation for showing/hiding the thumbnailsCollection
    func morphToFilterMode() {
        self.mainImageViewBottom.constant = self.mainImageViewBottom.constant * 2.5
        self.filterCollectionBottom.constant = 100
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "exitFilterMode")
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    
    func exitFilterMode() {
        self.mainImageViewBottom.constant = self.mainImageViewBottom.constant / 2.5
        self.filterCollectionBottom.constant = -100
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        self.resetNavBarButtons()
    }
}

