//
//  CustomView.swift
//  CustomTableView
//
//  Created by User on 8/2/16.
//  Copyright © 2016 TrangTu. All rights reserved.
//

import UIKit

class CustomView: UIView {

    @IBOutlet var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("CustomView", owner: self, options: nil)[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
}

