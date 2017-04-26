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


class InvocationViewController: TableViewController {
    
    var queryURL = "/rest/data/invocations";
    let invocationFilterSegueId = "invocationFilterSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        managmentSegue = "invocationManagmentSegue"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Function which retreives the latest invocations from the CMR querying the corresponding REST API
     */
    func getData() {
        print("start Request for invocation");
        var request = NSMutableURLRequest(url: URL(string: String(format: "%@%@", Constants.HOST, queryURL))!)
        let root = Agent.getInstance().startUseCase(name: "Invocation View")
        let rc = Agent.getInstance().startRemotecall(name: "Load invocations", parent: root, url: String(format: "%@%@", Constants.HOST, queryURL), httpMethod: "GET", request: &request)

        restManager.makeHTTPGetRequest(path: String(format: "%@%@", Constants.HOST, queryURL), parameter:"") {response in
            if (response.1 == 200) {
                self.applyData(json: response.0)
            }
            Agent.getInstance().closeRemoteCall(span: rc, responseCode: response.1, timeout: response.2)
        }
        
    }
    
    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        if let span = Agent.getInstance().getRootSpanForString(name: "Invocation View") {
            Agent.getInstance().closeUseCase(span: span)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Function which applies the given data to the list  
     
     -parameters:
        -json: the data to apply to the list
     */
    func applyData(json : String) {
        print("gotResults")
        self.list = try! InvocationModel.loadFromJson(json: json) as [InvocationModel];
        print("doRefresh")
        self.do_table_refresh()
    }
    
    /**
     Override the prepare function in order to create the model needed for the segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == managmentSegue {
            if let invocationManagmentVC = segue.destination as? InvocationManagmentViewController {
                invocationManagmentVC.invocationModel = list[selectedIndex] as! InvocationModel
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
     Function which initiates the segue to the filter  the invocation of the finalize storage REST API
     */
    @IBAction func filterInvocations(_ sender: Any) {
        self.performSegue(withIdentifier: self.invocationFilterSegueId, sender: self)
    }
    
}
