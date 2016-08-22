//
//  AppData.swift
//  GraphAPITest
//
//  Created by Paul Wilkinson on 22/08/2016.
//  Copyright © 2016 Paul Wilkinson. All rights reserved.
//

import Foundation
import ADALiOS

class AppData {
    
    static let getInstance = AppData()
    
    var clientId: String?
    var authority: String?
    var resourceId: String?
    var redirectUriString: String?
    var taskWebUrlString: String?
    var apiVersion: String?
    var tenant: String?
    var userItem: ADTokenCacheStoreItem?

    private init() {
        if let plistFile = NSBundle.mainBundle().pathForResource("Settings", ofType: "plist") {
            if let dictionary = NSDictionary(contentsOfFile: plistFile) {
                self.clientId = dictionary["clientId"] as? String
                self.authority = dictionary["authority"] as? String
                self.resourceId = dictionary["resourceString"] as? String
                self.taskWebUrlString = dictionary["graphAPI"] as? String
                self.apiVersion = dictionary["api-version"] as? String
                self.tenant = dictionary["tenant"] as? String
                self.redirectUriString = dictionary["redirectUri"] as? String
             }
        }
    }

}