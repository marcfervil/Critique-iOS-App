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
    
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var PostHolder: UIScrollView!
    
    var selectionView : SelectionView!
    
    var hasScrolled = false
    
    var motionCounter = CGFloat(0)
 
    @IBOutlet weak var scroller: UIScrollView!
    
    @IBOutlet weak var NavBar: UINavigationBar!
    
    override func viewDidLoad() {
     
        motionCounter = 0
        
        refreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(pulled),for: UIControlEvents.valueChanged)
            return refreshControl
        }()
        
        //NavBar!.backgroundColor =
        
        NavBar!.barTintColor = Util.getColor("primary")

        
        
        selectionView = SelectionView(frame:self.refreshControl!.bounds)
        selectionView.clipsToBounds = true;
        
        refreshControl.addSubview(selectionView)
        refreshControl.tintColor = UIColor.clear
        
        scroller.delegate = self
        scroller.refreshControl = refreshControl
        
         let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDragging))
         recognizer.cancelsTouchesInView = false
         recognizer.delegate=self
       
         scroller.addGestureRecognizer(recognizer)

        let a = PostView(frame: self.scroller.bounds)
        scroller.addSubview(a)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func scrollViewDidScroll (_ scrollView : UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            selectionView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: scrollView.contentOffset.y * -1 )
        }
    }
    
    
    func switched(s: UISwitch){
        let origin: CGFloat = s.isOn ? view.frame.height : 50
        UIView.animate(withDuration: 0.35) {
            self.scroller.frame.origin.y = origin
        }
    }
    
    func selected(_ selection : Int){
        
       // let b = SelectionView(frame:self.refreshControl!.bounds)
       print(selection)
        
        
        //switchView.frame = CGRect(x: 0, y: 20, width: 40, height: 20)
        //scroller.subviews[0].addTarget(self, action: #selector(switched), for: .valueChanged)
    }
    
    
    
    
    @objc func handleDragging(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == .ended) {
            selected(selectionView.selected)
        }else if (recognizer.state == .changed) {
            let point = recognizer.velocity(in: recognizer.view?.superview)
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
    
    @objc func pulled(){
        refreshControl.endRefreshing()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


