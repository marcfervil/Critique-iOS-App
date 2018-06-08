//
//  SelectionView.swift
//  Critique
//
//  Created by Marc Fervil on 7/6/18.
//  Copyright © 2018 Marc Fervil. All rights reserved.
//

import Foundation
import UIKit

class SelectionView: UIView{
    
    @IBOutlet var contentView: UIView!
    var selected = 1
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("SelectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.frame
        contentView.backgroundColor = Util.getColor("primaryDark")
        updateColors()
    }
    
    func updateColors(){
        for i in 0...contentView.subviews.count-1 {
            if i == selected {
                contentView.subviews[i].backgroundColor = Util.getColor("primaryDark").darker()
            }else{
                contentView.subviews[i].backgroundColor = Util.getColor("primaryDark")
            }
        }
    }
    
    
    func selectNext(){
        if selected == 2 {
            return
        }
        selected += 1
        updateColors()
    }
    
    func selectLast(){
        if selected == 0 {
            return
        }
        selected -= 1
        updateColors()
    }
    
    
}
