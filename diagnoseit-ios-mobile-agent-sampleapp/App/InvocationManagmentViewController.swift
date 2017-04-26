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
class InvocationManagmentViewController: UIViewController {
    
    var restManager : RestManager!
    var invocationModel : InvocationModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restManager = RestManager()
        addLabel(name: "ID", text : invocationModel.id.description, x : 0, y : 20)
        addLabel(name: "PlatformIdent", text : invocationModel.platformIdent.description, x : 0, y : 40)
        addLabel(name: "sensorTypeIdent", text : invocationModel.sensorTypeIdent.description, x : 0, y : 60)
        addLabel(name: "timeStamp", text : invocationModel.timeStamp.description, x : 0, y : 80)
        addLabel(name: "methodIdent", text : invocationModel.methodIdent.description, x : 0, y : 100)
        
        
        
        addLabel(name: "duration", text : invocationModel.duration.description, x : 0, y : 120)
        addLabel(name: "childCount", text : invocationModel.childCount.description, x : 0, y : 140)
        addLabel(name: "applicationId", text : invocationModel.applicationId.description, x : 0, y : 160)
        addLabel(name: "businessTransactionId", text : invocationModel.businessTransactionId.description, x : 0, y : 180)
        
         addLabel(name: "TimerData", text : "", x : 0, y : 220)
        if let timerData = invocationModel.timerData {
        addLabel(name: "invocationClass", text : timerData.invocationClass.description, x : 0, y : 250)
        addLabel(name: "id", text : timerData.id.description, x : 0, y : 270)
        addLabel(name: "platformIdent", text : timerData.platformIdent.description, x : 0, y : 290)
        addLabel(name: "timeStamp", text : timerData.timeStamp.description, x : 0, y : 310)
        addLabel(name: "methodIdent", text : timerData.methodIdent.description, x : 0, y : 330)
        addLabel(name: "min", text : timerData.min.description, x : 0, y : 350)
        addLabel(name: "max", text : timerData.max.description, x : 0, y : 370)
        addLabel(name: "count", text : timerData.count.description, x : 0, y : 390)
        addLabel(name: "duration", text : timerData.duration.description, x : 0, y : 410)
        addLabel(name: "cpuMin", text : timerData.cpuMin.description, x : 0, y : 430)
        addLabel(name: "cpuMax", text : timerData.cpuMax.description, x : 0, y : 450)
        addLabel(name: "cpuDuration", text : timerData.cpuDuration.description, x : 0, y : 470)
        addLabel(name: "exclusiveCount", text : timerData.exclusiveCount.description, x : 0, y : 490)
        addLabel(name: "exclusiveDuration", text : timerData.exclusiveDuration.description, x : 0, y : 510)
        addLabel(name: "exclusiveMax", text : timerData.exclusiveMax.description, x : 0, y : 530)
        addLabel(name: "exclusiveMin", text : timerData.exclusiveMin.description, x : 0, y : 550)
        }
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
