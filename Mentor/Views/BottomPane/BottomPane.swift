//
//  BottomPane.swift
//  Mentor
//
//  Created by Matthew Krager on 2/23/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class BottomPane: UIView {

    var titleLabel = HeaderLabel()
    var learnMoreButton = LearnMoreButton()
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        backgroundColor = .fg
        addSubview(titleLabel)
        addSubview(learnMoreButton)
        
        titleLabel.topAnchor == topAnchor + 20
        titleLabel.leadingAnchor == leadingAnchor + 30
    }
}
