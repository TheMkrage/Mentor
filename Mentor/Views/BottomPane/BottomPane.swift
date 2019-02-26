//
//  BottomPane.swift
//  Mentor
//
//  Created by Matthew Krager on 2/23/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import Anchorage

protocol BottomPaneDelegate {
    func codeSnipTapped(index: Int, code: String)
    func learnMoreTapped()
}

class BottomPane: UIView {

    var titleLabel = HeaderLabel()
    var learnMoreButton: UIButton = {
        let b = UIButton()
        b.isUserInteractionEnabled = true
        b.setImage(UIImage.init(named: "learn-more-button"), for: .normal)
        b.addTarget(self, action: #selector(learnMoreTapped), for: .touchUpInside)
        return b
    }()
    
    let codeSnip1 = DraggableCodeSnippit(choice: 0)
    let codeSnip2 = DraggableCodeSnippit(choice: 1)
    let codeSnip3 = DraggableCodeSnippit(choice: 2)
    lazy var draggableSnippetStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [codeSnip1, codeSnip2, codeSnip3])
        v.axis = .horizontal
        v.spacing = 20
        v.distribution = .fillEqually
        return v
    }()
    
    var delegate: BottomPaneDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        clipsToBounds = true
        backgroundColor = .fg
        codeSnip1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedCodeSnip(sender:forEvent:))))
        codeSnip2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedCodeSnip(sender:forEvent:))))
        codeSnip3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedCodeSnip(sender:forEvent:))))
        
        addSubview(titleLabel)
        addSubview(learnMoreButton)
        addSubview(draggableSnippetStackView)
        
        titleLabel.topAnchor == topAnchor + 20
        titleLabel.leadingAnchor == leadingAnchor + 30
        titleLabel.heightAnchor == 30
        
        draggableSnippetStackView.topAnchor == titleLabel.bottomAnchor + 30
        draggableSnippetStackView.horizontalAnchors == horizontalAnchors + 30
        draggableSnippetStackView.bottomAnchor == learnMoreButton.topAnchor - 20
        
        learnMoreButton.centerXAnchor == centerXAnchor
        learnMoreButton.bottomAnchor == bottomAnchor
        learnMoreButton.widthAnchor == 293
        learnMoreButton.heightAnchor == 80
    }
    
    @objc func selectedCodeSnip(sender: UITapGestureRecognizer, forEvent event: UIEvent) {
        let index = (sender.view as! DraggableCodeSnippit).choice
        let text = (sender.view as! DraggableCodeSnippit).label.attributedText.string
        DispatchQueue.main.async {
            let color = CABasicAnimation(keyPath: "borderColor")
            color.fromValue = UIColor.green.cgColor
            color.toValue =  UIColor.snippetBorder.cgColor
            color.duration = 1
            color.repeatCount = 1
            (sender.view as! DraggableCodeSnippit).layer.borderWidth = 1.0
            (sender.view as! DraggableCodeSnippit).layer.borderColor = UIColor.snippetBorder.cgColor
            (sender.view as! DraggableCodeSnippit).layer.add(color, forKey: "borderColor")
        }
        self.delegate?.codeSnipTapped(index: index, code: text)
    }
    
    @objc func learnMoreTapped() {
        self.delegate?.learnMoreTapped()
    }
}
