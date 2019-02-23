//
//  ViewController.swift
//  Mentor
//
//  Created by Matthew Krager on 2/23/19.
//  Copyright © 2019 Matthew Krager. All rights reserved.
//

import UIKit
import Highlightr
import Anchorage
import FirebaseDatabase

enum State {
    case normal, beganCode, displayingOptions, draggedOption
}

class ViewController: UIViewController {
    
    lazy var ref = Database.database().reference()
    var state: State = .normal {
        didSet {
            updateView()
        }
    }
    
    // Model
    var options = [String]()

    // View
    let headerView = HeaderView()
    
    var textView: UITextView = {
        let t = UITextView()
        t.backgroundColor = .clear
        t.textContainerInset = .zero
        return t
    }()
    
    var bottomPane: UIView = {
        let v = UIView()
        v.backgroundColor = .fg
        return v
    }()
    
    // Constraints
    var bottomPaneHeight: NSLayoutConstraint?
    
    let highlightr: Highlightr = {
        guard let h = Highlightr() else {
            return Highlightr()!
        }
        h.setTheme(to: "atom-one-dark")
        h.theme.codeFont = UIFont.init(name: "Menlo", size: 20.0)
        return h
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bg
        
        ref.root.observe(.value) { (snap) in
            let dict = snap.value as? [String : AnyObject]
            if let options = dict?["options"] as? [String] {
                self.options = options
            }
            if let code = dict?["code"] as? String  {
                self.determineState(code: code)
                let highlightedCode = self.highlightr.highlight(code)
                self.textView.attributedText = highlightedCode
            }
        }
        
        view.addSubview(headerView)
        view.addSubview(textView)
        view.addSubview(bottomPane)
        
        setupConstraints()
    }
    
    func determineState(code: String) {
        let codeSections = code.components(separatedBy: "////")
        if codeSections.count - 1 == 0 {
            state = .normal
        } else if codeSections.count - 1 == 1 {
            state = .beganCode
        } else if codeSections.count - 1 == 2 && state != .draggedOption {
            state = .displayingOptions
        }
    }
    
    func updateView() {
        if state == .beganCode {
            bottomPaneHeight?.constant = 0.0
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: Double(0.5), animations: {
                self.bottomPaneHeight?.constant = 200.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func setupConstraints() {
        headerView.topAnchor == view.topAnchor
        headerView.heightAnchor == 70
        headerView.horizontalAnchors == view.horizontalAnchors
        
        textView.topAnchor == headerView.bottomAnchor + 30
        textView.horizontalAnchors == view.horizontalAnchors + 25
        textView.bottomAnchor == view.bottomAnchor
        
        bottomPane.bottomAnchor == view.bottomAnchor
        bottomPane.leadingAnchor == view.leadingAnchor
        bottomPane.trailingAnchor == view.trailingAnchor
        bottomPaneHeight = (bottomPane.heightAnchor == 0)
    }
}

