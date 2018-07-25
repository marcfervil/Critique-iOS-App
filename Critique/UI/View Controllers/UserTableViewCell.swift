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
    
    @IBOutlet weak var actionButton: UIButton!
    
    var state : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func mutualButtonClick(_ sender: Any) {
        //makeMutualButton()
        //makeFriendButton()
        
        if state == "mutual" {
            FollowRequest(Username.text!,false).execute({ _ in 
                self.makeFollowButton()
            }, { (error) in
                print(error)
            })
        }
        
    }
    
    
    func updateButton(text: String, textColor: UIColor, backgroundColor: UIColor, borderColor : UIColor? = nil){
        
        DispatchQueue.main.async() {
        
            self.actionButton.backgroundColor = backgroundColor
            self.actionButton.setTitle(text, for: .normal)
            
            self.actionButton.setTitleColor(textColor, for: .normal)
            self.actionButton.layer.borderWidth = 1
            self.actionButton.layer.cornerRadius = 5
            self.actionButton.contentEdgeInsets  = UIEdgeInsetsMake(10,10,10,10)
            
            if(borderColor == nil){
                self.actionButton.layer.borderColor = backgroundColor.cgColor
            }else{
                self.actionButton.layer.borderColor = borderColor?.cgColor
            }
            
        }
        
    }
    
    
    func makeMutualButton(){
        state = "mutual"
        updateButton(text: "mutual", textColor: .white, backgroundColor: Util.getColor("primary"))
    }

    
    func makeFollowButton(){
        state = "follow"
        updateButton(text: "follow", textColor: .white, backgroundColor:  Util.getColor("accent"))
    }

    
    func makePendingButton(){
        state = "pending"
        
        updateButton(text: "pending",
                     textColor: Util.getColor("primary"),
                     backgroundColor:  UIColor.white,
                     borderColor: Util.getColor("primary")
        )

        
    }
    
}
