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
    
    
    var selectionView: SelectionView!
    
    var queue : QueueHandler = QueueHandler()
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    let impact = UIImpactFeedbackGenerator()
    
    
    var recognizer : UIGestureRecognizer?
    
    override func viewDidLoad() {
        initNavBar()
        initSelectionView()
        initScrollView()
    }
    

    func renderPost(post: Post!){
        let postView = PostView(frame: scrollView.bounds, post: post)
        postView.bounds.origin.y = -scrollView.bounds.height
        scrollView.addSubview(postView)
        UIView.animate(withDuration: 0.2, animations: {
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
        recognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDragging))
        recognizer!.cancelsTouchesInView = false
        recognizer!.delegate=self
        scrollView!.addGestureRecognizer(recognizer!)
  
    }
    

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !(offset > 5)
    }


   
    func selected(_ selection : Int){
        if(selection != 1){
            self.selectionView.selected = 1
            self.selectionView.updateColors()
            
            //renderPost(post: queue.getNextPost())
            renderPost(post: Post(username: "marc", title: "title", content: "content", type: "text", votes: 0))
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
        }else if (recognizer.state == .changed && HomeScreen.scrolling) {
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

