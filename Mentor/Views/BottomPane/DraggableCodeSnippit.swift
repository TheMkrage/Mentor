//
//  DraggableCodeSnippit.swift
//  Mentor
//
//  Created by Matthew Krager on 2/23/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

class DraggableCodeSnippit: UIView {
    
    var label: UITextView = {
        let l = UITextView()
        //l.numberOfLines = 0
        l.backgroundColor = .clear
        l.isScrollEnabled = true
        l.isEditable = false
        l.isSelectable = false
        return l
    }()
    var choice = -1
    
    init(choice: Int) {
        super.init(frame: CGRect.zero)
        self.choice = choice
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        addSubview(label)
        
        isUserInteractionEnabled = true
        backgroundColor = .bg
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.snippetBorder.cgColor
        
        label.topAnchor == topAnchor + 3
        label.trailingAnchor == trailingAnchor - 3
        label.leadingAnchor == leadingAnchor + 3
        label.bottomAnchor == bottomAnchor
    }
}
