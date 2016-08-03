//
//  Rating.swift
//  CustomTableView
//
//  Created by User on 8/3/16.
//  Copyright © 2016 TrangTu. All rights reserved.
//

import UIKit

class Rating: UIView {

    @IBOutlet weak var fStar: UIImageView!
    @IBOutlet weak var sStart: UIImageView!
    @IBOutlet weak var tStar: UIImageView!
    @IBOutlet weak var foStar: UIImageView!
    @IBOutlet weak var fiStar: UIImageView!

    private let filledImage = UIImage(named: "star_filled")
    @IBOutlet var view: UIView!
    var vote : Int = 0 {
        willSet {
            changeTo(newValue)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("Rating", owner: self, options: nil)[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    private func changeTo(index : Int) {
        for i in 0..<index {
            changeStarAt(i+1)
        }
    }
    
    private func changeStarAt(index: Int){
        switch index {
        case 1:
            fStar.image = filledImage
        case 2:
            sStart.image = filledImage
        case 3:
            tStar.image = filledImage
        case 4:
            foStar.image = filledImage
        case 5:
            fiStar.image = filledImage
        default:
            break
        }
    }
    
}
