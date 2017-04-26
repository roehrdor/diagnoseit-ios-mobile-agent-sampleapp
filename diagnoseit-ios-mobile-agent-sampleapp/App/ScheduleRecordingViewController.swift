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

class ScheduleRecordingViewController : UIViewController {
    
    var restManager : RestManager!
    var storageModel : StorageModel!
    let queryURL : String = "/rest/storage"
    var finish : UIButton!
    var cancel : UIButton!
    var delay : NumericTextField!
    var duration : NumericTextField!
    var extract : UITextField!
    var autoFinalize : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        restManager = RestManager()
        addLabel(name: "ID:", x : 0, y : 20, width: 20)
        addLabel(name: storageModel.id, x : 0, y : 50, width: view.bounds.width)
        
        addLabel(name: "starting Delay (in ms):", x : 0, y : 90, width: 50)
        self.delay = addNumericTextField(x : 15, y : 120)
        
        addLabel(name: "Recording Duration (in ms):", x : 0, y : 160, width: 50)
        self.duration = addNumericTextField(x : 15, y : 190)
        
        addLabel(name: "extract Invocations:", x : 0, y : 230, width: 50)
        self.extract = addTextField(x : 15, y : 260)
        
        addLabel(name: "auto Finalize:", x : 0, y : 300, width: 50)
        self.autoFinalize = addTextField(x : 15, y : 330)
        
        finish = addButton(name:"finish", pressed: #selector(self.scheduleRecording(_:)), x: 40, y: 380)
        cancel = addButton(name:"cancel", pressed: #selector(self.cancelScheduling(_:)), x: 200, y: 380)
        
        
    }
    
    /**
     Function which adds a label to the view
     
     - parameters:
     - name: The name of the label
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     - width: the width of the label
     */
    func addLabel(name: String, x : CGFloat, y : CGFloat, width : CGFloat) {
        let label = UILabel(frame: CGRect(x: x, y: y+60, width: view.bounds.width, height: 20))
        label.text = name
        self.view.addSubview(label)
    }
    
    /**
     Function which adds a numericTextField to the view
     
     - parameters:
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     */
    func addNumericTextField(x : CGFloat, y : CGFloat) -> NumericTextField {
        let textField = NumericTextField(frame: CGRect(x: x, y: y+60, width: view.bounds.width-30, height: 20))
        textField.borderStyle = .line
        self.view.addSubview(textField)
        return textField
    }
    
    /**
     Function which adds a TextField to the view
     
     - parameters:
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     */
    func addTextField(x : CGFloat, y : CGFloat) -> UITextField {
        let textField = UITextField(frame: CGRect(x: x, y: y+60, width: view.bounds.width-30, height: 20))
        textField.borderStyle = .line
        self.view.addSubview(textField)
        return textField
    }
    
    /**
     Function which adds a button to the view as well as a corresponding click action (pressed)
     
     - parameters:
     - name: The name the button
     - pressed: The function (Selector) to be invoked on clicking
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     */
    func addButton(name: String, pressed: Selector, x : CGFloat, y : CGFloat) -> UIButton{
        let button : UIButton = UIButton(frame: CGRect(x: x, y: y+80, width: 120, height: 20))
        button.setTitle(name, for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: pressed, for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    /**
     Function which adds the passes parameters to a given String of parameters
     
     - parameters:
     - params: The String of already existing parameters to add the new one to
     - name: The name of the parameter to add
     - value: The value of the parameter to add
     */
    func addParameters(params : String, name : String, value : String) -> String {
        if value.isEmpty {
            return params
        }
        if params.isEmpty {
            return String(format: "%@=%@", name, value)
        }
        return String(format: "%@&%@=%@", params, name, value)
    }
    
    /**
     Function which initializes the invocation of the schedule recording REST API by gathering given parameters
     and adding them to the invocation
     */
    @IBAction func scheduleRecording(_ sender: Any) {
        let title : String = "Schedule Recording"
        // start gathering the parameters of the inputfields and adding them using the corresponding function
        var parameters = addParameters(params: "", name : "id", value : self.storageModel.id)
            parameters = addParameters(params: parameters, name : "recordingDuration", value : self.duration.text!)
            parameters = addParameters(params: parameters, name : "startDelay", value : self.delay.text!)
        let autoFin = self.autoFinalize.text?.lowercased()
        if (autoFin=="true" || autoFin=="false") {
              parameters = addParameters(params: parameters, name : "autoFinalize", value : autoFin!)
        }
        let extractInv = self.extract.text?.lowercased()
        if (extractInv=="true" || extractInv=="false") {
            parameters = addParameters(params: parameters, name : "extractInvocations", value : extractInv!)
        }
        print(parameters)
        // make the http Request using the gathered paratemers
        restManager.makeHTTPGetRequest(path: String(format: "%@%@", Constants.HOST, queryURL), parameter: parameters) {response in
            if(response.1 == 200) {
                let error = self.checkForError(_json : response.0)
                if error.isEmpty {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.present(Constants.alert(windowTitle: title, message: error, confirmButtonName: "okay"), animated: true, completion: nil)
                }
            }
        }
    }
    
    /**
     Function which extracts an error from a json String (if any presents) otherwise returns an empty String
     
     - parameters:
     - json: The json du extract the error from
     */
    func checkForError(_json : String) -> String {
        print(_json)
        do {
            let temp = try JSONSerialization.jsonObject(with: _json.data(using: .utf8)!, options:[])
            if temp is [String : Any] {
                let json = temp as! [String : Any]
                if let error = json["error"] {
                    return error as! String
                }
            }
        } catch {
            return ""
        }
        return ""
    }
    
    /**
     Function which cancels the scheduling of a recording dismissing the view
     */
    @IBAction func cancelScheduling(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
