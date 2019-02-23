//
//  DraggableCodeSnippit.swift
//  Mentor
//
//  Created by Matthew Krager on 2/23/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import DragDropiOS

class DraggableCodeSnippit: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        isUserInteractionEnabled = true
        backgroundColor = .bg
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.snippetBorder.cgColor
    }
}

extension DraggableCodeSnippit: Draggable {
    func canDragAtPoint(_ point: CGPoint) -> Bool {
        return true
    }
    
    func representationImageAtPoint(_ point: CGPoint) -> UIView? {
        return self
    }
    
    func dragInfoAtPoint(_ point: CGPoint) -> AnyObject? {
        return nil
    }
    
    func dragComplete(_ dragInfo: AnyObject, dropInfo: AnyObject?) {
        print(dragInfo)
    }
}
