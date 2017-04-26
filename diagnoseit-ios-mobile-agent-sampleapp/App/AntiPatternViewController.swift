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

class AntiPatternViewController: UIViewController {

    var queryURL : String = "/rest/data/agents/timeout"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func buildExampleTree() {
        Agent.getInstance().changeTimerIntervall(seconds: 0.1)
        let root = Agent.getInstance().startUseCase(name: "Root")
        let r1 = Agent.getInstance().startUseCase(parentSpan: root, name: "R1")
        let r2 = Agent.getInstance().startUseCase(parentSpan: root, name: "R2")
        let r3 = Agent.getInstance().startUseCase(parentSpan: root, name: "R3")
        let r21 = Agent.getInstance().startUseCase(parentSpan: r2, name: "R21")
        Agent.getInstance().startUseCase(parentSpan: r1, name: "R11")
        Agent.getInstance().startUseCaseAppendLast(name: "R111", root: root)
        Agent.getInstance().startUseCase(parentSpan: r21, name: "R211")
        Agent.getInstance().startUseCase(parentSpan: r21, name: "R212")
        Agent.getInstance().startUseCase(parentSpan: r21, name: "R213")
        Agent.getInstance().startUseCase(parentSpan: r1, name: "R12")
        Agent.getInstance().startUseCaseAppendLast(name: "R121", root: root)
        sleep(1)
        Agent.getInstance().closeUseCase(span: root)
        Agent.getInstance().changeTimerIntervall(seconds: 10)
    }

    @IBAction func tooEarlyTimeoutButtonHandler(_ sender: Any) {
        var request = NSMutableURLRequest(url: URL(string: String(format: "%@%@", Constants.HOST, queryURL))!)
        let sp = Agent.getInstance().startUseCase(name: "ET")
        let rc = Agent.getInstance().startRemotecall(name: "LA", parent: sp, url: String(format: "%@%@", Constants.HOST, queryURL),httpMethod: "GET", timeout: 4.0, request: &request)
        RestManager().makeHTTPGetRequest(request: request) {response in
            if(response.1 < 0) {
                print("CALL NOT SUCCESSFUL")
            }
            Agent.getInstance().closeRemoteCall(span: rc, responseCode: response.1, timeout: response.2)
            print("TIMEOUT OF SPAN: \(rc.timeout)")
            sleep(4)
            Agent.getInstance().closeUseCase(span: sp)
        }
    }
    
    override func didReceiveMemoryWarning() {
        print("ATTENTION")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func openTimeoutAntipattern(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AgentViewController") as! AgentViewController
        newViewController.tooEarlyTimeout = true
        self.present(newViewController, animated: true, completion: nil)
        
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
