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

protocol SuperModel {
    var printId : String {get}
    var printName:String {get}
    
    
    /**
     Get the corresponding Model content from a dictionary
     This function has to be implemented separately in each Struct extending this protocol
     - parameters:
        - dict: The dictionary to extract the data from
     
     - returns:
     a created model cast to T (SuperModel)
     */
    static func from<T: SuperModel>(dict: [String: AnyObject]) -> T;
}

extension SuperModel {
    
    /**
     Get a list of a specific Model (T) from a json String
     - parameters:
        - json: The dictionary to extract the data from
        - id: A custom printId to be set (empty if non needed)
        - name: A custom name to be set (empty if non needed)
     
     - returns:
     a List of Models of the inferred Type T
     */
    static func loadFromJson<T: SuperModel>(json: String, id : String = "", name : String = "") throws -> [T] {
        // Initialize the array
        var models: [T] = []
        // Try to transform the JSON String into an Array
        if let array = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options:[]) as? [[String:AnyObject]] {
            for element in array {
                var dict : [String : AnyObject] = element
                // Add the created Object into the array
                models.append(extractModelData(dict: &dict, id: id, name: name))
            }
        // Otherwise transform it into a dictionary
        } else {
            do {
                var dict = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!, options:[]) as! [String:AnyObject]
                // Add the created Object into the array
                models.append(extractModelData(dict: &dict, id: id, name: name))
            } catch {
                print("Invalid dict.")
            }
        }
        return models
    }
    
    /**
     Before extracting the Model Data from the dictionary add a custom Print Id and Name
     to it if any were passed
     - parameters:
        - dict: The dictionary to add the custom data and extract other data from
        - id: A custom printId to be set (empty if non needed)
        - name: A custom name to be set (empty if non needed)
     
     - returns:
     a created Model of the inferred type T which constains the passed non empty strings
     */
    static func extractModelData<T: SuperModel> (dict: inout [String:AnyObject], id : String = "", name : String = "") -> T {
        if !id.isEmpty {
            dict["customPrintId"] = id as String as AnyObject?
        }
        if !name.isEmpty {
            dict["customName"] = name as String as AnyObject?
        }
        // Extract the expected Data from the Array Element casting it into a dictionary
        return from(dict: dict as [String : AnyObject])
    }
}


