//
//  ApiRequest.swift
//  Critique
//
//  Created by Marc Fervil on 2/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation
import UIKit

class ApiRequest {
    
    var params: [String: Any]
    var path: String
    
   
    
    init(_ path : String, _ params : [String: Any] = [:], key : Bool = true){
        self.params = params
        self.path = path
        
        if (key){
            self.params["apiKey"] = UserData.getAttribute("apiKey")
        }
        
    }
    

    
    func execute(_ callback: @escaping (_ data : Any?) -> Void, _ errorCallback: ((_ data : String) -> Void )? = nil ) {
        postRequest(params, path, { (response) in
            if let status = response["status"] as? String{
                if status == "ok" {
                    
                    if response["response"] == nil {
                        callback(nil)
                        return
                    }
    
                    callback(response["response"]!)
               
                    
                
                }else{
                    if let errorMessage = response["response"] as? String {
                        DispatchQueue.main.async(execute: {
                            if errorCallback != nil {
                                print("ERROR FROM SERVER: "+errorMessage)
                                errorCallback!(errorMessage)
                            }
                        })
                    }
                }
            }
        })
    }
    
    func postRequest(_ params : [String: Any], _ path: String, _ callback: @escaping (_ data : [String: Any]) -> Void){
        
        let url: String = "http://localhost:5000/"+path
        //let url: String = "http://10.0.0.223:5000/"+path
        
        guard let urlConnection = URL(string: url) else {
            print("Could not connect to Critique Server")
            return
        }
        var urlRequest = URLRequest(url: urlConnection)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let jsonParams: Data
        do {
            jsonParams = try JSONSerialization.data(withJSONObject: params, options: [])
            //let convertedString = String(data: jsonParams, encoding: String.Encoding.utf8)
            
            urlRequest.httpBody = jsonParams
            
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let response = try JSONSerialization.jsonObject(with: responseData,options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                callback(response)
            } catch  {
                print("error parsing response")
                return
            }
        }
        task.resume()
    }
    
    
    
}

