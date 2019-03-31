//
//  XMLParser.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

protocol XMLParserDelegate {
    func XMLParserError(_ parser: XMLParser, error:String);
}

open class MyXMLParser : NSObject, Foundation.XMLParserDelegate {
    var url: URL;
    var delegate: XMLParserDelegate?
    
    var object = Dictionary<String, String>()
    
    var inItem = false
    var current = String()
    
    var handler: (() -> Void)?
    
    func parse(_ handler:@escaping () -> Void) -> String {
        self.handler = handler
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).sync{
        let parser = XMLParser(contentsOf: self.url);
            parser?.delegate = self
            if !(parser?.parse())! {
                self.delegate?.XMLParserError(parser!, error: "Parsing failed")
            };
        }
        if(self.object["version"] != nil) {
            return self.object["version"]!
        } else if(self.object["result"] != nil) {
            return self.object["result"]!
        } else {
            return ""
        }
    }
    
    internal func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        inItem=true
        if(elementName == "version") {
            object.removeAll(keepingCapacity: false)
            inItem = true
        } else if(elementName == "result") {
            object.removeAll(keepingCapacity: false)
            inItem = true
        }
        current = elementName
    }
    
    internal func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !inItem {
            return
        }
        if let temp = object[current] {
            var tempString = temp
            tempString += string
            self.object[current] = tempString
        } else {
            self.object[current] = string
        }
    }
    
    internal func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if((elementName == "version") || (elementName == "result")) {
            inItem = false
        }
    }
    
    internal func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            if (self.handler != nil) {
                self.handler!()
            }
        }
    }
    
    internal func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        delegate?.XMLParserError(parser, error: parseError.localizedDescription)
    }
    
    init(url:URL) {
        self.url = url;
    }
}
