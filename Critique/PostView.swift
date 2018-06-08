//
//  PostView.swift
//  Critique
//
//  Created by Marc Fervil on 8/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation
import UIKit

class PostView: UIView{
 
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(){
        Bundle.main.loadNibNamed("PostView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
       // contentView.backgroundColor = Util.getColor("primaryDark")

    }
    
}
