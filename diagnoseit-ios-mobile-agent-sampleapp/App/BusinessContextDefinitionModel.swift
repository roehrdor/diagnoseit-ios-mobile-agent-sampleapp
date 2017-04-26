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

struct BusinessContextDefinitionModel : SuperModel {
    
    let printName:String
    let printId:String
    let id:Int
    let applicationName: String
    let description: String
    let matchingRuleExpression: MatchingRuleExpression
}

struct MatchingRuleExpression  {
    
    let type:String
    let operands:[Operand]
    let value:Bool!
}

struct Operand  {
    
    let type:String
    let matchingType:String
    let snippet:String
    let stringValueSource:StringValueSource
    let searchNodeInTrace:Bool
    let maxSearchDepth:Int
}

struct StringValueSource  {
    
    let className:String
}

extension BusinessContextDefinitionModel {
    
    static func from<T>(dict: [String: AnyObject]) -> T where T:SuperModel {
        
        let matchingRuleExpression : [String:AnyObject] = dict["matchingRuleExpression"] as! [String:AnyObject]
        let id: Int = dict["id"] as! Int
        let applicationName: String = dict["applicationName"] as! String
        var description: String = ""
        if dict["description"] is NSString {
            description = dict["description"] as! String
        }
        let printName : String = String(format: "%@",applicationName)
        let printId : String = String(format: "%i", id)
        
        
        let ruleExpressionType = matchingRuleExpression["@type"] as! String
        var value = false
        var operandList : [Operand] = []
        if ruleExpressionType == "Boolean" {
            value = matchingRuleExpression["value"] as! Bool

        } else {
            let operands : [[String:AnyObject]] = matchingRuleExpression["operands"] as! [[String:AnyObject]]
            for operand in operands {
                
                let type:String = operand["@type"] as! String
                let matchingType:String = operand["@type"] as! String
                let snippet:String = operand["@type"] as! String
                let stringValueSourceDict:[String:AnyObject] = operand["stringValueSource"] as! [String:AnyObject]
                let searchNodeInTrace:Bool = operand["searchNodeInTrace"] as! Bool
                let maxSearchDepth:Int = operand["maxSearchDepth"] as! Int
                
                let stringValueSource = StringValueSource(className: stringValueSourceDict["@class"] as! String)
                
                operandList.append(Operand(type: type,
                                           matchingType: matchingType,
                                           snippet: snippet,
                                           stringValueSource: stringValueSource,
                                           searchNodeInTrace: searchNodeInTrace,
                                           maxSearchDepth: maxSearchDepth))
            }

        }
        
        
        
        
        
        let ruleExpression = MatchingRuleExpression(type: ruleExpressionType, operands: operandList, value: value)
        
        return BusinessContextDefinitionModel(printName: printName,
                            printId: printId,
                            id: id,
                            applicationName: applicationName,
                            description: description,
                            matchingRuleExpression: ruleExpression) as! T
    }
}
