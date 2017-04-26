/*
 Copyright (c) 2017 Oliver Roehrdanz
 Copyright (c) 2017 Matteo Sassano
 Copyright (c) 2017 Christopher Voelker
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 DEALINGS IN THE SOFTWARE.
 */

import UIKit

class AlertView: UIView {
    
    var title : String
    var message : String
    static let success = "SUCCESS"
    static let failure = "FAILURE"

    init(title: String, message: String, type: String) {
        let padding = 10
        let width = UIScreen.main.bounds.width
        let height = 64;
        self.title = title
        self.message = message
        super.init(frame: CGRect(x: 0, y: -height, width: Int(width), height: height))
        if type == AlertView.success {
            self.backgroundColor = UIUtil.greenColor
        } else {
            self.backgroundColor = UIUtil.redColor
        }
        let titleLabel = UIUtil.getLabel(text: title, x: CGFloat(padding), y: CGFloat(padding * 2), view: self)
        titleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        let messageLabel = UIUtil.getLabel(text: message, x: CGFloat(padding), y: CGFloat(padding * 2) + titleLabel.frame.size.height, view: self)
        titleLabel.textColor = UIColor.white
        messageLabel.textColor = UIColor.white
        self.addSubview(titleLabel)
        self.addSubview(messageLabel)
        self.layer.zPosition = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.frame.origin.y = 0
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.5, delay: 3.0, options: [], animations: {
                self.frame.origin.y = -(CGFloat)(height)
            }, completion: { (finished: Bool) in
                self.removeFromSuperview()
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
