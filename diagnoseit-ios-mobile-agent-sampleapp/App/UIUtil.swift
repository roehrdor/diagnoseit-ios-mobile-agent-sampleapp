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

class UIUtil {
    
    static var padding: CGFloat = 16.0;
    static var topbarHeight: CGFloat = 64.0;
    static var greenColor: UIColor = getColor(hex: "#2EC466")
    static var redColor: UIColor = getColor(hex: "#F83B4D")
    
    /**
     Function which adds a label to the view displaying specific data passed to the function
     
     - parameters:
     - name: The name of the data item to display
     - text: The text of the data item to display
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     */
    static func addLabel(name: String, text : String, x : CGFloat, y : CGFloat, view: UIView) {
        let label = UILabel(frame: CGRect(x: x, y: y, width: view.bounds.width - 2 * UIUtil.padding, height: 20))
        label.numberOfLines = 0
        label.text = String(format: "%@: %@", name, text)
        label.autoresizingMask = [.flexibleWidth]
        view.addSubview(label)
    }
    
    /**
     Function which adds a label to the view displaying specific data passed to the function
     
     - parameters:
     - name: The name of the data item to display
     - text: The text of the data item to display
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     */
    static func getLabel(text : String, x : CGFloat, y : CGFloat, view : UIView) -> UILabel {
        let label = UILabel(frame: CGRect(x: x, y: y, width: view.bounds.width - 2 * UIUtil.padding, height: 20))
        label.numberOfLines = 0
        label.text = text
        label.autoresizingMask = [.flexibleWidth]
        return label
    }
    
    /**
     Function which adds a button to the view as well as a corresponding click action (pressed)
     
     - parameters:
     - name: The name the button
     - pressed: The function (Selector) to be invoked on clicking
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     */
    static func addButton(name: String, x : CGFloat, y : CGFloat, width: CGFloat, height: CGFloat, target: Any, pressed: Selector, view: UIView) -> UIButton {
        let button : UIButton = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        button.setTitle(name, for: .normal)
        button.backgroundColor = UIUtil.getColor(hex: "#003A66")
        button.addTarget(target, action: pressed, for: .touchUpInside)
        view.addSubview(button)
        return button
    }
    
    /**
     Function which adds a button to the view as well as a corresponding click action (pressed)
     
     - parameters:
     - name: The name the button
     - pressed: The function (Selector) to be invoked on clicking
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     */
    static func addFullButton(name: String, x : CGFloat, y : CGFloat, target: Any, pressed: Selector, view: UIView) {
        let button : UIButton = UIButton(frame: CGRect(x: x, y: y, width: view.frame.width - 2 * UIUtil.padding, height: 50))
        button.setTitle(name, for: .normal)
        button.backgroundColor = UIUtil.getColor(hex: "#003A66")
        button.addTarget(target, action: pressed, for: .touchUpInside)
        button.autoresizingMask = [.flexibleWidth]
        view.addSubview(button)
    }
    
    static func getColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
