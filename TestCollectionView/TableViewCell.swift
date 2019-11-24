//
//  TableViewCell.swift
//  TestCollectionView
//
//  Created by Nguyen Dinh Cong on 2019/11/24.
//  Copyright © 2019 Cong Nguyen. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var title: UILabel!
    
    var level: Int = 0 {
        didSet {
            leftConstraint.constant = CGFloat(20 * (level + 1))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
