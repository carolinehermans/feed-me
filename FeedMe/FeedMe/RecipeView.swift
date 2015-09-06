//
//  RecipeView.swift
//  
//
//  Created by Jordan Brown on 9/5/15.
//
//

import UIKit

class RecipeView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "RecipeView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }

}
