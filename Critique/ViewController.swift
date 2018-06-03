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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func LoginButton(_ sender: Any) {
        
        if  ( usernameTextField.text != nil && passwordTextField.text != nil) {
            LoginRequest(usernameTextField.text!, passwordTextField.text!).execute({ (request) in
                if let loginInfo = request as? [String : Any] {
                    //save data and login or something 
                }
            }, { (error) in
                let alert = UIAlertController(title: "Whoops!", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "I am sorry", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
        }
        }
        
        
    
    
    
}

