//
// GirdImageRow.swift 
// SwiftDemo 
// 
// Created by Linzy on 2019/4/4. 
// Copyright © 2019 Gosuncn. All rights reserved.
// 


import Foundation
import Eureka

public protocol GirdImageRowDateSource {
    func setGirdImageView(imageView:UIImageView);
}

public class GridUrl: GirdImageRowDateSource {
    public func setGirdImageView(imageView: UIImageView) {
        imageView.kf.setImage(with: URL(string: girdUrl))
    }
    
    var girdUrl: String
    public init(girdUrl: String) { self.girdUrl = girdUrl }
    
    
}

public final class GirdImageRow : Row<GridImageCell>,RowType{

    public required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<GridImageCell>.init()
        self.value = NSMutableArray()
    }
    
    public override func updateCell() {
        super.updateCell()
    }


}

