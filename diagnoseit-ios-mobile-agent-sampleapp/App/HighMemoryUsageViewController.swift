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

class HighMemoryUsageViewController: UIViewController {
    
    // Handler for the execute UseCase Button
    @IBAction func executeButton(_ sender: Any) {
        self.executeUseCaseMemoryRamp()
    }
    @IBAction func executeHighUtil(_ sender: Any) {
        self.executeUseCaseMeoryHighUtilization()
    }
    
    // Labels for memory usage in percent and for the app
    @IBOutlet weak var memoryAppUsageLabel: UILabel!
    @IBOutlet weak var memoryLoadLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showRamUsage()
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(self.showRamUsage), userInfo: nil, repeats: true)
    }
    

    
    //
    // execute the use case ramp, allocate some ram
    //
    func executeUseCaseMemoryRamp() {
        DispatchQueue.global().async(execute : {
            let freeMemory = Int(Double(Agent.getInstance().intervalMetricsConrtoller.getFreeMem()) * 0.40)
            print("Starting use case..., allocating222 \(freeMemory) Bytes")
            Agent.getInstance().changeTimerIntervall(seconds: 0.2)
            let root = Agent.getInstance().startUseCase(name: "HMUR")
            let uc = Agent.getInstance().startUseCase(name: "HMU", root: root)
            let data = UnsafeMutablePointer<Int32>.allocate(capacity: freeMemory)
            data.initialize(to: 0xF00D, count: freeMemory)
            Agent.getInstance().closeUseCase(span: uc)
            Agent.getInstance().closeUseCase(span: root)
            Agent.getInstance().changeTimerIntervall(seconds: 5)
            print("Releasing memory now...")
            data.deallocate(capacity: freeMemory)
        })
    }
    
    //
    // execute the use case utilization, allocate some ram
    //
    func executeUseCaseMeoryHighUtilization() {
        DispatchQueue.global().async(execute : {
            let freeMemory = Int(Agent.getInstance().intervalMetricsConrtoller.getFreeMem())
            print("Starting use case..., allocating \(freeMemory) Bytes")
            Agent.getInstance().changeTimerIntervall(seconds: 0.2)
            let data = UnsafeMutablePointer<Int32>.allocate(capacity: freeMemory)
            data.initialize(to: 0xF00D, count: freeMemory)
            let root = Agent.getInstance().startUseCase(name: "HIGH MEMORY USAGE")
            Agent.getInstance().startUseCase(parentSpan: root, name: "LOAD MEMORY")
            sleep(1)
            
            // fortunately closing the root is enough since the children are
            // automatically closed
            Agent.getInstance().closeUseCase(span: root)
            Agent.getInstance().changeTimerIntervall(seconds: 5)
            print("Releasing memory now...")
            data.deallocate(capacity: freeMemory)
        })
    }
    
    
    //
    // Update the labels with the current ram values
    //
    func showRamUsage() {
        self.memoryLoadLabel.text = "\(Agent.getInstance().intervalMetricsConrtoller.getMemoryLoad() * 100)%";
        self.memoryAppUsageLabel.text = "\(Float(Agent.getInstance().intervalMetricsConrtoller.getMemorySize()) / 1024 / 1024) MB"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
