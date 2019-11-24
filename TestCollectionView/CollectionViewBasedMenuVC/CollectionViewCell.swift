//
//  CollectionViewCell.swift
//  TestCollectionView
//
//  Created by Nguyen Dinh Cong on 2019/11/24.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    var level: Int = 0 {
        didSet {
            leftConstraint.constant = CGFloat(20 * (level + 1))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
