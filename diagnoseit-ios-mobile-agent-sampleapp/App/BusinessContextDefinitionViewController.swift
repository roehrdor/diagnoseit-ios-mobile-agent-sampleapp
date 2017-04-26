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
class BusinessContextDefinitionViewController: UIViewController {
    
    var restManager : RestManager!
    var businessContextDefinitionModel : BusinessContextDefinitionModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restManager = RestManager()
        addLabel(name: "ID", text : businessContextDefinitionModel.id.description, x : 0, y : 20)
        addLabel(name: "application Name", text : businessContextDefinitionModel.applicationName, x : 0, y : 40)
        addLabel(name: "Description", text : businessContextDefinitionModel.description, x : 0, y : 60)
    }
    
    /**
     Function which adds a label to the view naming it in an id: value manner
     
     - parameters:
     - name: The id of the name to set
     - text: The value of the name to set
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     */
    func addLabel(name: String, text : String, x : CGFloat, y : CGFloat) {
        let label = UILabel(frame: CGRect(x: x, y: y+60, width: view.bounds.width, height: 20))
        label.text = String(format: "%@: %@", name, text)
        self.view.addSubview(label)
    }
    
    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
