//
//  HeaderView.swift
//  Mentor
//
//  Created by Matthew Krager on 2/23/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class HeaderView: UIView {
    
    var titleLabel = HeaderLabel()

    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        addSubview(titleLabel)
        
        titleLabel.centerYAnchor == centerYAnchor
        titleLabel.leadingAnchor == leadingAnchor + 20
    }
}
