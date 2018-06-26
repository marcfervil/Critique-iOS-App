//
//  User.swift
//  Critique
//
//  Created by Marc Fervil on 25/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import UIKit

class User: NSObject {

    var username : String
    var score : Int
    var isMutual : Bool
    
    init(username: String, score: Int, isMutual: Bool) {
        self.username = username
        self.score = score
        self.isMutual = isMutual
    }
    
    func getUsername() -> String {
        return username
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getIsMutual() -> Bool {
        return isMutual
    }
    
    convenience init(_ prop : [String : Any]){
        self.init(username: (prop["username"] as? String)!, score: (prop["score"] as? Int)!, isMutual: (prop["isMutual"] as? Bool)!)
    }
    
}
