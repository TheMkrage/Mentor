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
import Dwifft
import Alamofire
import WebKit
import SafariServices

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
    var query = "functions"

    // View
    let headerView = HeaderView()
    
    var textView: UILabel = {
        let t = UILabel()
        t.backgroundColor = .clear
        t.numberOfLines = 0
        return t
    }()
    
    var bottomPane: BottomPane = {
        let v = BottomPane()
        return v
    }()
    
    // Constraints
    var bottomPaneHeight: NSLayoutConstraint?
    
    let highlightr: Highlightr = {
        guard let h = Highlightr() else {
            return Highlightr()!
        }
        h.setTheme(to: "atom-one-dark")
        h.theme.codeFont = UIFont.init(name: "Menlo", size: 15.0)
        return h
    }()
    
    let smallHighlightr: Highlightr = {
        guard let h = Highlightr() else {
            return Highlightr()!
        }
        h.setTheme(to: "atom-one-dark")
        h.theme.codeFont = UIFont.init(name: "Menlo", size: 11.0)
        return h
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bg
        bottomPane.delegate = self
        ref.root.observe(.value) { (snap) in
            let dict = snap.value as? [String : AnyObject]
            if let options = dict?["options"] as? [String] {
                self.options = options
                if options.count >= 1 {
                    let highlightedCode = self.smallHighlightr.highlight(options[0])
                    self.bottomPane.codeSnip1.label.attributedText = highlightedCode
                }
                if options.count >= 2 {
                    let highlightedCode = self.smallHighlightr.highlight(options[1])
                    self.bottomPane.codeSnip2.label.attributedText = highlightedCode
                }
                if options.count >= 3 {
                    let highlightedCode = self.smallHighlightr.highlight(options[2])
                    self.bottomPane.codeSnip3.label.attributedText = highlightedCode
                }
            }
            if let code = dict?["code"] as? String, code != ""  {
                self.determineState(code: code)
                let highlightedCode = self.highlightr.highlight(code)
                self.textView.attributedText = highlightedCode!
                
            }
            if let grammars = dict?["grammars"] as? [String] {
                self.query = grammars[0]
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
    
    func displayBottomPane() {
        if bottomPaneHeight?.constant ?? -1.0 == 0 {
            bottomPaneHeight?.constant = 0.0
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: Double(0.5), animations: {
                self.bottomPaneHeight?.constant = 350.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func hideBottomPane() {
        if bottomPaneHeight?.constant ?? 0 == 350.0 {
            bottomPaneHeight?.constant = 350.0
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: Double(0.5), animations: {
                self.bottomPaneHeight?.constant = 0.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func updateView() {
        switch state {
        case .beganCode:
            headerView.titleLabel.text = "I see you are writing Python!"
            hideBottomPane()
        case .displayingOptions:
            headerView.titleLabel.text = ""
            bottomPane.titleLabel.text = "Select the best Go translation"
            displayBottomPane()
        case .normal:
            self.headerView.titleLabel.text = "Latest Changes"
            // animate disapearance
            hideBottomPane()
        case .draggedOption:
            bottomPane.titleLabel.text = "Select the best Go translation"
            hideBottomPane()
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
        textView.bottomAnchor <= bottomPane.topAnchor + 30
        
        bottomPane.bottomAnchor == view.bottomAnchor
        bottomPane.leadingAnchor == view.leadingAnchor
        bottomPane.trailingAnchor == view.trailingAnchor
        bottomPaneHeight = (bottomPane.heightAnchor == 0)
    }
}

extension ViewController: BottomPaneDelegate {
    func codeSnipTapped(index: Int, code: String) {
        self.ref.child("choice").setValue(index)
    }
    
    func learnMoreTapped() {
        let cse_url = "https://www.googleapis.com/customsearch/v1?cx=011944706024575323675:nxg-itz5yrm&q=" + query.replacingOccurrences(of: " ", with: "%20") + "&key=AIzaSyBmtJd1HVAttRGDJmTkjhy5coXdLtrcAsM"
        Alamofire.request(cse_url).responseJSON { response in
            print(response)
            print("---")
            switch response.result {
                
            case .success(let result):
                if let dic = response.result.value as? Dictionary<String,AnyObject>{
                    if let items = dic["items"] as? [Dictionary<String,AnyObject>] {
                        if let url = URL(string: items[0]["link"] as? String ?? "") {
                            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                            
                            self.show(vc, sender: self)
                            //self.present(vc, animated: true)
                        }
                    }
                }
            default:
                print("Error")
            }
        }
    }
}

