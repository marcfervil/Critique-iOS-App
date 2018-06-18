//
//  ApiRequests.swift
//  Critique
//
//  Created by Marc Fervil on 2/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation


class LoginRequest : ApiRequest{
    
    init(_ username : String, _ password : String){
        super.init("login", [
            "username" : username,
            "password" : password
        ], key: false)
    }
    
}


class GetQueueRequest : ApiRequest{
    init(){
        super.init("getQueue")
    }
}

class CastVotesRequest : ApiRequest{
    init(votes : [String : Any]){
        super.init("castVotes", votes)
    }
}
