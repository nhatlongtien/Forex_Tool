//
//  CustomLayout.swift
//  Forex Tool
//
//  Created by Tien Nguyen on 15/12/2021.
//

import Foundation
import UIKit
class CustomLayout:UICollectionViewFlowLayout{
    var previousOffSet:CGFloat = 0.0
    var currentPage = 0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let itemCount = cv.numberOfItems(inSection: 0)
        if previousOffSet > cv.contentOffset.x && velocity.x < 0.0{
            currentPage = max(currentPage-1, 0)
        }else if previousOffSet < cv.contentOffset.x && velocity.x > 0.0{
            currentPage = min(currentPage + 1, itemCount - 1)
        }
        print("CurrentPage: \(currentPage)")
        
        
        let offset = updateOfSet(cv)
        previousOffSet = offset
        return CGPoint(x: offset, y: proposedContentOffset.y)
    }
    func updateOfSet(_ cv:UICollectionView) -> CGFloat{
        let w = cv.frame.width
        let itemW = itemSize.width
        let sp = minimumLineSpacing
        let edge = (w - itemW - sp*2)/2
        let offset = (itemW + sp) * CGFloat(currentPage) - (edge + sp)
        return offset
    }
}
