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

class DateViewModel : UIView {
    
    var day : NumericTextField!
    var month : NumericTextField!
    var year : NumericTextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Function which initializes the View by playing the
     */
    func initializeView() {
        
        // The width for each element
        let widthPerfield = (self.bounds.width/6)
        // The (initial) padding between single elements
        var padding : Int = 10
        
        self.addSubview(Constants.addLabel(text: "Day",x: CGFloat(padding), y: 0, width: CGFloat(widthPerfield), height: 20))
        // recalulate the padding for the Label which shows the type of the input field
        padding = padding + Int(widthPerfield)
        let day = NumericTextField(frame : CGRect(x: padding, y: 0, width: Int(widthPerfield/2), height: 20))
        // set the borderStyle of the TextField to be a simple line
        day.borderStyle = .line
        self.addSubview(day)
        
        padding = padding + Int(widthPerfield)
        self.addSubview(Constants.addLabel(text: "Month",x: CGFloat(padding), y: 0, width: CGFloat(widthPerfield), height: 20))
        padding = padding + Int(widthPerfield)
        let month = NumericTextField(frame : CGRect(x: padding,  y: 0, width: Int(widthPerfield/2), height: 20))
        month.borderStyle = .line
        self.addSubview(month)
        
        
        padding = padding + Int(widthPerfield)
        self.addSubview(Constants.addLabel(text: "Year",x: CGFloat(padding), y: 0, width: CGFloat(widthPerfield), height: 20))
        padding = padding + Int(widthPerfield)
        let year = NumericTextField(frame : CGRect(x: padding, y: 0, width: Int(widthPerfield), height: 20))
        year.borderStyle = .line
        self.addSubview(year)
        
        // Set the variables linking them to the created TextFields for later use
        self.day = day
        self.month = month
        self.year = year
    }
    
    /**
     Function which validates the given input and returns a String if the date is valid, nil otherwise
     */
    func getDate() -> String! {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        if let date = formatter.date(from: String(format: "%@%@%@", year.text!, month.text!, day.text!)) {
            print(date)
            return String(format: "%@/%@/%@", year.text!, month.text!, day.text!)

        }
        
        return nil
    }
    
}
