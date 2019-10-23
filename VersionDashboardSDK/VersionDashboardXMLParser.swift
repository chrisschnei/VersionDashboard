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

class VersionDashboardXMLParser : NSObject, Foundation.XMLParserDelegate {
    
    /**
     Version to XML Document
     */
    var url: URL?
    
    /**
     XML parsing objects declaration.
     */
    var delegate: XMLParserDelegate?
    let parser = XMLParser()
    
    /**
     Indicates whether a XML element should be processed (is part of searchKeys array).
     */
    var processXMLElement = false
    
    /**
     Contains the possible extractable XML elements.
     */
    let searchKeys = ["version", "result"]
    
    /**
     Contains extracted version.
     */
    var version = String()
    
    /**
     Initializes the newly created XML parser object.
     
     - Parameters:
     - url: URL of XML document.
     */
    init(url: URL) {
        super.init()
        self.url = url
        parser.delegate = self
    }

    /**
     Starts the event-driven parsing operation.
     
     - Returns: true if parsing is successful and false in there is an error or if the parsing operation is aborted.
    */
    func startParsing() -> Bool {
        let data = NSData(contentsOf: self.url!)
        let parser = XMLParser(data: data! as Data);
        parser.delegate = self

        if (!parser.parse()) {
            print ("XML parser parse() function returned false.")
            return false
        }
        
        if (!self.version.isEmpty) {
            return true
        }
        
        return false
    }
    
    /**
     Sent by a parser object when it encounters a start tag for a given element.
     
     - Parameters:
     parser: A parser object.
     elementName: A string that is the name of an element (in its start tag).
     namespaceURI: If namespace processing is turned on, contains the URI for the current namespace as a string object.
     qualifiedName: If namespace processing is turned on, contains the qualified name for the current namespace as a string object.
     attributeDict: A dictionary that contains any attributes associated with the element. Keys are the names of attributes, and values are attribute values.
     */
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?,
                         attributes attributeDict: [String : String]) {
        if(!searchKeys.contains(elementName)) {
            print("Element \(elementName) is not in \(searchKeys)")
            return
        }

        processXMLElement = true
    }
    
    /**
     Sent by a parser object to provide a string representing all or part of the characters of the current element.
     
     - Parameters:
     parser: A parser object.
     string: A string representing the complete or partial textual content of the current element.
     */
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (!processXMLElement) {
            print("Skip element \(string)")
            return
        }
        
        self.version = string
    }
    
    /**
     Sent by a parser object when it encounters an end tag for a specific element.
     
     - Parameters:
     parser: A parser object.
     elementName: A string that is the name of an element (in its end tag).
     namespaceURI: If namespace processing is turned on, contains the URI for the current namespace as a string object.
     qName: If namespace processing is turned on, contains the qualified name for the current namespace as a string object.
     */
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (processXMLElement) {
            processXMLElement = false
        }
    }
    
    /**
     Sent by a parser object when it encounters a fatal error.
     
     - Parameters:
     parser
     A parser object.
     - parseError
     An NSError object describing the parsing error that occurred.
     */
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        delegate?.XMLParserError(parser, error: parseError.localizedDescription)
    }
    
}
