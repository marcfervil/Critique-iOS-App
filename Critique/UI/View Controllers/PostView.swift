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
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
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
        commonInit()
        setUI()
    }

    func setUI(){
        titleLabel.text = post!.title
        contentLabel.text = post!.content
        usernameLabel.text = "posted by "+post!.username
    }
    

    private func commonInit(){
        Bundle.main.loadNibNamed("PostView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]  
    }
    
}
