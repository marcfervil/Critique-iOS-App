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
    var votes : [[String : Any]] = []
    var controller: Queue!
    

    init(controller: Queue){
        self.controller = controller
        do{
            if let savedQueue = UserData.getAttribute("queue") as? [Data] {
                if savedQueue.count > 0 {
                    for postData in savedQueue {
                        if let post = try JSONSerialization.jsonObject(with: postData, options: []) as? [String : Any] {
                            queue.append(Post(data: post))
                        }
                    }
                    controller.displayPost(postView: PostView (post: queue[0] ))
                }else{
                     loadPosts()
                }
            }else{
                loadPosts()
            }
        }catch{
            print("Error loading queue!")
        }
    }
    
    func setVote(postId : String, vote: Int){
        votes.append([
            "id" : postId,
            "vote": vote
        ])
    }
    
    func castVotes(_ completion: (() -> Void)? = nil){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: votes, options: .prettyPrinted)
            CastVotesRequest(votes: jsonData).execute( { (response) in
                if completion != nil {
                    completion!()
                }
            })
        }catch {
            
        }
    }
    
    
    func checkForNewContent() {
        loadPosts({ newPosts in
            if !newPosts {
                self.controller.displayPost(postView: EmptyPostView())
            }else{
                
            }
        })
    }
    
    func loadPosts(_ completion: ((_ newResults: Bool) -> Void)? = nil){
        GetQueueRequest().execute({ (request) in
            if let posts = request as? [Any] {
                for post in posts {
                    if let postData = post as? [String : Any] {
                        self.queue.append(Post(data: postData))
                    }
                }
                self.saveQue()
                
                if completion != nil{
                    completion!(posts.count == 0)
                }
            }
        }, { (error) in
            print(error)
        })
    }
    
    func saveQue() {
        var queueData: [Data] = []
        for post in queue {
            queueData.append(post.getJson())
        }
        UserData.setAttribute(key: "queue", value: queueData)
        UserData.save()
    }
    
    
    func getNextPost() -> Post!{
        if queue.count == 2 {
            castVotes()
        }
        if queue.count > 0 {
            return queue.popLast()
        }else{
            return nil
        }
    }
    
}
