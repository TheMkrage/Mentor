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
    var draggableSnippetStackView: UIStackView = {
        let v = UIStackView()
        v.addArrangedSubview(DraggableCodeSnippit())
        return v
    }()
    
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
        addSubview(draggableSnippetStackView)
        
        titleLabel.topAnchor == topAnchor + 20
        titleLabel.leadingAnchor == leadingAnchor + 30
        
        draggableSnippetStackView.topAnchor == titleLabel.bottomAnchor + 30
        draggableSnippetStackView.horizontalAnchors == horizontalAnchors + 30
        draggableSnippetStackView.bottomAnchor == learnMoreButton.topAnchor + 55
        
        learnMoreButton.centerXAnchor == centerXAnchor
        learnMoreButton.bottomAnchor == bottomAnchor
        learnMoreButton.widthAnchor == 293
        learnMoreButton.heightAnchor == 84
    }
}
