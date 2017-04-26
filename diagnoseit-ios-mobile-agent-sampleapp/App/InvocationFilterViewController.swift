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

class InvocationFilterViewController : UIViewController {
    
    var restManager : RestManager!
    let queryURL : String = "/rest/data/invocations"
    var finish : UIButton!
    var cancel : UIButton!
    var id : NumericTextField!
    var fromDate : DateViewModel!
    var toDate : DateViewModel!
    var latestReadId : NumericTextField!
    var limit : NumericTextField!
    var businessTrxId : NumericTextField!
    var appId : NumericTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restManager = RestManager()
        addLabel(name: "ID:", x : 0, y : 20, width: 20)
        self.id = addTextField(x : 15, y : 50)
        
        addLabel(name: "from Date:", x : 0, y : 90, width: 50)
        self.fromDate = addDateView(x : 15, y : 120)
        
        addLabel(name: "to Date:", x : 0, y : 160, width: 50)
        self.toDate = addDateView(x : 15, y : 190)
        
        addLabel(name: "latestReadId:", x : 0, y : 230, width: 50)
        self.latestReadId = addTextField(x : 15, y : 270)
        
        addLabel(name: "limit:", x : 0, y : 310, width: 50)
        self.limit = addTextField(x : 15, y : 340)
        
        addLabel(name: "business Trx ID:", x : 0, y : 380, width: 50)
        self.businessTrxId = addTextField(x : 15, y : 410)
        
        addLabel(name: "app ID:", x : 0, y : 450, width: 50)
        self.appId = addTextField(x : 15, y : 480)
        
        finish = addButton(name:"finish", pressed: #selector(self.applyFilter(_:)), x: 40, y: 530)
        cancel = addButton(name:"cancel", pressed: #selector(self.cancelFiltering(_:)), x: 200, y: 530)
        
        
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
     Function which adds a TextField to the view
     
     - parameters:
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     */
    func addTextField(x : CGFloat, y : CGFloat) -> NumericTextField {
        let textField = NumericTextField(frame: CGRect(x: x, y: y+60, width: view.bounds.width-30, height: 20))
        textField.borderStyle = .line
        self.view.addSubview(textField)
        return textField
    }
    
    /**
     Function which adds a DateViewModel to the view
     
     - parameters:
     - x: The gap to the left of the display
     - y: The gap to the top of the display
     
     - returns:
        The created dateViewModel
     */
    func addDateView(x : CGFloat, y : CGFloat) -> DateViewModel {
        let dateView = DateViewModel(frame: CGRect(x: x, y: y+60, width: view.bounds.width-30, height: 20))
        self.view.addSubview(dateView)
        return dateView
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
     Function which extracts an error from a json String (if any presents) otherwise returns an empty String
     
     - parameters:
     - json: The json du extract the error from
     */
    func checkForError(json : String) -> String {
        do {
            let temp = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options:[])
            if temp is [String : Any] {
                let jsonData = temp as! [String : Any]
                if let error = jsonData["error"] {
                    return error as! String
                }
            }
        } catch {
            return ""
        }
        return ""
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
     Function which starts gathering the filter parameters and invokes the corresponding API
     */
    @IBAction func applyFilter(_ sender: Any) {
        let title : String = "Filter Invocations"
         // start gathering the parameters of the inputfields and adding them using the corresponding function
        var parameters : String = ""
        if let tempAgentId = Int(self.id.text!) {
            parameters = addParameters(params: parameters, name: "agentId", value: tempAgentId.description)
        }
        if let tempFromDate = self.fromDate.getDate() {
            parameters = addParameters(params: parameters, name: "fromDate", value: tempFromDate)
        }
        if let tempToDate = self.toDate.getDate() {
            parameters = addParameters(params: parameters, name: "toDate", value: tempToDate)
        }
        if let tempLatestReadId = Int(self.latestReadId.text!) {
            parameters = addParameters(params: parameters, name: "latestReadId", value: tempLatestReadId.description)
        }
        if let tempLimit = Int(self.limit.text!) {
            parameters = addParameters(params: parameters, name: "limit", value: tempLimit.description)
        }
        if let tempBusinessTrxId = Int(self.businessTrxId.text!) {
            parameters = addParameters(params: parameters, name: "businessTrxId", value: tempBusinessTrxId.description)
        }
        if let tempAppId = Int(self.appId.text!) {
            parameters = addParameters(params: parameters, name: "appId", value: tempAppId.description)
        }
        print(parameters)
        // make the http Request using the gathered paratemers
        restManager.makeHTTPGetRequest(path: String(format: "%@%@", Constants.HOST, queryURL), parameter:parameters) {response in
            if(response.1 == 200) {
                let error = self.checkForError(json : response.0)
                if error.isEmpty {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.present(Constants.alert(windowTitle: title, message: error, confirmButtonName: "okay"), animated: true, completion: nil)
                }
            }
        }
        
    }
    
    /**
     Function which cancels the filtering of invocations dismissing the view
     */
    @IBAction func cancelFiltering(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
