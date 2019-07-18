//
//  GSiOSKit+GSiOSKitAsset.swift
//  GSiOSKit
//
//  Created by kismet adler on 2019/7/17.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(GSAssetName: String) {
        let podBundle = Bundle(for: GirdImageCollectionCell.self)
        guard let url = podBundle.url(forResource: "GSiOSKit",withExtension: "bundle") else {
            return nil
        }
        self.init(named: GSAssetName,
                  in: Bundle(url: url),
                  compatibleWith: nil)
    }
}
