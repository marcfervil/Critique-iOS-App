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
    var currentPost : Post!
    var votes : [[String : Any]] = []
    var controller: Queue!
    var isVoting = false

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
                    
                    
                    
                    if let currentPost = UserData.getAttribute("currentPost") as? Data {
                        if let post = try JSONSerialization.jsonObject(with: currentPost, options: []) as? [String : Any] {
                            controller.displayPost(postView: PostView (post: Post(data: post )))
                        }
                    }
                    
                }else{
                     checkForNewContent()
                }
            }else{
                checkForNewContent()
            }
        }catch{
            print("Error loading queue!")
        }
        UserData.queue = self
    }
    
    func setVote(postId : String, vote: Int){
        votes.append([
            "id" : postId,
            "vote": vote
        ])
    }
    
    func castVotes(_ completion: (() -> Void)? = nil){
        
        if (isVoting) {
            return
        }
        
        isVoting = true
        
        CastVotesRequest(votes: [ "votes" : votes ]).execute( { (response) in
            self.votes = []
            self.isVoting = false
            if completion != nil {
                completion!()
            }
        })
    }
    
    
    func checkForNewContent() {
        controller.loading()
        loadPosts({ newPosts in
            DispatchQueue.main.async() {
                var post : PostView = EmptyPostView()
                if newPosts {
                    post = PostView(post: self.getNextPost())
                }
                self.controller.displayPost(postView: post)
                self.controller.stopLoading()
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
                    completion!(posts.count != 0)
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
        if(currentPost != nil){
            UserData.setAttribute(key: "currentPost", value: currentPost.getJson())
        }
        UserData.save()
    }
    
    
    func getNextPost() -> Post!{
        if queue.count == 2 && !isVoting{
            castVotes({
                self.loadPosts({ (newPosts) in
                    self.controller.stopLoading()
                })
            })
        }
        if queue.count > 0 {
            currentPost = queue.remove(at: 0)
            saveQue()
            return currentPost
        }else{
            return nil
        }
    }
    
}
