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
    
    var text = ["ye","okay","sup"]
    
    @IBOutlet weak var MutualsTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return text.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        /*
        let fruitName = fruits[indexPath.row]
        cell.label?.text = fruitName
        cell.fruitImageView?.image = UIImage(named: fruitName)
        */
        //cell.imageView?.image = col
        
       // cell.imageView?.backgroundColor =  UIColor.red
        
        cell.Username.text? = text[indexPath.row]
        
        self.MutualsTableView.tableFooterView = UIView()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tag = 1
        MutualsTableView.dataSource = self
        MutualsTableView.delegate = self
    }
    
}
