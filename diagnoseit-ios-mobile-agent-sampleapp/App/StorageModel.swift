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

struct StorageModel : SuperModel{
    
    let printName: String
    let printId: String
    let id: String
    let name: String
    let diskSize: Int
    let description: String
    let cmrVersion: String
    let labelList: [LabelListItem]
    let state: String
    let storageClosed: Bool
    let storageOpened: Bool
    let storageRecording: Bool
    let storageFolder: String
}

struct LabelListItem {
    
    let id: Int
    let storageLabelType: StorageLabelType
    let dateValue: Int
    let formatedValue: String
    let value: Int
}

struct StorageLabelType {
    
    let id: Int
    let valueResuable: Bool
    let multiType: Bool
    let onePerStorage: Bool
    let valueClass: String
    let editable: Bool
    let groupingEnabled: Bool
}

extension StorageModel {
    
    static func from<T>(dict: [String: AnyObject]) -> T where T:SuperModel {
        // Get the LabelList out of the dictionary
        let labelLists : [[String:AnyObject]] = dict["labelList"] as! [[String:AnyObject]]
        var labelList : [LabelListItem] = []
        for labelItem in labelLists {
            // Get the StorageLabel out of the list item casting it into dictionary
            let storageLabel : [String:AnyObject] = labelItem["storageLabelType"] as! [String:AnyObject]
            let id: Int = storageLabel["id"] as! Int;
            let valueResuable: Bool = storageLabel["valueReusable"] as! Bool;
            let multiType: Bool = storageLabel["multiType"] as! Bool;
            let onePerStorage: Bool = storageLabel["onePerStorage"] as! Bool;
            let valueClass: String = storageLabel["valueClass"] as! String;
            let editable: Bool = storageLabel["editable"] as! Bool;
            let groupingEnabled: Bool = storageLabel["groupingEnabled"] as! Bool;
            let storageLabelType = StorageLabelType(id: id,
                                                    valueResuable: valueResuable,
                                                    multiType: multiType,
                                                    onePerStorage: onePerStorage,
                                                    valueClass: valueClass,
                                                    editable: editable,
                                                    groupingEnabled: groupingEnabled)
            // extract the rest of the label item data
            let labelId: Int = labelItem["id"] as! Int;
            let dateValue: Int
            if (labelItem["dateValue"] as? Int) == nil {
                dateValue = -1
            } else {
                dateValue = labelItem["dateValue"] as! Int
            }
            let formatedValue: String = labelItem["formatedValue"] as! String;
            let value: Int
            if (labelItem["value"] as? Int) == nil {
                value = -1
            } else {
                value = labelItem["value"] as! Int
            }
            let labelListItem : LabelListItem = LabelListItem(id: labelId,
                                                              storageLabelType: storageLabelType,
                                                              dateValue: dateValue,
                                                              formatedValue: formatedValue,
                                                              value: value)
            labelList.append(labelListItem)
        }
        
        // extract the rest of the storage Data item
        let storageId: String = dict["id"] as! String;
        let name: String = dict["name"] as! String;
        let diskSize: Int = dict["diskSize"] as! Int;
        let description : String
        if (dict["description"] as? String) == nil {
            description = String()
        } else {
            description = dict["description"] as! String
        }
        let cmrVersion: String = dict["cmrVersion"] as! String;
        let state: String = dict["state"] as! String;
        let storageClosed: Bool = dict["storageClosed"] as! Bool;
        let storageOpened: Bool = dict["storageOpened"] as! Bool;
        let storageRecording: Bool = dict["storageRecording"] as! Bool;
        let storageFolder: String = dict["storageFolder"] as! String;
        return StorageModel(printName: name,
                            printId: storageId,
                            id: storageId,
                            name: name,
                            diskSize: diskSize,
                            description: description,
                            cmrVersion: cmrVersion,
                            labelList: labelList,
                            state: state,
                            storageClosed: storageClosed,
                            storageOpened: storageOpened,
                            storageRecording: storageRecording,
                            storageFolder: storageFolder) as! T
    }
    
}

