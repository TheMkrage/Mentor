//
//  HeaderLabel.swift
//  Mentor
//
//  Created by Matthew Krager on 2/23/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit

class HeaderLabel: UILabel {

    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        textColor = UIColor.headerLabelColor
        font = UIFont.init(name: "HelveticaNeue-Medium", size: 24.0)
    }
}
