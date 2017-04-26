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
class AgentManagmentViewController: UIViewController {
    
    var queryURL : String = "/rest/data/agents"
    var restManager : RestManager!
    var agentModel : AgentModel!
    var agentConnection : UILabel!
    var lastKeepAliveTimestamp : UILabel!
    var connectionTimestamp : UILabel!
    var millisSinceLastData : UILabel!
    var instrumentationStatus : UILabel!
    var lastInstrumentationUpate : UILabel!
    var methods : UIButton!
    var sensors : UIButton!
    let agentSensorSegue = "AgentSensorSegue"
    let agentMethodSegue = "AgentMethodSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restManager = RestManager()
        addLabel(name: "ID", text : agentModel.id.description, x : 0, y : 20)
        addLabel(name: "Name", text : agentModel.name, x : 0, y : 40)
        addLabel(name: "TimeStamp", text : agentModel.timeStamp.description, x : 0, y : 60)
        addLabel(name: "Version", text : agentModel.version, x : 0, y : 80)
        var count : Int = 1
        var y : CGFloat = 80
        for ip in agentModel.definedIPs {
            y = y + 20
            addLabel(name: String(format: "IP %i", count), text : ip, x : 0, y : y)
            count+=1
        }
        agentConnection = addLabel(name: "agentConnection", text : Constants.UNKNOWN, x : 0, y : y+80)
        lastKeepAliveTimestamp = addLabel(name: "lastKeepAliveTimestamp", text : Constants.UNKNOWN, x : 0, y : y+100)
        connectionTimestamp = addLabel(name: "connectionTimestamp", text : Constants.UNKNOWN, x : 0, y : y+120)
        millisSinceLastData = addLabel(name: "millisSinceLastData", text : Constants.UNKNOWN, x : 0, y : y+140)
        instrumentationStatus = addLabel(name: "instrumentationStatus", text : Constants.UNKNOWN, x : 0, y : y+160)
        lastInstrumentationUpate = addLabel(name: "lastInstrumentationUpate", text : Constants.UNKNOWN, x : 0, y : y+180)
        addStatusInformation()
        methods = addButton(name:"methods", pressed: #selector(self.getInstrumentedMethods(_:)), x: 5, y: y+200)
        sensors = addButton(name:"sensors", pressed: #selector(self.getUsedSensors(_:)), x: 200, y: y+200)
    }
    
    /**
     Function which adds two labels to the view naming it in an id: value manner
     
     - parameters:
     - name: The id of the name to set
     - text: The value of the name to set
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     */
    func addLabel(name: String, text : String, x : CGFloat, y : CGFloat) -> UILabel {
        let labelName = UILabel(frame: CGRect(x: x, y: y+60, width: view.bounds.width/2, height: 20))
        labelName.text = String(format: "%@: ", name)
        self.view.addSubview(labelName)
        let label = UILabel(frame: CGRect(x: view.bounds.width/2, y: y+60, width: view.bounds.width/2, height: 20))
        label.text = text
        self.view.addSubview(label)
        return label
    }
    
    /**
     Function which adds a button to the view as well as a corresponding click action (pressed)
     
     - parameters:
     - name: The name the button
     - pressed: The function (Selector) to be invoked on clicking
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     
     - returns:
     the created button
     */
    func addButton(name: String, pressed: Selector, x : CGFloat, y : CGFloat) -> UIButton{
        let button : UIButton = UIButton(frame: CGRect(x: x, y: y+80, width: 170, height: 20))
        button.setTitle(name, for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: pressed, for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    /**
     Function which asynchroneously retrieves additional status information for the agent
     */
    func addStatusInformation() {
        restManager.makeHTTPGetRequest(path: String(format: "%@%@/%i", Constants.HOST, queryURL, self.agentModel.id), parameter:"") {response in
            print(response)
            if(response.1 == 200) {
                let asmArray = try! AgentStatusModel.loadFromJson(json: response.0, id: self.agentModel.printId, name: self.agentModel.printName) as [AgentStatusModel]
                if (asmArray.count==1) {
                    let asm = asmArray[0]
                    self.agentConnection.text = asm.agentConnection
                    self.lastKeepAliveTimestamp.text = asm.lastKeepAliveTimestamp.description
                    self.connectionTimestamp.text = asm.connectionTimestamp.description
                    self.millisSinceLastData.text = asm.millisSinceLastData.description
                    self.instrumentationStatus.text = asm.instrumentationStatus
                    self.lastInstrumentationUpate.text = asm.lastInstrumentationUpate.description
                }
            }
        }
    }
    
    /**
     Function which initiates the segue to the View for the instrumented Methods
     */
    @IBAction func getInstrumentedMethods(_ sender: Any) {
        performSegue(withIdentifier: agentMethodSegue, sender: self)
        
    }
    
    /**
     Function which initiates the segue to the View for the used Sensors
     */
    @IBAction func getUsedSensors(_ sender: Any) {
        performSegue(withIdentifier: agentSensorSegue, sender: self)
        
    }
    
    /**
     Override the prepare function in order to create the model needed for the segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == agentMethodSegue {
            if let aMethodVC = segue.destination as? AgentMethodViewController {
                aMethodVC.agentModel = self.agentModel
            }
            
        } else if segue.identifier == agentSensorSegue {
            if let aSensorVC = segue.destination as? AgentSensorViewController {
                aSensorVC.agentModel = self.agentModel
            }
        }
    }
    
    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
