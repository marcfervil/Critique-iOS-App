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
    @IBOutlet weak var profilePicture: UIImageView!
    
    var post : Post?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(frame: CGRect, post : Post){
        super.init(frame: frame)
        self.post = post
    }

    private func commonInit(){
        Bundle.main.loadNibNamed("PostView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
    }
    
}
