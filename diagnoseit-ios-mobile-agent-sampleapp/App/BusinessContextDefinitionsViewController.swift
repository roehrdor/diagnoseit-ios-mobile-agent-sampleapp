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


class BusinessContextDefinitionsViewController: TableViewController, CLLocationManagerDelegate {
    
    var queryURL : String = "/rest/bc/definition/app"
    var detailSegue = "BusinessContextDefinitionDetailSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Agent.getInstance(self).startUseCaseMeasurement(usecaseName: "Load Business Context Definitions", usecaseDescription: "loading Business Context Definitions")
        getData()
        self.tableView.reloadData()
        // Agent.getInstance(self).endUseCaseMeasurement(usecaseName: "Load Business Context Definitions")
        managmentSegue = "BusinessContextDefinitionSegue"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Function which retreives the latest business context definitions from the CMR querying the corresponding REST API
     */
    func getData() {
        print("start Request for Business Context Definitions");
        restManager.makeHTTPGetRequest(path: String(format: "%@%@", Constants.HOST, queryURL), parameter:"") {response in
            print("gotResults")
            if(response.1 == 200) {
                self.list = try! BusinessContextDefinitionModel.loadFromJson(json: response.0) as [BusinessContextDefinitionModel];
                print("doRefresh")
                self.do_table_refresh()
            }
        }
        
        
    }
    
    /**
     Override the prepare function in order to create the model needed for the segue and to distinguish between
     the segue to the transaction and context details view
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == managmentSegue {
                if let btdVC = segue.destination as? BusinessTransactionDefinitionsViewController {
                    let model = list[selectedIndex] as! BusinessContextDefinitionModel
                    print(model)
                    btdVC.appId = model.id
                }
            } else if segue.identifier == detailSegue {
                if let bcdVC = segue.destination as? BusinessContextDefinitionViewController {
                    bcdVC.businessContextDefinitionModel = list[selectedIndex] as! BusinessContextDefinitionModel
                }
        }
        
    }
    
    /**
     Function which is to be initiating a segue to either the consecutive transaction or context details view
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
     Override the changeView function since there are two consecutive views which can be shown (transaction or context details view)
     The decision is aquired using a alert window
     */
    override func changeView() {
        if (managmentSegue==Constants.UNKNOWN) {
            self.present(Constants.alert(windowTitle: "Segue name missing", message: "The name for the necessary Segue was not set! You need to overwrite the managmentSegue variable inherited from TableViewController!", confirmButtonName: "Okay"), animated: true, completion: nil)
        } else {
            let title : String = "Business Context"
            let alert = Constants.alert(windowTitle: title, message: "Would you like to see the Context Details or the corresponding Transactions?", confirmButtonName: "Cancel")
            
            let detailChoice = UIAlertAction(title: "Definition Details", style: .default) { (action:UIAlertAction!) in
                self.performCustomSegue(showTransactions:false)
            }
            alert.addAction(detailChoice)
            
            let transactionsChoice = UIAlertAction(title: "Business Transaction Definitions", style: .default) { (action:UIAlertAction!) in
                self.performCustomSegue(showTransactions:true)
            }
            alert.addAction(transactionsChoice)
            
            // show the created alert window
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
