//
//  Queue.swift
//  Critique
//
//  Created by Marc Fervil on 3/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation
import UIKit

class Queue: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var mainView: UIView!

    var motionCounter = CGFloat(0)
 
    var currentPost : PostView!
    
    var recentContentOffset = CGPoint(x:0, y:0)

    @IBOutlet weak var selectionViewHolder: UIView!
    
    
    var selectionView: SelectionView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        initNavBar()
        initSelectionView()
        initScrollView()
        renderPost(post: nil)
        
        
        //scrollView.addSubview(selectionView)
    }
    

    
    func renderPost(post: Post!){
        let postView = PostView(frame: scrollView.bounds)
        postView.bounds.origin.y = -scrollView.bounds.height
        scrollView.addSubview(postView)
        UIView.animate(withDuration: 0.3, animations: {
            
            //print(self.scrollView.contentOffset.y)
            postView.bounds.origin.y = 0
            
            
        } , completion : { _ in
            if self.currentPost != nil {
                self.currentPost.removeFromSuperview()
            }
            self.currentPost = postView
            
        } )
    }
    
    func initNavBar(){
         navBar!.barTintColor = Util.getColor("primary")
    }
    
    func initSelectionView(){

       
        
        selectionView = SelectionView(frame: CGRect(x: 0 , y: 0, width: scrollView.frame.width, height: 0))
 
        selectionView.clipsToBounds = false
        
        selectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       
        self.selectionViewHolder.layer.zPosition = 1;
        
        selectionViewHolder.addSubview(selectionView)
    }
    

    
    func initScrollView(){
        scrollView.delegate = self

        scrollView.bounces = false
        

        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDragging))
        recognizer.cancelsTouchesInView = false
        recognizer.delegate=self
        scrollView.addGestureRecognizer(recognizer)
        
        
        
    }
    
    @objc func handleSwipe(_ sender:UISwipeGestureRecognizer) {
        

        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    
    func scrollViewDidScroll (_ scrollView : UIScrollView) {
  
        /*
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            selectionView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: scrollView.contentOffset.y * -1 )
        }
        */
 
    }
    
   
    func selected(_ selection : Int){
        //renderPost(post: nil)
    }
    
    
    @objc func handleDragging(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == .ended) {

            
            self.selectionView.collapse()
            
            
            UIView.animate(withDuration: 0.2, animations: {
                self.scrollView.contentOffset.y = 0
            })
     
            
        }else if (recognizer.state == .changed) {
            let point = recognizer.velocity(in: recognizer.view?.superview)
            
            var c = recognizer.translation(in: recognizer.view?.superview)
            
            
            if c.y < 1 {
                c.y = 0
            }
            
            selectionView.frame = CGRect(x: 0, y: 0, width: selectionViewHolder.frame.width, height: c.y )
 
            selectionViewHolder.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            scrollView.contentOffset.y = -c.y
      
            
            motionCounter += point.x
            let threshold = CGFloat(2000)
            if motionCounter > threshold {
                selectionView.selectNext()
                motionCounter = 0
            }else if motionCounter < -threshold {
                selectionView.selectLast()
                motionCounter = 0
            }
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

