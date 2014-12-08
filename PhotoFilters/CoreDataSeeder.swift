//
//  CoreDataSeeder.swift
//  PhotoFilters
//
//  Created by Parker Lewis on 10/14/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import Foundation
import CoreData

class CoreDataSeeder {
    var managedObjectContext : NSManagedObjectContext!
    
    init (context : NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    func seedCoreData() {
        let bloom = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        bloom.name = "CIBloom"
        bloom.favorited = false
        
        let effectNoir = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        effectNoir.name = "CIPhotoEffectNoir"
        effectNoir.favorited = false
        
        
        let sepia = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        sepia.name = "CISepiaTone"
        sepia.favorited = false
        
        
        let mono = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        mono.name = "CIPhotoEffectMono"
        mono.favorited = false
        
        
        let instant = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        instant.name = "CIPhotoEffectInstant"
        instant.favorited = false
        
        
        let chrome = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        chrome.name = "CIPhotoEffectChrome"
        chrome.favorited = false
        
        
        let tonal = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        tonal.name = "CIPhotoEffectTonal"
        tonal.favorited = false
        
        
        let transfer = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        transfer.name = "CIPhotoEffectTransfer"
        transfer.favorited = false
        
        
        let gaussianBlur = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        gaussianBlur.name = "CIGaussianBlur"
        gaussianBlur.favorited = false
        
        
        let pixellate = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        pixellate.name = "CIPixellate"
        pixellate.favorited = false
        
        
        let exposureAdjust = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext!) as Filter
        exposureAdjust.name = "CIExposureAdjust"
        exposureAdjust.favorited = false
        
        
        var error : NSError?
        self.managedObjectContext?.save(&error)
        
        if error != nil {
            println("There was an error saving to core data. The error says \(error!.localizedDescription)")
        }

        
    }
}
