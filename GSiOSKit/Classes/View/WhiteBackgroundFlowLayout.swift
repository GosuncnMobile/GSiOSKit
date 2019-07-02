//
// WhiteBackgroundFlowLayout.swift 
// ACS-OM 
// 
// Created by Linzy on 2019/5/20. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import UIKit
class WhiteBackgroundCollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
public class WhiteBackgroundFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        register(WhiteBackgroundCollectionReusableView.self, forDecorationViewOfKind: "WhiteBackgroundCollectionReusableView")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
//        let layoutAttributes = UICollectionViewLayoutAttributes.init(forDecorationViewOfKind: elementKind, with: indexPath)
//        let lastIndex = collectionView?.numberOfItems(inSection: indexPath.section) ?? 0 - 1
//        if lastIndex < 0 {
//            return layoutAttributes
//        }
//        guard let firstItem = self.layoutAttributesForItem(at: IndexPath.init(row: 0, section: indexPath.section)),
//        let lastItem = self.layoutAttributesForItem(at: IndexPath.init(row: lastIndex, section: indexPath.section)) else {
//             return layoutAttributes
//        }
//
//        layoutAttributes.zIndex = -1
//        layoutAttributes.frame = CGRect.init(x: 0, y: firstItem.frame.minY,
//                                             width: collectionViewContentSize.width,
//                                             height: (lastItem.frame.origin.y - firstItem.frame.origin.y + firstItem.frame.size.height))
//        return layoutAttributes
//    }
//    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else{
            return nil
        }
        var allAttributes = [UICollectionViewLayoutAttributes].init()
        for attr in attributes{
            if attr.representedElementCategory == UICollectionView.ElementCategory.cell,
                attr.frame.origin.x == self.sectionInset.left{
                let decorationAttributes = UICollectionViewLayoutAttributes.init(forDecorationViewOfKind:"WhiteBackgroundCollectionReusableView" ,
                                                                                 with: attr.indexPath)
                decorationAttributes.frame = CGRect.init(x: 0, y: attr.frame.origin.y,
                                                         width: collectionViewContentSize.width, height: attr.frame.size.height)
                decorationAttributes.zIndex =  -1
                allAttributes.append(decorationAttributes)
                
            }
        }
        allAttributes.append(contentsOf: attributes)
        return allAttributes
    }
}
