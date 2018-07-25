//
//  MutualsScreen.swift
//  Critique
//
//  Created by Marc Fervil on 20/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation
import UIKit

class Mutuals : UIViewController , UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    
    var data : [[String : Any]] = [[ : ]]
    
    @IBOutlet weak var MutualsTableView: UITableView!
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tag = 1
        MutualsTableView.dataSource = self
        MutualsTableView.delegate = self
     

        self.MutualsTableView.rowHeight = 80
    
        
        SearchBar.delegate = self
        
        doSearch(query: "")
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        doSearch(query: searchBar.text!)
    }
    
    func doSearch(query : String){
        if(query.count > 0){
            SearchRequest(query).execute({ (request) in
                self.data = request as! [[String : Any]]
                self.updateResults()
            }, { (error) in
                print("error searching")
            })
        }else{
            if UserData.getAttribute("mutuals") != nil {
                self.data = UserData.getAttribute("mutuals") as! [[String : Any]]
                updateResults()
            }else{
                print("error loading mutuals")
            }
        }
    }
    
    func updateResults(){
        DispatchQueue.main.async(execute: {
            let range = NSMakeRange(0, self.MutualsTableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.MutualsTableView.reloadSections(sections as IndexSet, with: .automatic)
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        let user = User(data[indexPath.row])
    
        cell.Username.text? = user.getUsername()
        cell.Score.text? = String(user.getScore())
        
        if let url = URL(string: "http://localhost:5000/getPatch/"+user.getUsername()) {
            Util.downloadImage(url: url, completion: { (img) in
                cell.ProfilePicture?.image = img!
            })
        }
        
        cell.ProfilePicture?.layer.borderWidth = 0
        cell.ProfilePicture?.layer.cornerRadius = 8
        cell.ProfilePicture?.backgroundColor = .purple
        cell.ProfilePicture?.clipsToBounds = true
   
        if(user.isMutual){
            cell.makeMutualButton()
        }else{
            cell.makePendingButton()
        }
        
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
