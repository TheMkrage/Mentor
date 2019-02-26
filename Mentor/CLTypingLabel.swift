//
//  CLTypingLabel.swift
//  CLTypingLabel
//  The MIT License (MIT)
//  Copyright © 2016 Chenglin 2/21/16.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files
//  (the “Software”), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software,
//  and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit
import Dwifft

/*
 Set text at runtime to trigger type animation;
 
 Set charInterval property for interval time between each character, default is 0.1;
 
 Call pauseTyping() to pause animation;
 
 Call conitinueTyping() to continue paused animation;
 */


@IBDesignable open class CLTypingLabel: UILabel {
    /*
     Set interval time between each characters
     */
    @IBInspectable open var charInterval: Double = 0.005
    
    /*
     If text is always centered during typing
     */
    @IBInspectable open var centerText: Bool = true
    
    private var typingStopped: Bool = false
    private var typingOver: Bool = true
    private var stoppedSubstring: String?
    private var attributes: [NSAttributedString.Key: Any]?
    private var currentDispatchID: Int = 320
    private let dispatchSerialQ = DispatchQueue(label: "CLTypingLableQueue")
    /*
     Setting the text will trigger animation automatically
     */
    override open var text: String! {
        get {
            return super.text
        }
        
        set {
            if charInterval < 0 {
                charInterval = -charInterval
            }
            
            currentDispatchID += 1
            typingStopped = false
            typingOver = false
            stoppedSubstring = nil
            
            attributes = nil
            //setTextWithTypingAnimation(newValue)
        }
    }
    
    /*
     Setting attributed text will trigger animation automatically
     */
    override open var attributedText: NSAttributedString! {
        get {
            return super.attributedText
        }
        
        set {
            if charInterval < 0 {
                charInterval = -charInterval
            }
            
            currentDispatchID += 1
            typingStopped = false
            typingOver = false
            stoppedSubstring = nil
            
            let diffs = Dwifft.diff(Array(super.attributedText?.string ?? ""), Array(newValue.string)).sorted(by: { (dif1, dif2) -> Bool in
                return dif1.idx < dif2.idx
            })
            attributes = newValue.attributes(at: 0, effectiveRange: nil)
            setTextWithTypingAnimation(newValue, diffs: diffs)
            //setTextWithTypingAnimation(newValue.string, attributes, charInterval, true, currentDispatchID, attributedString: newValue)
        }
    }
    
    // MARK: -
    // MARK: Stop Typing Animation
    
    open func pauseTyping() {
        if typingOver == false {
            typingStopped = true
        }
    }
    
    // MARK: -
    // MARK: Continue Typing Animation
    
    open func continueTyping() {
        
        guard typingOver == false else {
            print("CLTypingLabel: Animation is already over")
            return
        }
        
        guard typingStopped == true else {
            print("CLTypingLabel: Animation is not stopped")
            return
        }
        guard let stoppedSubstring = stoppedSubstring else {
            return
        }
        
        typingStopped = false
        //setTextWithTypingAnimation(stoppedSubstring, attributes ,charInterval, false, currentDispatchID)
    }
    
    // MARK: -
    // MARK: Set Text Typing Recursive Loop
    private func setTextWithTypingAnimation(_ attributedString: NSAttributedString, length: Int = 1, diffs: [DiffStep<Character>]) {
        if diffs.count == 0 {
            return
        }
        let diff = diffs.first!
        //print(diff.debugDescription)
        DispatchQueue.main.async {
            if diff.debugDescription.first! == "+" {
                let beforeAdd = super.attributedText?.attributedSubstring(from: NSRange(0..<diff.idx)) ?? NSMutableAttributedString()
                //print("afterbefore")
                let add = attributedString.attributedSubstring(from: NSRange(location: diff.idx, length: 1))
                //print("afteradd")
                var afterAdd = NSAttributedString()
                if diff.idx < super.attributedText?.length ?? 0 {
                    print(diff.idx)
                    print(super.attributedText?.length)
                    afterAdd = super.attributedText?.attributedSubstring(from: NSRange(diff.idx..<super.attributedText!.length)) ?? NSMutableAttributedString()
                    //print("after")
                }
                
                // addition
                let newAttributed = NSMutableAttributedString.init(attributedString: beforeAdd)
                newAttributed.append(add)
                newAttributed.append(afterAdd)
                super.attributedText = newAttributed
                //print("resetting via add\n\(newAttributed.string)")
            } else {
                let beforeSub = super.attributedText?.attributedSubstring(from: NSRange(0..<diff.idx)) ?? NSMutableAttributedString()
                //print("afterbefore")
                var afterSub = NSAttributedString()
                if diff.idx+1 < super.attributedText?.length ?? 0 {
                    //print(diff.idx+1)
                    //print(super.attributedText?.length)
                    afterSub = super.attributedText?.attributedSubstring(from: NSRange(diff.idx+1..<super.attributedText!.length)) ?? NSMutableAttributedString()
                    //print("after sub")
                }
                
                // subtraction
                let newAttributed = NSMutableAttributedString.init(attributedString: beforeSub)
                newAttributed.append(afterSub)
                super.attributedText = newAttributed
                //print("resetting via sub\n\(newAttributed.string)")
            }
           // print("\n")
            
            //print(super.attributedText?.string ?? "")
            //print(attributedString.string)
            
            let diffs = Dwifft.diff(Array(super.attributedText?.string ?? ""), Array(attributedString.string)).sorted(by: { (dif1, dif2) -> Bool in
                return dif1.idx < dif2.idx
            })
            print("diffs")
            
            self.dispatchSerialQ.asyncAfter(deadline: .now() + self.charInterval) { [weak self] in
                self?.setTextWithTypingAnimation(attributedString, length: length + 1, diffs: diffs)
            }
        }
    }
}
