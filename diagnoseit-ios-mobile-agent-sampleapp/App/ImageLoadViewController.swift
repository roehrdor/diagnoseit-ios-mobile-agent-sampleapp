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

class ImageLoadViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchfield: UITextField!
    @IBOutlet weak var loadingAnimation: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = nil
        self.loadingAnimation.hidesWhenStopped = true
        NotificationCenter.default.addObserver(self, selector: #selector(ImageLoadViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ImageLoadViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        Agent.getInstance().startRootUsecase(name: "Big image usecase")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showButtonPressed(_ sender: Any) {
        Agent.getInstance().closeUsecase(name: "Begin Typing", root: "Big image usecase")
        if searchfield.text == "big picture" {
            self.loadingAnimation.startAnimating()
            let pictureUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/9/98/The_earth_at_night_(2).jpg")!
            let session = URLSession.shared;
            
            var request = NSMutableURLRequest(url: pictureUrl)
            request.httpMethod = "GET"
            
            Agent.getInstance().startRemoteCall(name: "Load big image", root:  "Big image usecase", url: pictureUrl.absoluteString, httpMethod: request.httpMethod, request: &request)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                do{
                    if let httpResponse = response as? HTTPURLResponse {
                        if (httpResponse.statusCode == 200) {
                            if let receivedData = data {
                                let image = UIImage(data: receivedData)
                                self.imageView.image = image
                                self.loadingAnimation.stopAnimating()
                                Agent.getInstance().closeRemoteCall(name: "Load big image", root:  "Big image usecase", responseCode: httpResponse.statusCode, timeout: false)
                            }
                        } else {
                            Agent.getInstance().closeRemoteCall(name: "Load big image", root:  "Big image usecase", responseCode: httpResponse.statusCode, timeout: false)
                        }
                        Agent.getInstance().closeUsecase(name: "Change Image", root: "Big image usecase")
                    }
                } catch {
                    print(error)
                }
            })
            task.resume()
            
        } else {
            self.imageView.image = nil
            Agent.getInstance().closeUsecase(name: "Change Image", root: "Big image usecase")
        }
    }

    @IBAction func beginTyping(_ sender: Any) {
        Agent.getInstance().startUsecase(name: "Change Image", root: "Big image usecase")
        Agent.getInstance().startUsecase(name: "Begin Typing", root: "Big image usecase")
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /**
     Function which dismisses this view returning to the previous one
     */
    @IBAction func dismissView(_ sender: Any) {
        Agent.getInstance().closeRootUsecase(name: "Big image usecase")
        dismiss(animated: true, completion: nil)
    }
    

}
