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


class BusinessContextsViewController: TableViewController, CLLocationManagerDelegate {
    
    var queryURL : String = "/rest/bc/app"
    var detailSegue = "BusinessContextDetailSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        self.tableView.reloadData()
        managmentSegue = "BusinessTransactionManagmentSegue"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Function which retreives the latest business context data from the CMR querying the corresponding REST API
     */
    func getData() {
        print("start Request for Business Context");
        var request = NSMutableURLRequest(url: URL(string: String(format: "%@%@", Constants.HOST, queryURL))!)
        let root = Agent.getInstance().startUseCase(name: "Business Contexts View")
        let rc = Agent.getInstance().startRemotecall(name: "Load Business Contexts", parent: root, url: String(format: "%@%@", Constants.HOST, queryURL), httpMethod: "GET", request: &request)
        restManager.makeHTTPGetRequest(path: String(format: "%@%@", Constants.HOST, queryURL), parameter:"") {response in
            if(response.1 == 200) {
                print("gotResults")
                self.list = try! BusinessContextModel.loadFromJson(json: response.0) as [BusinessContextModel];
                print("doRefresh")
                self.do_table_refresh()
            }
            Agent.getInstance().closeRemoteCall(span: rc, responseCode: response.1, timeout: response.2)
        }
    }
    
    /**
     Override the prepare function in order to create the model needed for the segue and to distinguish between
     the segue to the transaction and context view
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == managmentSegue {
            if let btVC = segue.destination as? BusinessTransactionsViewController {
                let model = list[selectedIndex] as! BusinessContextModel
                print(model)
                btVC.appId = model.id
            }
        } else if segue.identifier == detailSegue {
            if let bcVC = segue.destination as? BusinessContextViewController {
                bcVC.businessContextModel = list[selectedIndex] as! BusinessContextModel
                print(bcVC.businessContextModel)
            }
        }
        
    }
    
    /**
     Function which is to be initiating a segue to either the consecutive transaction or context view
     */
    func performCustomSegue (showTransactions : Bool) {
        if showTransactions {
            print("transactions")
            performSegue(withIdentifier: managmentSegue, sender: self)
        } else {
            print("details")
            performSegue(withIdentifier: detailSegue, sender: self)
        }
    }
    
    /**
     Override the changeView function since there are two consecutive views which can be shown (transaction or context view)
     The decision is aquired using a alert window
     */
    override func changeView() {
        if (managmentSegue==Constants.UNKNOWN) {
            self.present(Constants.alert(windowTitle: "Segue name missing", message: "The name for the necessary Segue was not set! You need to overwrite the managmentSegue variable inherited from TableViewController!", confirmButtonName: "Okay"), animated: true, completion: nil)
        } else {
            let title : String = "Business Context"
            let alert = Constants.alert(windowTitle: title, message: "Would you like to see the Context Details or the corresponding Transactions?", confirmButtonName: "Cancel")
            
            let detailChoice = UIAlertAction(title: "Context Details", style: .default) { (action:UIAlertAction!) in
                self.performCustomSegue(showTransactions:false)
            }
            alert.addAction(detailChoice)
            
            let transactionsChoice = UIAlertAction(title: "Business Transactions", style: .default) { (action:UIAlertAction!) in
                self.performCustomSegue(showTransactions:true)
            }
            alert.addAction(transactionsChoice)
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }

    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        if let span = Agent.getInstance().getRootSpanForString(name: "Business Context View") {
            Agent.getInstance().closeUseCase(span: span)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
