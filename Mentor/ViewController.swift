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

class ViewController: UIViewController {

    var textView: UITextView = {
        let t = UITextView()
        t.backgroundColor = .clear
        t.font = UIFont.init(name: "Menlo", size: 20.0)
        return t
    }()
    
    let highlightr: Highlightr = {
        guard let h = Highlightr() else {
            return Highlightr()!
        }
        h.setTheme(to: "atom-one-dark")
        return h
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bg
        
        let code = """
        // Methods
        func voidMethod() {
            fmt.Println(\"Void!\")
        }
        """
        let highlightedCode = highlightr.highlight(code)
        textView.attributedText = highlightedCode
        
        view.addSubview(textView)
        setupConstraints()
    }

    func setupConstraints() {
        textView.topAnchor == view.topAnchor
        textView.horizontalAnchors == view.horizontalAnchors
        textView.bottomAnchor == view.bottomAnchor
    }
}

