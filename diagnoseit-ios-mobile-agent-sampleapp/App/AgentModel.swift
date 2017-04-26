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

struct AgentModel : SuperModel {
    
    let printName:String
    let printId:String
    let name: String
    let id: Int
    let timeStamp: Int
    let version: String
    let definedIPs: Array< String >
}

extension AgentModel {
    
   
    static func from<T>(dict: [String: AnyObject]) -> T where T:SuperModel {
        let name: String = dict["agentName"] as! String;
        let id: Int = dict["id"] as! Int;
        let timeStamp: Int = dict["timeStamp"] as! Int;
        let version: String = dict["version"] as! String;
        let definedIPs: Array< String > = dict["definedIPs"] as! Array < String >
        let printName : String = String(format: "%@",name)
        let printId : String = String(format: "%i", id)
        return AgentModel(printName:printName,
                          printId : printId,
                          name: name,
                          id: id,
                          timeStamp: timeStamp,
                          version: version,
                          definedIPs: definedIPs) as! T
    }
}
