//
//  PostView.swift
//  Critique
//
//  Created by Marc Fervil on 8/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation
import UIKit

class PostView: UIView{


    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var post : Post?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(post : Post?){
        super.init(frame: CGRect() )
        self.post = post
        commonInit()
        setUp()
    }

    func setUp(){
        setUI()
    }
    
    func setUI(){
        titleLabel.text = post!.title
        contentLabel.text = post!.content
        usernameLabel.text = "posted by "+post!.username
        

        
        profilePicture.layer.borderWidth = 0
        //profilePicture.layer.masksToBounds = false
        //profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = 8
        profilePicture.clipsToBounds = true
        

        if let url = URL(string: "http://localhost:5000/getPatch/"+post!.username) {
            //profilePicture.contentMode = .scaleAspectFit
            
            downloadImage(url: url, completion: { (img) in
                self.profilePicture.image = img!
            })
        }
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> ()) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                completion(UIImage(data: data))
            }
        }
    }
    

    
    func getNibName() -> String{
        return "PostView"
    }
    
    override func didMoveToSuperview(){
        super.didMoveToSuperview()
        if superview?.bounds != nil {
            self.frame = superview!.bounds
        }
    }
    

    private func commonInit(){
        Bundle.main.loadNibNamed(getNibName(), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]  
    }
    
}
