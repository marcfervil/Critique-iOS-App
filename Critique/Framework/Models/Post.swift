//
//  Post.swift
//  Critique
//
//  Created by Marc Fervil on 9/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation


class Post{
    
    var username: String
    var content: String
    var type: String
    var votes: [String : Any] = [ : ]
    var voteTotal: Int = 0
    var title: String
    
    init(username: String, title: String, content: String, type: String, votes: Any) {
        
        
        self.username = username
        self.content = content
        self.type = type
        self.title = title

        if let v = votes as? [String : Any]{
            self.votes = v
        }else if let v = votes as? Int{
            self.voteTotal = v
        }
        
    }
    
    convenience init(data : [String : Any]){
        
        //print(data)
        
        self.init(
            username: data["username"] as! String,
            title: data["title"] as! String,
            content: data["content"] as! String,
            type:  data["type"] as! String,
            votes: data["votes"] as! Int
        )
    }
    
    
    
    
    
}
