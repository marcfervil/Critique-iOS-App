//
//  QueueHandler.swift
//  Critique
//
//  Created by Marc Fervil on 9/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation


class QueueHandler {
    
    var queue : [Post] = []
    
    init(){
       loadPosts()
    }
    
    func loadPosts(completion: (() -> Void)? = nil){
        GetQueueRequest().execute({ (request) in
            if let posts = request as? [Any] {
                for post in posts {
                    if let postData = post as? [String : Any] {
                        self.queue.append(Post(data: postData))
                    }
                }
            }
        }, { (error) in
            print(error)
        })
    }
    
    
    func getNextPost() -> Post!{
        if queue.count > 0 {
            return queue.popLast()
        }else{
            return nil
        }
    }
    
}
