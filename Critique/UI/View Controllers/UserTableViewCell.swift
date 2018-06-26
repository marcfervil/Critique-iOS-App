//
//  UITableViewCell.swift
//  Critique
//
//  Created by Marc Fervil on 20/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation
import UIKit

class UserTableViewCell : UITableViewCell {


    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var Score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    
}
