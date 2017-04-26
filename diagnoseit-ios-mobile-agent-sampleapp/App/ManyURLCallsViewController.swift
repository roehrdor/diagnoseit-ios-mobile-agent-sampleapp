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

class ManyURLCallsViewController: UIViewController {
    
    let restManager = RestManager()
    var bookList: [Book] = [Book]()
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 93, width: view.bounds.width, height: view.bounds.height-64))
        tableView.register(UINib(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: "BookCell")
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        let root = Agent.getInstance().startUseCase(name: "Too many Remote calls")
        var request = NSMutableURLRequest(url: URL(string: String(format: "%@", "https://www.googleapis.com/books/v1/volumes?q=isbn9788498383621"))!)
        let rc = Agent.getInstance().startRemotecall(name: "Load books", parent: root, url: String(format: "%@", "https://www.googleapis.com/books/v1/volumes?q=isbn9788498383621"), httpMethod: "GET", request: &request)
            
        restManager.makeHTTPGetRequest(request: request) {response in
            Agent.getInstance().closeRemoteCall(span: rc, responseCode: response.1, timeout: response.1 == 408)
            if(response.1 == 200) {
                self.bookList = try! self.loadFromJson(json: response.0)
                self.refreshTable()
            } else {
                print("ERROR CODE RETURNED FROM REMOTE CALL \(response.1)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.refreshTable()
    }
    
    /**
     Function which has the table View to reload the data
     */
    func refreshTable(){
        DispatchQueue.main.async(execute: {self.tableView.reloadData()})
    }
    
    @IBAction func dismissView(_ sender: Any) {
        Agent.getInstance().closeUseCase(name: "Too many Remote calls", root: "Too many Remote calls")
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFromJson(json: String, id : String = "", name : String = "") throws -> [Book] {
        // Initialize the array
        var models: [Book] = []
        // Try to transform the JSON String into an Array
        if let array = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options:[]) as? [String : Any] {
            let arrayItems = array["items"] as! [[String: Any]]
            for item in arrayItems {
                var imageLink = ""
                var selfLink = ""
                var bookDescription = ""
                selfLink = item["selfLink"] as! String
                let valueInfo = item["volumeInfo"] as! [String: Any]
                let authors = valueInfo["authors"] as! [String]
                let imageLinks = valueInfo["imageLinks"] as? [String: Any]
                if imageLinks != nil {
                    imageLink = imageLinks?["thumbnail"] as! String
                }
                if valueInfo["description"] != nil {
                    bookDescription = valueInfo["description"] as! String
                }
                
                
                let book = Book(valueInfo["title"] as! String, authors[0], bookDescription, imageLink, selfLink)
                models.append(book)
            }
            
        }
        return models
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ManyURLCallsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting the right element
        let model = self.bookList[indexPath.row]
        
        // Instantiate a cell
        let cellIdentifier = "BookCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BookTableViewCell
        
        // Adding the right informations
        cell.titleLabel?.text = model.title
        cell.authorLabel?.text = model.author
        cell.descLabel?.text = model.bookDescription
        
        
        if model.imageUrl != "" {
            var request = NSMutableURLRequest(url: URL(string: model.imageUrl)!)
            if let root = Agent.getInstance().getRootSpanForString(name: "Too many Remote call") {
                if let parent = Agent.getInstance().getSpanInRoot(root: root, parent: "Too many Remote call") {
                    let rc = Agent.getInstance().startRemotecall(name: "Load bookimage", parent: parent, url: model.imageUrl, httpMethod: "GET", request: &request)
                    restManager.getImage(request: request) {
                        response in
                        Agent.getInstance().closeRemoteCall(span: rc, responseCode: response.1, timeout: false)
                        if(response.1 == 200) {
                            cell.bookImage.image = UIImage(data: response.0)
                            //self.refreshTable()
                        } else {
                            print("ERROR CODE RETURNED FROM REMOTE CALL \(response.1)")
                        }
                    }
                }
            }
        }
        // Returning the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Row: \(indexPath.row)")
        print("section: \(indexPath.section)")
        //selectedIndex = indexPath.row
        //changeView()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ManyEqualURLController") as! ManyEqualUrlCallViewController
        newViewController.link = self.bookList[indexPath.row].selfLink
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176
    }
    
    
}
