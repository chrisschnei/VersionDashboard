//
//  XMLParser.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

protocol XMLParserDelegate {
    func XMLParserError(parser: XMLParser, error:String);
}

class XMLParser : NSObject, NSXMLParserDelegate {
    let url: NSURL;
    var delegate: XMLParserDelegate?
    
    var object = Dictionary<String, String>()
    
    var inItem = false
    var current = String()
    
    var handler: (() -> Void)?
    
    func parse(handler:() -> Void) -> String {
        self.handler = handler
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            let xmlCode = NSData(contentsOfURL: self.url);
//            let string = NSString(data: xmlCode!, encoding: NSUTF8StringEncoding);
            let parser = NSXMLParser(data: xmlCode!);
            parser.delegate = self
            if !parser.parse() {
                self.delegate?.XMLParserError(self, error: "Parsing failed?")
            };
        }
        if(self.object["version"] != nil) {
            return self.object["version"]!
        } else if(self.object["result"] != nil) {
            return self.object["result"]!
        } else {
            return "test"
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if(elementName == "version") {
            object.removeAll(keepCapacity: false)
            inItem = true
        } else if(elementName == "result") {
            object.removeAll(keepCapacity: false)
            inItem = true
        }
        current = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if !inItem {
            return
        }
        if let temp = object[current] {
            var tempString = temp
            tempString += string
            object[current] = tempString
        } else {
            object[current] = string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if((elementName == "version") || (elementName == "result")) {
            inItem = false
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        dispatch_async(dispatch_get_main_queue()) {
            if (self.handler != nil) {
                self.handler!()
            }
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        delegate?.XMLParserError(self, error: parseError.localizedDescription)
    }
    
    init(url:NSURL) {
        self.url = url;
    }
}
