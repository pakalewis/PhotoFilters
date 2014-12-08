//
//  GalleryVC.swift
//  PhotoFilters
//
//  Created by Parker Lewis on 10/13/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import UIKit

class GalleryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var galleryCollectionView: UICollectionView!

    var imageArray = [UIImage]()
    var image1 = UIImage(named: "1.jpg")
    var image2 = UIImage(named: "2.jpg")
    var image3 = UIImage(named: "3.jpg")
    var image4 = UIImage(named: "4.jpg")
    var image5 = UIImage(named: "5.jpg")
    var image6 = UIImage(named: "6.jpg")
    var image7 = UIImage(named: "7.jpg")
    var image8 = UIImage(named: "8.jpg")
    var image9 = UIImage(named: "9.jpg")
    var image10 = UIImage(named: "10.jpg")
    var image11 = UIImage(named: "11.jpg")

    
    var flowLayout : UICollectionViewFlowLayout!
    var pinchAction = ReactToPinch()

    var delegate : ImageSelectedProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        var image1thumb = self.makeThumbnail(image1!, size: CGSize(width: 300.0, height: 300.0))
        var image2thumb = self.makeThumbnail(image2!, size: CGSize(width: 300.0, height: 300.0))
        var image3thumb = self.makeThumbnail(image3!, size: CGSize(width: 300.0, height: 300.0))
        var image4thumb = self.makeThumbnail(image4!, size: CGSize(width: 300.0, height: 300.0))
        var image5thumb = self.makeThumbnail(image5!, size: CGSize(width: 300.0, height: 300.0))
        var image6thumb = self.makeThumbnail(image6!, size: CGSize(width: 300.0, height: 300.0))
        var image7thumb = self.makeThumbnail(image7!, size: CGSize(width: 300.0, height: 300.0))
        var image8thumb = self.makeThumbnail(image8!, size: CGSize(width: 300.0, height: 300.0))
        var image9thumb = self.makeThumbnail(image9!, size: CGSize(width: 300.0, height: 300.0))
        var image10thumb = self.makeThumbnail(image10!, size: CGSize(width: 300.0, height: 300.0))
        var image11thumb = self.makeThumbnail(image11!, size: CGSize(width: 300.0, height: 300.0))

        self.imageArray = [
            image1thumb, image2thumb, image3thumb, image4thumb, image5thumb, image6thumb, image7thumb, image8thumb, image9thumb, image10thumb, image11thumb,
            image1thumb, image2thumb, image3thumb, image4thumb, image5thumb, image6thumb, image7thumb, image8thumb, image9thumb, image10thumb, image11thumb,
            image1thumb, image2thumb, image3thumb, image4thumb, image5thumb, image6thumb, image7thumb, image8thumb, image9thumb, image10thumb, image11thumb,
            image1thumb, image2thumb, image3thumb, image4thumb, image5thumb, image6thumb, image7thumb, image8thumb, image9thumb, image10thumb, image11thumb,
            image1thumb, image2thumb, image3thumb, image4thumb, image5thumb, image6thumb, image7thumb, image8thumb, image9thumb, image10thumb, image11thumb,
            image1thumb, image2thumb, image3thumb, image4thumb, image5thumb, image6thumb, image7thumb, image8thumb, image9thumb, image10thumb, image11thumb,
            image1thumb, image2thumb, image3thumb, image4thumb, image5thumb, image6thumb, image7thumb, image8thumb, image9thumb, image10thumb, image11thumb,
            image1thumb, image2thumb, image3thumb, image4thumb, image5thumb, image6thumb, image7thumb, image8thumb, image9thumb, image10thumb, image11thumb,
            image1thumb, image2thumb, image3thumb, image4thumb, image5thumb, image6thumb, image7thumb, image8thumb, image9thumb, image10thumb, image11thumb,
            image1thumb, image2thumb, image3thumb, image4thumb, image5thumb, image6thumb, image7thumb, image8thumb, image9thumb, image10thumb, image11thumb
        ]
        
        
        self.flowLayout = self.galleryCollectionView.collectionViewLayout as UICollectionViewFlowLayout
        // create pinch gesture
        var pinchGesture = UIPinchGestureRecognizer(target: pinchAction, action: "pinchAction:")
        // set properties on my ReactToPinch object (this has the method that resizes the flowlayout
        pinchAction.collectionView = self.galleryCollectionView
        pinchAction.flowLayout = self.flowLayout
        
        // add pinch gesture to collectionView
        self.galleryCollectionView.addGestureRecognizer(pinchGesture)
    }

    
    func makeThumbnail(image : UIImage, size : CGSize) -> UIImage {
        let size = size
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRect(x: 0, y: 0, width: 300, height: 300))
        var imageThumb = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageThumb
    }

    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCell
        cell.imageView!.image = self.imageArray[indexPath.row]
        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // pass the selected image back to the main VC
        self.delegate?.didSelectPicture(self.imageArray[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // set up header and footer views
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader {
            let reusableView : GalleryHeader = galleryCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "GALLERY_HEADER", forIndexPath: indexPath) as GalleryHeader
            reusableView.headerLabel.text = "Images from unsplash.com"
            return reusableView
        }
        else {
            let reusableView : GalleryFooter = galleryCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "GALLERY_FOOTER", forIndexPath: indexPath) as GalleryFooter
            reusableView.footerLabel.text = "\(self.imageArray.count) images available"
            return reusableView
        }
    }
}
