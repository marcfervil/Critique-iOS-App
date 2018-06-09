//
//  ViewController.swift
//  Critique
//
//  Created by Marc Fervil on 2/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserData.loadData() {
            login()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func saveLoginData(data : [String : Any]){
        UserData.setAttribute(key: "apiKey", value: data["sessionKey"]!)
        UserData.setAttribute(key: "username", value: data["username"]!)
        UserData.setAttribute(key: "score", value: data["score"]!)
        UserData.setAttribute(key: "mutuals", value: data["following"]!)
        UserData.save()
    }
    
    func login(){
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        })
    }
    
    
    func notify(_ title : String, _ message : String, _ buttonText : String){
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: nil))
            self.present(alert, animated: true)
        })
    }
    
    
    @IBAction func LoginButton(_ sender: Any) {
        if  ( usernameTextField.text != nil && passwordTextField.text != nil) {
            LoginRequest(usernameTextField.text!, passwordTextField.text!).execute({ (request) in
                if let loginInfo = request as? [String : Any] {
                    self.saveLoginData(data: loginInfo)
                    self.login()
                }
            }, { (error) in
                self.notify("Whoops!", error, "I am sorry")
            })
        }
    }
        
        
    
    
    
}

