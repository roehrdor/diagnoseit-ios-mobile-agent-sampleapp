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


class BusinessTransactionsViewController: TableViewController, CLLocationManagerDelegate {
    
    var queryURL : String = "/rest/bc/app"
    var appId : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Agent.getInstance(self).startUseCaseMeasurement(usecaseName: "Load Business Transactions", usecaseDescription: "loading Business Transactions")
        getData()
        self.tableView.reloadData()
        // Agent.getInstance(self).endUseCaseMeasurement(usecaseName: "Load Business Transactions")
        managmentSegue = "BusinessTransactionDetailSegue"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Function which retreives the latest business transactions from the CMR querying the corresponding REST API
     */
    func getData() {
        print("start Request for Business Transactions");
        var request = NSMutableURLRequest(url: URL(string: String(format: "%@%@", Constants.HOST, queryURL))!)
        let root = Agent.getInstance().startUseCase(name: "Business Transactions View")
        let rc = Agent.getInstance().startRemotecall(name: "Load Business Transactions", parent: root, url: String(format: "%@%@", Constants.HOST, queryURL), httpMethod: "GET", request: &request)
        restManager.makeHTTPGetRequest(path: String(format: "%@%@/%i/btx", Constants.HOST, queryURL, appId), parameter:"") {response in
            print("gotResults")
            print(response)
            self.list = try! BusinessTransactionModel.loadFromJson(json: response.0) as [BusinessTransactionModel];
            print("doRefresh")
            self.do_table_refresh()
            Agent.getInstance().closeRemoteCall(span: rc, responseCode: response.1, timeout: response.2)
        }
        
        
    }
    
    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        if let span = Agent.getInstance().getRootSpanForString(name: "Business Transactions View") {
            Agent.getInstance().closeUseCase(span: span)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Override the prepare function in order to create the model needed for the segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == managmentSegue {
            if let btVC = segue.destination as? BusinessTransactionViewController {
                btVC.businessTransactionModel = list[selectedIndex] as! BusinessTransactionModel
            }
        }
    }
    
    
}
