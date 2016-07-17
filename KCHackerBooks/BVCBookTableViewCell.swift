//
//  BVCBookTableViewCell.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 14/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import UIKit

class BVCBookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var favImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None;
    }

}