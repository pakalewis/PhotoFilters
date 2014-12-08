//
//  ThumbnailContainer.swift
//  PhotoFilters
//
//  Created by Parker Lewis on 10/14/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import UIKit

class ThumbnailContainer {
    var originalThumbnail : UIImage
    var filterName : String
    var imageQueue : NSOperationQueue?
    var gpuContext : CIContext?
    var filteredThumbnail : UIImage?

    
    // change to pass in queue and gpu context from main vc
    init(thumb : UIImage, name : String, queue : NSOperationQueue, context : CIContext) {
        self.originalThumbnail = thumb
        self.filterName = name
        self.imageQueue = queue
        self.gpuContext = context
    }

    func applyFilter (completionHandler : (image : UIImage) -> Void) {        
        self.imageQueue?.addOperationWithBlock({ () -> Void in
            var ciImage = CIImage(image: self.originalThumbnail)
            var imageFilter = CIFilter(name: self.filterName)
            imageFilter.setDefaults()
            imageFilter.setValue(ciImage, forKey: kCIInputImageKey)
            var result = imageFilter.valueForKey(kCIOutputImageKey) as CIImage
            var extent = result.extent()
            var imageRef = self.gpuContext?.createCGImage(result, fromRect: extent)
            self.filteredThumbnail = UIImage(CGImage: imageRef)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(image: self.filteredThumbnail!)
            })
        })
    }
}

