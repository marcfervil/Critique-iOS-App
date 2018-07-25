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
   
    var offset : CGFloat = 0
    
    @IBOutlet weak var selectionViewHolder: UIView!
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    var selectionView: SelectionView!
    

    var queue : QueueHandler!
    
    var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y:0, width: 20, height: 20))
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    let impact = UIImpactFeedbackGenerator()
    
    
   

    
    var recognizer : UIGestureRecognizer?
    
    override func viewDidLoad() {
        
        queue = QueueHandler(controller: self)
        
        
        
        initNavBar()
        initSelectionView()
        initScrollView()
        
        //print(UserData.getAttribute("mutuals"))
        
        view.tag = 0
        
    }
    
    @objc func rightArrowPress(sender: UIKeyCommand) {
        self.selected(2)
    }
    
    @objc func leftArrowPress(sender: UIKeyCommand) {
        self.selected(0)
    }
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: UIKeyInputRightArrow, modifierFlags: [], action: #selector(rightArrowPress) ),
            UIKeyCommand(input: UIKeyInputRightArrow, modifierFlags: [], action: #selector(leftArrowPress) )
        ]
    }
    

 

    
    func displayPost(postView: PostView){
      
            postView.bounds.origin.y = -self.scrollView.bounds.height
            self.scrollView.addSubview(postView)
            UIView.animate(withDuration: 0.2, animations: {
                postView.bounds.origin.y = 0
            } , completion : { _ in
                if self.currentPost != nil {
                    self.currentPost.removeFromSuperview()
                }
                self.currentPost = postView
            } )
        
    }

    func renderPost(post: Post!){
        if post == nil {
            queue.checkForNewContent()
        }else{
            displayPost(postView:  PostView(post: post))
        }
    }
    
    func initNavBar(){
        navBar!.barTintColor = Util.getColor("primary")
        self.navBarItem!.leftBarButtonItem?.customView = UIView(frame: CGRect(x: 0, y:0, width: 0, height: 0))
    }
    
    func loading(){
        DispatchQueue.main.async() {
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            self.navBarItem!.leftBarButtonItem?.customView = self.activityIndicator
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopLoading(){
        DispatchQueue.main.async() {
            self.activityIndicator.stopAnimating()
            self.navBarItem!.leftBarButtonItem?.customView = nil
        }
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
        recognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDragging))
        recognizer!.cancelsTouchesInView = false
        recognizer!.delegate=self
        recognizer?.isEnabled = true
        scrollView!.addGestureRecognizer(recognizer!)
  
    }
    

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(offset > 5)
    }


   
    func selected(_ selection : Int){
        if(selection != 1){
            self.selectionView.selected = 1
            self.selectionView.updateColors()
            
            
            //CHANGE THIS TO MAKE VOTING VALID LATER
            if queue.currentPost != nil {
                queue.setVote(postId: queue.currentPost.id, vote: 1)
            }
           
            renderPost(post: queue.getNextPost())
            
        }
    }
    
    func collapseSelectionView(){
        recognizer?.isEnabled = false
        self.selectionView.collapse()
        self.offset = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.scrollView.contentOffset.y = 0
            self.recognizer?.isEnabled = true
        } , completion : { _ in
            self.selected(self.selectionView.selected)
        } )
    }

    @objc func handleDragging(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == .ended) {
            collapseSelectionView()
        }else if (recognizer.state == .changed ) {
            let point = recognizer.velocity(in: recognizer.view?.superview)
            let translation = recognizer.translation(in: recognizer.view?.superview)
            offset = translation.y
            
            if offset < 1 {
                offset = 0
            } else if offset > 50 {
                offset = 50
            }
            selectionView.frame = CGRect(x: 0, y: 0, width: selectionViewHolder.frame.width, height: offset )
            selectionViewHolder.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            scrollView.contentOffset.y = -offset
      
            if offset > 30 {
                motionCounter += point.x
                let threshold = CGFloat(2000)
                if motionCounter > threshold {
                    selectionView.selectNext()
                     impact.impactOccurred()
                    motionCounter = 0
                }else if motionCounter < -threshold {
                    selectionView.selectLast()
                     impact.impactOccurred()
                    motionCounter = 0
                }
            }
                
        }
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

