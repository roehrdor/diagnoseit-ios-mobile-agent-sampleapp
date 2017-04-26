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

class ManyEqualUrlCallViewController: UIViewController {
    
    let restManager = RestManager()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var coverImageview: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var book: Book?
    var link: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Agent.getInstance().startRootUsecase(name: "Too many equal Remote calls")
        for _ in 1...100 {
            var request = NSMutableURLRequest(url: URL(string: String(format: "%@", link))!)
            Agent.getInstance().startRemoteCall(name: "Load book", root: "Too many equal Remote calls", url: String(format: "%@", link), httpMethod: "GET", request: &request)
            restManager.makeHTTPGetRequest(request: request) { response in
                Agent.getInstance().closeRemoteCall(name: "Load book", root: "Too many equal Remote calls", responseCode: response.1, timeout: false)
                if(response.1 == 200) {
                    self.book = self.loadFromJson(json: response.0)
                    if self.book != nil {
                        self.titleLabel.text = self.book?.title
                        self.authorLabel.text = self.book?.author
                        if self.book?.imageUrl != "" {
                            var request = NSMutableURLRequest(url: URL(string: (self.book?.imageUrl)!)!)
                            let remoteCall = Agent.getInstance().startRemoteCall(name: "Load bookimage", root: "Too many equal Remote calls", parent: "Load book", url: (self.book?.imageUrl)!, httpMethod: "GET", request: &request)
                            self.restManager.getImage(request: request) {
                                response in
                                Agent.getInstance().closeRemoteCall(name: "Load bookimage", root: "Too many equal Remote calls", id: (remoteCall?.id)!, responseCode: response.1, timeout: false)
                                if(response.1 == 200) {
                                    self.coverImageview.image = UIImage(data: response.0)
                                } else {
                                    print("ERROR CODE RETURNED FROM REMOTE CALL \(response.1)")
                                }
                            }
                        }
                        self.descriptionLabel.text = self.book?.bookDescription
                    }
                } else {
                    print("ERROR CODE RETURNED FROM REMOTE CALL \(response.1)")
                }
            }
        }
        
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        Agent.getInstance().closeRootUsecase(name: "Too many equal Remote calls")
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFromJson(json: String, id : String = "", name : String = "") -> Book? {
        // Try to transform the JSON String into an Array
        if let array = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options:[]) as? [String : Any] {
            var imageLink = ""
            var bookDescription = ""
            let valueInfo = array["volumeInfo"] as! [String: Any]
            let selfLink = array["selfLink"] as! String
            let authors = valueInfo["authors"] as! [String]
            let imageLinks = valueInfo["imageLinks"] as? [String: Any]
            if imageLinks != nil {
                imageLink = imageLinks?["thumbnail"] as! String
            }
            if valueInfo["description"] != nil {
                bookDescription = valueInfo["description"] as! String
            }
            return Book(valueInfo["title"] as! String, authors[0], bookDescription, imageLink, selfLink)
        }
        return nil
    }
    
}
