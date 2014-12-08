//
//  ReactToPinch.swift
//  PhotoFilters
//
//  Created by Parker Lewis on 10/16/14.
//  Copyright (c) 2014 Parker Lewis. All rights reserved.
//

import UIKit


class ReactToPinch: NSObject {
    
    var collectionView : UICollectionView?
    var flowLayout : UICollectionViewFlowLayout?
    
    override init() {
        
    }
    
    func pinchAction(pinchGesture: UIPinchGestureRecognizer) {
        if pinchGesture.state == UIGestureRecognizerState.Ended {
            self.collectionView!.performBatchUpdates({ () -> Void in
                var currentWidth = self.flowLayout!.itemSize.width
                var currentHeight = self.flowLayout!.itemSize.height

                var screenSize = UIScreen.mainScreen().bounds
                println("screen size bounds")
                println(screenSize.width)
                println(screenSize.height)

                println(self.collectionView!.layoutMargins.left)
                
                println("collection view bounds")
                println(self.collectionView!.bounds.width)
                println(self.collectionView!.bounds.height)
                
                println(screenSize.width - self.collectionView!.layoutMargins.left - self.collectionView!.layoutMargins.right - 20)
//                var minCellWidth = (screenSize.width - self.collectionView!.layoutMargins.left - self.collectionView!.layoutMargins.right - 30) / 3.0
                var minCellWidth = (screenSize.width - 20) / 9.0
                var maxCellWidth = (screenSize.width - 50) / 2.0
                println("minCellWidth = \(minCellWidth)")
                println("maxCellWidth = \(maxCellWidth)")
                println("currentWidth = \(currentWidth)")
                
                
                if pinchGesture.velocity > 0 {
                    // embiggen
                    if (currentWidth * 2) < maxCellWidth {
                        self.flowLayout!.itemSize = CGSize(width: currentWidth * 2, height: currentHeight * 2)
                    } else {
                        self.flowLayout!.itemSize = CGSize(width: maxCellWidth, height: maxCellWidth)
                    }
                } else {
                    // shrink
                    if (currentWidth * 0.5) > minCellWidth {
                        self.flowLayout!.itemSize = CGSize(width: currentWidth * 0.5, height: currentHeight * 0.5)
                    } else {
                        self.flowLayout!.itemSize = CGSize(width: minCellWidth, height: minCellWidth)
                    }
                }
            }, completion: nil )
        }
    }
   
}
