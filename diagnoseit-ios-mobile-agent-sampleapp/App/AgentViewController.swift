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
import CoreLocation


class AgentViewController: TableViewController, CLLocationManagerDelegate {
    
    var queryURL : String = "/rest/data/agents"
    var tooEarlyTimeout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Agent.getInstance().startUseCase(name: "Agents View")
        getData()
        self.tableView.reloadData()
        managmentSegue = "agentManagmentSegue"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        if let span = Agent.getInstance().getRootSpanForString(name: "Agents View") {
            Agent.getInstance().closeUseCase(span: span)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Function which retreives the latest Agents from the CMR querying the corresponding REST API
     */
    func getData() {
        print("start Request for Agents");
        
        var request = NSMutableURLRequest(url: URL(string: String(format: "%@%@", Constants.HOST, queryURL))!)
        let root = Agent.getInstance().startUseCase(name: "Agents View")
        let rc = Agent.getInstance().startRemotecall(name: "Load agents", parent: root, url: String(format: "%@%@", Constants.HOST, queryURL), httpMethod: "GET", request: &request)
        restManager.makeHTTPGetRequest(request: request) {response in
            do {
                self.list = try AgentModel.loadFromJson(json: response.0) as [AgentModel];
            } catch {
                self.list = []
            }
            self.do_table_refresh()
            Agent.getInstance().closeRemoteCall(span: rc, responseCode: response.1, timeout: response.2)
        }
    }
    
    /**
     Override the prepare function in order to create the model needed for the segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == managmentSegue {
            if let agentManagmentVC = segue.destination as? AgentManagmentViewController {
                agentManagmentVC.agentModel = list[selectedIndex] as! AgentModel
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the right element
        let model = self.list[indexPath.row]
        
        // Instantiate a cell
        let cellIdentifier = "ElementCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        // Adding the right informations
        cell.idLabel?.text = model.printId
        cell.nameLabel?.text = model.printName
        
        // TODO: State view color
        // cell.stateView?.backgroundColor = UIUtil.greenColor
        
        // Returning the cell
        return cell
    }
    
    
    
    
}
