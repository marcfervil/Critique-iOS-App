//
//  HomeScreen.swift
//  Critique
//
//  Created by Marc Fervil on 3/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation
import UIKit

class HomeScreen : UIPageViewController, UIPageViewControllerDataSource,UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    let pages = ["PagesContentController1", "MutualsScreen"]
    let pageChache : [String: ViewController] = [ : ]
    static var scrolling = false
    var currentPage = 0
    var queuePage : Queue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PagesContentController1")

        
        if let a = vc as? Queue {
            queuePage = a
        }
        
        for subview in self.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
                break;
            }
        }
        
        setViewControllers([vc!], direction: .forward, animated: true, completion: { _ in
            HomeScreen.scrolling = false

        })
        
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        
        
        
        
        
        HomeScreen.scrolling = true
        self.queuePage?.collapseSelectionView()
        
        
        
    }
    
    
    @objc func finishedScroll() -> Bool{
        
       
        return true
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
    
                if index > 0 {
                    
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index-1])
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {

                if index < pages.count - 1 {
                    
                    
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            }else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
       
        if (!completed)
        {
            return
        }
        self.currentPage = pageViewController.viewControllers!.first!.view.tag //Page Index
        print(self.currentPage)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
       
        if (currentPage == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (currentPage == pages.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (self.currentPage == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        } else if (currentPage == pages.count - 1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
            targetContentOffset.pointee = CGPoint(x: scrollView.bounds.size.width, y: 0);
        }
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                
                
                return index
            }
        }
        return 0
    }
    
    
}
