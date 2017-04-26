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

class TableViewController: UIViewController {
    
    var restManager : RestManager!
    var list : [SuperModel] = []
    var tableView: UITableView!
    var selectedIndex : Int! = -1
    var managmentSegue : String = Constants.UNKNOWN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restManager = RestManager()
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height-64))
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "ElementCell")
        view.addSubview(tableView)
        self.tableView = tableView
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.do_table_refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Function which has the table View to reload the data
     */
    func do_table_refresh(){
        DispatchQueue.main.async(execute: {self.tableView.reloadData()})
    }
    
    /**
     Function which performs a segue to a consecutive view given the variable 'managmentSegue'
     of this class was overwritten by the class extending this class. Otherwise a corresponding
     altert view is shown.
     */
    func changeView() {
        if (managmentSegue==Constants.UNKNOWN) {
            self.present(Constants.alert(windowTitle: "Segue name missing", message: "The name for the necessary Segue was not set! You need to overwrite the managmentSegue variable inherited from TableViewController!", confirmButtonName: "Okay"), animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: managmentSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == managmentSegue) {
            self.present(Constants.alert(windowTitle: "Segue not implemented", message: "Segue preparation was not overwritten! You need to overwrite the prepare function inherited from TableViewController!", confirmButtonName: "Okay"), animated: true, completion: nil)
        }
    }
    
}


extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the right element
        let model = self.list[indexPath.row]
        
        // Instantiate a cell
        let cellIdentifier = "ElementCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        // Adding the right informations
        cell.idLabel?.text = model.printId
        cell.nameLabel?.text = model.printName
        
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Row: \(indexPath.row)")
        print("section: \(indexPath.section)")
        selectedIndex = indexPath.row
        changeView()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}

