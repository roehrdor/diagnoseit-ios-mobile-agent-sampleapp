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

import Foundation
import UIKit


class StorageViewController: TableViewController {
    
    var queryURL : String = "/rest/storage"
    
    @IBOutlet weak var addstoragebutton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        managmentSegue = "storageManagmentSegue";
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Function which retreives the latest storages from the CMR querying the corresponding REST API
    */
    func getData() {
        print("start Request for Storages");
        var request = NSMutableURLRequest(url: URL(string: String(format: "%@%@", Constants.HOST, queryURL))!)
        let root = Agent.getInstance().startUseCase(name: "Storage View")
        let rc = Agent.getInstance().startRemotecall(name: "Load storages", parent: root, url: String(format: "%@%@", Constants.HOST, queryURL), httpMethod: "GET", request: &request)
        restManager.makeHTTPGetRequest(path: String(format: "%@%@", Constants.HOST, queryURL), parameter:"") {response in
            if(response.1 == 200) {
                self.list = try! StorageModel.loadFromJson(json: response.0) as [StorageModel];
                self.do_table_refresh()
            }
            Agent.getInstance().closeRemoteCall(span: rc, responseCode: response.1, timeout: response.2)
        }
        
    }
    
    /**
     Override the prepare function in order to create the model needed for the segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == managmentSegue {
            if let storageManagmentVC = segue.destination as? StorageManagmentViewController {
                storageManagmentVC.storageModel = list[selectedIndex] as! StorageModel
            }
        }
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
        let button : UIButton = UIButton(frame: CGRect(x: x, y: y, width: 50, height: 20))
        button.setTitle(name, for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: pressed, for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }
    
    /**
     Function which initializes the invocation of the finalize storage REST API
     */
    @IBAction func addStorageButtonPressed(_ sender: Any) {
        addStorage()
    }
    
    /**
     Function which initializes the invocation of the finalize storage REST API
     */
    func addStorage() {
        let title : String = "Create Storage"
        let alert = Constants.alert(windowTitle: title, message: "Please insert Storage name", confirmButtonName: "Cancel")
        alert.addTextField { (textField) in
            textField.text = "name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action:UIAlertAction!) in
            let textField = alert.textFields![0] 
            let input : String = textField.text!
            self.makeRequest(title: title, apiPath: String(format: "%@/create", input), messageKey: "message", parameters: "")
        }
        alert.addAction(addAction)
        // Show the created alert window
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     Function which invokes a REST-API on the CMR using the given apiPath and parameters. After receiving the response it extracts the messages from it
     using the given messageKey and shows the result in an alert window setting the title to the passed one.
     
     - parameters:
     - title: The title of the corresponding alert window
     - apiPath: The path to the REST API (simply appended to the Host and QueryURL) which is to be invoked
     - messageKey: The key which identifies the message in the response json
     - parameters: Parameters to append to the request
     */
    func makeRequest(title : String, apiPath : String, messageKey: String, parameters : String) {
        restManager.makeHTTPGetRequest(path: String(format: "%@%@/%@", Constants.HOST, queryURL, apiPath), parameter: parameters) {response in
            if(response.1 == 200) {
                print(response)
                self.present(Constants.alert(windowTitle: title, message: self.extractMessage(json: response.0, key: messageKey), confirmButtonName: "okay"), animated: true, completion: nil)
                self.getData()
            }
        }
    }
    
    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        if let span = Agent.getInstance().getRootSpanForString(name: "Storage View") {
            Agent.getInstance().closeUseCase(span: span)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Function which extracts a message from a dictionary by using the given key. If the Key does not exist
     it is assumed that the key is 'error'. If this is not the case either the passed json is returned.
     
     - parameters:
     - json: The json du extract the message from
     - key: The key which identifies the information to extract from the dictionary
     */
    func extractMessage(json : String, key : String) -> String {
        do {
            let jsonData=try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options:[]) as! [String:AnyObject]
            if let val = jsonData[key] {
                return val as! String
            }
            if let error = jsonData["error"] {
                return error as! String
            }
        } catch {
            return json
        }
        return json
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Instantiate a cell
        let cellIdentifier = "ElementCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        // Getting the right element
        let model = self.list[indexPath.row]
        
        
        
        // Adding the right informations
        cell.idLabel?.text = model.printId
        cell.nameLabel?.text = model.printName
        
        let storageModel = model as! StorageModel
        if storageModel.state == "OPENED" {
            cell.stateView?.backgroundColor = UIUtil.greenColor
        } else {
            cell.stateView?.backgroundColor = UIUtil.redColor
        }
        
        
        
        // Returning the cell
        return cell
    }
    
}
