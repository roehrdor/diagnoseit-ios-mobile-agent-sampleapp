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

struct AgentStatusModel : SuperModel {
    let printId: String
    let printName: String
    let agentConnection: String
    let lastKeepAliveTimestamp: Int
    let connectionTimestamp: Int
    let millisSinceLastData: Int
    let instrumentationStatus : String
    let lastInstrumentationUpate : Int
    
}

extension AgentStatusModel {
    
    static func from<T: SuperModel>(dict: [String: AnyObject]) -> T {
        let agentId: String = dict["customPrintId"] as! String
        let name: String = dict["customName"] as! String
        let agentConnection: String = dict["agentConnection"] as! String
        let lastKeepAliveTimestamp: Int = dict["lastKeepAliveTimestamp"] as! Int;
        let connectionTimestamp: Int = dict["connectionTimestamp"] as! Int;
        let millisSinceLastData: Int
        if (dict["millisSinceLastData"] as? Int) == nil {
            millisSinceLastData = -1
        } else {
            millisSinceLastData = dict["millisSinceLastData"] as! Int
        }
        let instrumentationStatus: String = dict["instrumentationStatus"] as! String
        let lastInstrumentationUpate: Int = dict["lastInstrumentationUpate"] as! Int;
        return AgentStatusModel(printId: agentId,
                           printName: name,
                           agentConnection: agentConnection,
                          lastKeepAliveTimestamp: lastKeepAliveTimestamp,
                          connectionTimestamp: connectionTimestamp,
                          millisSinceLastData: millisSinceLastData,
                          instrumentationStatus: instrumentationStatus,
                          lastInstrumentationUpate: lastInstrumentationUpate) as! T
    }
}
