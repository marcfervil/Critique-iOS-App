//
//  MutualsScreen.swift
//  Critique
//
//  Created by Marc Fervil on 20/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation
import UIKit

class Mutuals : UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    
    var mutuals : [[String : Any]] = [[ : ]]
    
    @IBOutlet weak var MutualsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tag = 1
        MutualsTableView.dataSource = self
        MutualsTableView.delegate = self
     

        self.MutualsTableView.rowHeight = 80
        
        if UserData.getAttribute("mutuals") != nil {
            mutuals = UserData.getAttribute("mutuals") as! [[String : Any]]
        }
        
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mutuals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        let user = User(mutuals[indexPath.row])
    
        cell.Username.text? = user.getUsername()
        cell.Score.text? = String(user.getScore())
        
        if let url = URL(string: "http://localhost:5000/getPatch/"+user.getUsername()) {
         //profilePicture.contentMode = .scaleAspectFit
            
            Util.downloadImage(url: url, completion: { (img) in
                cell.ProfilePicture?.image = img!
            })
        }
        
        cell.ProfilePicture?.layer.borderWidth = 0
        cell.ProfilePicture?.layer.cornerRadius = 8
        cell.ProfilePicture?.backgroundColor = .purple
        cell.ProfilePicture?.clipsToBounds = true
        
        
        self.MutualsTableView.tableFooterView = UIView()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewWillLayoutSubviews() {
        var frame : CGRect = self.MutualsTableView.frame;
        frame.size.height = self.MutualsTableView.contentSize.height;
        self.MutualsTableView.frame = frame;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    

    
}
