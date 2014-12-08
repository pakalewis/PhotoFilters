//
//  PhotoFrameworkVC.swift
//  PhotoFilters
//
//  Created by Parker Lewis on 10/15/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import UIKit
import Photos

class PhotoFrameworkVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var photoFrameworkCollection : UICollectionView!
    var flowLayout : UICollectionViewFlowLayout!

    
    var delegate : ImageSelectedProtocol?
    
    var frameworkImageArray = [UIImage]()
    
    var imageManager: PHCachingImageManager!
    var assetFetchResults: PHFetchResult!
//    var assetCollection: PHAssetCollection!
    var asset : PHAsset?
    var assetCellSize: CGSize!

    var pinchAction = ReactToPinch()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // get image manager
        self.imageManager = PHCachingImageManager()
        // fetch all assets
        self.assetFetchResults = PHAsset.fetchAssetsWithOptions(nil)
        
        // get size of the device screen and use it to determine the asset cell size for the collection view
        var scale = UIScreen.mainScreen().scale
        self.flowLayout = self.photoFrameworkCollection.collectionViewLayout as UICollectionViewFlowLayout
        var cellSize = flowLayout.itemSize
        self.assetCellSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)
        
        // create pinch gesture
        var pinchGesture = UIPinchGestureRecognizer(target: pinchAction, action: "pinchAction:")
        // set properties on my ReactToPinch object (this has the method that resizes the flowlayout
        pinchAction.collectionView = self.photoFrameworkCollection
        pinchAction.flowLayout = self.flowLayout

        // add pinch gesture to collectionView
        self.photoFrameworkCollection.addGestureRecognizer(pinchGesture)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.photoFrameworkCollection.dequeueReusableCellWithReuseIdentifier("FRAMEWORK_CELL", forIndexPath: indexPath) as FrameworkCell
        self.asset = self.assetFetchResults[indexPath.row] as? PHAsset
        self.imageManager.requestImageForAsset(asset, targetSize: self.assetCellSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
            self.frameworkImageArray.append(image)
            cell.imageView.image = image
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetFetchResults.count
    }

    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // download image data and make full size UIImage. pass back to main VC
        self.asset = self.assetFetchResults[indexPath.row] as? PHAsset
        self.imageManager.requestImageDataForAsset(self.asset, options: nil) { (data, string, orientation, info) -> Void in
            let largeImage = UIImage(data: data)
            self.delegate?.didSelectPicture(largeImage!)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
