//
//  Queue.swift
//  Critique
//
//  Created by Marc Fervil on 3/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation
import UIKit

class Queue: UIViewController, UIScrollViewDelegate {
    
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var PostHolder: UIScrollView!
    
    var refreshLoadingView : UIView!
    
    @IBOutlet weak var queueHeading: UINavigationBar!
    
 
    override func viewDidLoad() {
        
        queueHeading.backgroundColor = Util.getColor("primary")
        queueHeading.barTintColor = Util.getColor("primary")
        queueHeading.alpha = 100.0
        //queueHeading.inp
        
        refreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(pulled),for: UIControlEvents.valueChanged)
            return refreshControl
        }()
        refreshLoadingView = UIStackView(frame:self.refreshControl!.bounds)
        refreshLoadingView.backgroundColor = Util.getColor("primaryDark")
        refreshLoadingView.clipsToBounds = true;
        
       
        
        self.refreshControl!.addSubview(refreshLoadingView)
        self.refreshControl!.tintColor = UIColor.clear
        
        PostHolder.delegate = self
        
        PostHolder.refreshControl = refreshControl

        
    }
    
    func scrollViewDidScroll (_ scrollView : UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
           // refreshLoadingView.frame.height =
            //print(scrollView.contentOffset.y)
            refreshLoadingView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: scrollView.contentOffset.y * -1 )
            
        }
    }
    
    @objc func pulled(){
        print("pulled?")
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
