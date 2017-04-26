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

struct InvocationModel : SuperModel{
    
    let printName: String
    let printId: String
    let id: Int
    let platformIdent: Int
    let sensorTypeIdent: Int
    let timeStamp: Int
    let methodIdent: Int
    let timerData : TimerData!
    let duration: Double
    let childCount: Int
    let applicationId: Int
    let businessTransactionId: Int
}

struct TimerData {
    
    let invocationClass : String
    let id: Int
    let platformIdent: String
    let timeStamp: Int
    let methodIdent: Int
    let min: Double
    let max: Double
    let count: Int
    let duration: Double
    let cpuMin: Double
    let cpuMax: Double
    let cpuDuration: Double
    let exclusiveCount: Int
    let exclusiveDuration: Double
    let exclusiveMax: Double
    let exclusiveMin: Double
}


extension InvocationModel {
    
    static func from<T>(dict: [String: AnyObject]) -> T where T:SuperModel {
        
        let invocationId: Int = dict["id"] as! Int;
        let invocationplatformIdent: Int = dict["platformIdent"] as! Int;
        let sensorTypeIdent: Int = dict["sensorTypeIdent"] as! Int;
        let invocationtimeStamp: Int = dict["timeStamp"] as! Int;
        let invocationmethodIdent: Int = dict["methodIdent"] as! Int;
        let invocationduration: Double = dict["duration"] as! Double;
        let childCount: Int = dict["childCount"] as! Int;
        var applicationId : Int = -1;
        if let tempAppId: Int = dict["applicationId"] as? Int {
            applicationId = tempAppId
        }
        var businessTransactionId : Int = -1;
        if let tempBisTraId: Int = dict["businessTransactionId"] as? Int {
            businessTransactionId = tempBisTraId
        }
        let printId: String = String(format: "ID: %i", invocationId);
        let printName: String = String(format: "%@, ApplicationID: %i", printId, applicationId);
        // extract the Timer Data (if present)
        if let temp = dict["timerData"] {
            let timerDataDict : [String: AnyObject] = temp as! [String: AnyObject]
            let invocationClass : String = timerDataDict["@class"] as! String;
            let id: Int = timerDataDict["id"] as! Int;
            let platformIdent: String = timerDataDict["platformIdent"] as! String;
            let timeStamp: Int = timerDataDict["timeStamp"] as! Int;
            let methodIdent: Int = timerDataDict["methodIdent"] as! Int;
            let min: Double = timerDataDict["min"] as! Double;
            let max: Double = timerDataDict["max"] as! Double;
            let count: Int = timerDataDict["count"] as! Int;
            let duration: Double = timerDataDict["duration"] as! Double;
            let cpuMin: Double = timerDataDict["cpuMin"] as! Double;
            let cpuMax: Double = timerDataDict["cpuMax"] as! Double;
            let cpuDuration: Double = timerDataDict["cpuDuration"] as! Double;
            let exclusiveCount: Int = timerDataDict["exclusiveCount"] as! Int;
            let exclusiveDuration: Double = timerDataDict["exclusiveDuration"] as! Double;
            let exclusiveMax: Double = timerDataDict["exclusiveMax"] as! Double;
            let exclusiveMin: Double = timerDataDict["exclusiveMin"] as! Double;
            let timerData = TimerData(invocationClass: invocationClass,
                                                  id: id,
                                                  platformIdent: platformIdent,
                                                  timeStamp: timeStamp,
                                                  methodIdent: methodIdent,
                                                  min: min,
                                                  max: max,
                                                  count: count,
                                                  duration: duration,
                                                  cpuMin: cpuMin,
                                                  cpuMax: cpuMax,
                                                  cpuDuration: cpuDuration,
                                                  exclusiveCount: exclusiveCount,
                                                  exclusiveDuration: exclusiveDuration,
                                                  exclusiveMax: exclusiveMax,
                                                  exclusiveMin: exclusiveMin)
            return InvocationModel(printName: printName,
                                   printId: printId,
                                   id: invocationId,
                                   platformIdent: invocationplatformIdent,
                                   sensorTypeIdent:sensorTypeIdent,
                                   timeStamp: invocationtimeStamp,
                                   methodIdent: invocationmethodIdent,
                                   timerData: timerData,
                                   duration: invocationduration,
                                   childCount: childCount,
                                   applicationId: applicationId,
                                   businessTransactionId: businessTransactionId) as! T
        } else {
            return InvocationModel(printName: printName,
                                   printId: printId,
                                   id: invocationId,
                                   platformIdent: invocationplatformIdent,
                                   sensorTypeIdent:sensorTypeIdent,
                                   timeStamp: invocationtimeStamp,
                                   methodIdent: invocationmethodIdent,
                                   timerData: nil,
                                   duration: invocationduration,
                                   childCount: childCount,
                                   applicationId: applicationId,
                                   businessTransactionId: businessTransactionId) as! T
        }
    }
    
}
