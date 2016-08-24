//
//  AppData.swift
//  GraphAPITest
//
//  Created by Paul Wilkinson on 22/08/2016.
//  Copyright © 2016 Paul Wilkinson. All rights reserved.
//

import Foundation

class AppData {
    
    static let getInstance = AppData()
    
    var clientId: String!
    var authURL: NSURL?
    var authString: String?
    var tokenurl: NSURL?
    var tokenString: String?
    var resourceId: String?
    var secret: String!
    var redirectUriString: String?
    var redirectUri: NSURL?
    var taskWebUrlString: String?
    var apiVersion: String!
    var tenant: String!
    var graphAPI: String!

    private init() {
        if let plistFile = NSBundle.mainBundle().pathForResource("Settings", ofType: "plist") {
            if let dictionary = NSDictionary(contentsOfFile: plistFile) {
                self.clientId = dictionary["clientId"] as! String
                if let authString = dictionary["authority"] as? String {
                    self.authString = authString
                    self.authURL = NSURL(string:authString)
                }
                
                if let tokenString = dictionary["tokenurl"] as? String {
                    self.tokenString = tokenString
                    self.tokenurl = NSURL(string: tokenString)
                }
                
                
                self.resourceId = dictionary["resourceString"] as? String
                self.taskWebUrlString = dictionary["graphAPI"] as? String
                self.apiVersion = dictionary["api-version"] as! String
                self.tenant = dictionary["tenant"] as! String
                self.redirectUriString = dictionary["redirectUri"] as? String
                if self.redirectUriString != nil {
                    self.redirectUri = NSURL(string: self.redirectUriString!)
                }
                self.secret = dictionary["secret"] as! String
                self.graphAPI = dictionary["graphAPI"] as! String
             }
        }
    }

}