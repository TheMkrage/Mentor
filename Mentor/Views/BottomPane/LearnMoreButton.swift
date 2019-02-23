//
//  LearnMoreButton.swift
//  Mentor
//
//  Created by Matthew Krager on 2/23/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit

class LearnMoreButton: UIView {

    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath()
        
        let center = CGPoint(x: rect.width/2, y: 293)
        path.move(to: center)
        path.addArc(withCenter: center, radius: 293.0/2, startAngle: 0.0, endAngle: CGFloat.pi/2.0, clockwise: true)
        path.close()
        path.fill()
    }
}
