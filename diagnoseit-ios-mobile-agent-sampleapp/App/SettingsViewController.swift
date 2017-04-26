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

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var hostInputField: UITextField!
    @IBOutlet weak var spanServiceInputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hostInputField.text = Constants.HOST;
        spanServiceInputField.text = Constants.spanServicetUrl;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveInput(_ sender: Any) {
        dismissKeyboard()
        var correctHost = false
        var correctSpanService = false
        if let hostUrl = hostInputField.text {
            if hostUrl != "" {
                Constants.HOST = hostUrl
                correctHost = true
            }
        }
        if let spanServicetUrl = spanServiceInputField.text {
            if spanServicetUrl != "" {
                Constants.spanServicetUrl = spanServicetUrl
                correctSpanService = true
            }
        }
        if correctHost && correctSpanService {
            Agent.getInstance().storageController.storeHostUrl(url: Constants.HOST)
            Agent.getInstance().storageController.storeMonitorUrl(url: Constants.spanServicetUrl)
            self.view.addSubview(AlertView(title: "Success", message: "The input has been saved", type: AlertView.success))
        } else {
            var message = ""
            if correctHost && !correctSpanService {
                Agent.getInstance().storageController.storeHostUrl(url: Constants.HOST)
                message = "Host Url saved, Monitor Url incorrect"
            } else if !correctHost && correctSpanService {
                Agent.getInstance().storageController.storeMonitorUrl(url: Constants.spanServicetUrl)
                message = "Host Url incorrect, Monitor Url saved"
            } else if !correctHost && !correctSpanService {
                message = "The input has not been saved"
            }
            
            self.view.addSubview(AlertView(title: "Failure", message: message, type: AlertView.failure))
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
