//
//  BannerView.swift
//  TaoBaoExer
//
//  Created by Nancy's MacbookPro on 8/5/16.
//  Copyright © 2016 Nancy's MacbookPro. All rights reserved.
//

import UIKit

class BannerView: UIView {
    
    @IBOutlet weak var content1Label: UILabel!
    
    
    @IBOutlet weak var content2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame.size = CGSize(width: (UIScreen.mainScreen().bounds.width - 143), height: 60)
    }
    
}

