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
import CoreLocation


class AgentMethodViewController: TableViewController, CLLocationManagerDelegate {
    
    var queryURL : String = "/rest/data/agents"
    var agentModel : AgentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Agent.getInstance(self).startUseCaseMeasurement(usecaseName: "Load Agent Methods", usecaseDescription: "loading Agent Methods")
        getData()
        self.tableView.reloadData()
        // Agent.getInstance(self).endUseCaseMeasurement(usecaseName: "Load Agent Methods")
        managmentSegue = "AgentMethodDetailSegue"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Function which retreives the latest agent method data from the CMR querying the corresponding REST API
     */
    func getData() {
        print("start Request for Agent Methods");
        restManager.makeHTTPGetRequest(path: String(format: "%@%@/%i/methods", Constants.HOST, queryURL, self.agentModel.id), parameter:"") {response in
            print(response)
            if(response.1 == 200) {
                self.list = try! AgentInstrumentedMethodModel.loadFromJson(json: response.0) as [AgentInstrumentedMethodModel];
                print("doRefresh")
                self.do_table_refresh()
            }
        }
    
    }
    
    /**
     Override the prepare function in order to create the model needed for the segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == managmentSegue {
            if let amdVC = segue.destination as? AgentMethodDetailViewController {
                amdVC.instrumentedMethod = list[selectedIndex] as! AgentInstrumentedMethodModel
            }
        }
    }
    
    
}
