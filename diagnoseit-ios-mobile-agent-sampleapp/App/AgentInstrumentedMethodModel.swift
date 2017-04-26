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

struct AgentInstrumentedMethodModel : SuperModel {
    let printId: String
    let printName: String
    let id: Int
    let timeStamp: Int
    let packageName: String
    let className: String
    let methodName: String
    let parameters: [String]
    let returnType: String
    let modifiers: Int
    let active: Bool
}


extension AgentInstrumentedMethodModel {
    
    static func from<T>(dict: [String: AnyObject]) -> T where T:SuperModel {
        let id: Int = dict["id"] as! Int;
        let timeStamp: Int = dict["timeStamp"] as! Int;
        let packageName: String = dict["packageName"] as! String;
        let className: String = dict["className"] as! String;
        let methodName: String = dict["methodName"] as! String;
        let parameters: [String] = dict["parameters"] as! [String];
        let returnType: String = dict["returnType"] as! String;
        let modifiers: Int = dict["modifiers"] as! Int;
        let active: Bool = dict["active"] as! Bool;
        let printName: String = methodName
        let printId: String = id.description
        return AgentInstrumentedMethodModel(printId: printId,
                           printName: printName,
                           id: id,
                           timeStamp: timeStamp,
                           packageName: packageName,
                           className: className,
                           methodName: methodName,
                           parameters: parameters,
                           returnType: returnType,
                           modifiers: modifiers,
                           active: active) as! T
    }
}
