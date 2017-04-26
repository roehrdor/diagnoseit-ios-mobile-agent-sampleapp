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
class StorageManagmentViewController: UIViewController {
    
    var restManager : RestManager!
    var scrollview: UIScrollView!
    var storageModel : StorageModel!
    let queryURL : String = "/rest/storage"
    var delete : UIButton!
    var finalizeState : UIButton!
    var recordingState : UIButton!
    var startRecording : UIButton!
    var stopRecording : UIButton!
    let scheduleRecordingSegueId = "scheduleRecordingSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restManager = RestManager()
        scrollview = UIScrollView(frame: CGRect(x: 0, y: UIUtil.topbarHeight, width: self.view.frame.width, height: self.view.frame.height - UIUtil.topbarHeight))
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: 540 + UIUtil.padding)
        scrollview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(scrollview)
        UIUtil.addLabel(name: "ID", text : storageModel.id, x : UIUtil.padding, y : 20, view: scrollview)
        UIUtil.addLabel(name: "Name", text : storageModel.name, x : UIUtil.padding, y : 40, view: scrollview)
        UIUtil.addLabel(name: "DiskSize", text : storageModel.diskSize.description, x : UIUtil.padding, y : 60, view: scrollview)
        UIUtil.addLabel(name: "Description", text : storageModel.description, x : UIUtil.padding, y : 80, view: scrollview)
        UIUtil.addLabel(name: "CMR Version", text : storageModel.cmrVersion, x : UIUtil.padding, y : 100, view: scrollview)
        UIUtil.addLabel(name: "State", text : storageModel.state, x : UIUtil.padding, y : 120, view: scrollview)
        UIUtil.addLabel(name: "Closed", text : storageModel.storageClosed.description, x : UIUtil.padding, y : 140, view: scrollview)
        UIUtil.addLabel(name: "Opened", text : storageModel.storageOpened.description, x : UIUtil.padding, y :160, view: scrollview)
        UIUtil.addLabel(name: "Description", text : storageModel.storageRecording.description, x : UIUtil.padding, y : 180, view: scrollview)
        UIUtil.addLabel(name: "Folder", text : storageModel.storageFolder, x : UIUtil.padding, y : 200, view: scrollview)
        UIUtil.addFullButton(name:"delete", x: UIUtil.padding, y: 240, target: self, pressed: #selector(self.deleteStorage(_:)), view: scrollview)
        UIUtil.addFullButton(name:"finalize", x: UIUtil.padding, y: 300, target: self, pressed: #selector(self.finalizeStorage(_:)), view: scrollview)
        UIUtil.addFullButton(name:"recordingState", x: UIUtil.padding, y: 360, target: self, pressed: #selector(self.getRecordingState(_:)), view: scrollview)
        UIUtil.addFullButton(name:"start Recording", x: UIUtil.padding, y: 420, target: self, pressed: #selector(self.startRecording(_:)), view: scrollview)
        UIUtil.addFullButton(name:"stop Recording", x: UIUtil.padding, y: 480, target: self, pressed: #selector(self.stopRecording(_:)), view: scrollview)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    /**
     Override the prepare function in order to create the model needed for the segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == scheduleRecordingSegueId {
            if let ScheduleRecordingVC = segue.destination as? ScheduleRecordingViewController {
                ScheduleRecordingVC.storageModel = self.storageModel
            }
        }
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
    
    /**
     Function which initializes the invocation of the delete storage REST API
     */
    @IBAction func deleteStorage(_ sender: Any) {
        makeRequest(title: "Delete Storage", apiPath: String(format: "%@/delete", self.storageModel.id), messageKey: "message", parameters: "")
    }
    
    /**
     Function which initializes the invocation of the finalize storage REST API
     */
    @IBAction func finalizeStorage(_ sender: Any) {
        makeRequest(title: "Finalize Storage", apiPath: String(format: "%@/finalize", self.storageModel.id), messageKey: "message", parameters: "")
    }
    
    /**
     Function which initializes the invocation of the get recording state REST API
     */
    @IBAction func getRecordingState(_ sender: Any) throws {
        makeRequest(title: "Recording State", apiPath: "state", messageKey: "recordingState", parameters: "")
    }
   
    /**
     Function which initializes the invocation of the start recording REST API
     */
    @IBAction func startRecording(_ sender: Any) {
        let title : String = "Start Recording"
        // Create a alert window with the given title and a specific messages as well as the standart action 'cancel'
        let alert = Constants.alert(windowTitle: title, message: "Do you wish to set extra parameters?", confirmButtonName: "Cancel")
        // Create and add a action button in the alert window for the segue to the view for setting addition parameters
        let addParameters = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            self.performSegue(withIdentifier: self.scheduleRecordingSegueId, sender: self)
        }
        alert.addAction(addParameters)
        // Create and add a action button in the alert window for starting the recording immediately
        let startImmediately = UIAlertAction(title: "No", style: .default) { (action:UIAlertAction!) in
            self.makeRequest(title: title, apiPath: "start", messageKey: "message", parameters: String(format: "id=%@", self.storageModel.id))
        }
        alert.addAction(startImmediately)
        // Show the created alert window
        self.present(alert, animated: true, completion: nil)
    }
    
    /**
     Function which initializes the invocation of the stop recording REST API
     */
    @IBAction func stopRecording(_ sender: Any) {
        makeRequest(title: "Stop Recording", apiPath: "stop", messageKey: "message", parameters: "")
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
