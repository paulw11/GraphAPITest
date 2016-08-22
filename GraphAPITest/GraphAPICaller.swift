//
//  GraphAPICaller.swift
//  GraphAPITest
//
//  Created by Paul Wilkinson on 22/08/2016.
//  Copyright © 2016 Paul Wilkinson. All rights reserved.
//

import Foundation
import ADALiOS


class GraphAPICaller {
    
    class func getToken(clearCache: Bool, silent: Bool, parent: UIViewController, completionHandler:((NSString?, NSError?)->Void)) {
        
        if (clearCache) {
            clearToken()
        }
        
        let appData = AppData.getInstance
        
        if let userItem = appData.userItem {
            completionHandler(userItem.accessToken,nil)
        }
        
        guard let authority = appData.authority,
            uriString = appData.redirectUriString,
            resource = appData.resourceId,
            clientId = appData.clientId
        else {
            completionHandler(nil,NSError(domain: "GraphAPICaller", code: -1, userInfo: nil))
            return
        }
        
        var error: ADAuthenticationError?
        
        let authContext = ADAuthenticationContext(authority: authority, error: &error)
        guard error == nil else {
            completionHandler(nil,error)
            return
        }
        
        authContext.parentController = parent
        
        let userid = appData.userItem?.userInformation.userId
        
        let redirectUri = NSURL(string: uriString)
        
        if (silent) {
            authContext.acquireTokenSilentWithResource(resource, clientId: clientId, redirectUri: redirectUri, userId: userid, completionBlock: { (result) in
                if result.status != AD_SUCCEEDED {
                    completionHandler(nil,result.error)
                } else {
                    appData.userItem = result.tokenCacheStoreItem
                    completionHandler(result.tokenCacheStoreItem.accessToken,nil)
                }
            })
        
        } else {
            
            ADAuthenticationSettings.sharedInstance().enableFullScreen = true
            authContext.acquireTokenWithResource(resource, clientId: clientId, redirectUri: redirectUri, promptBehavior: AD_PROMPT_AUTO, userId:userid, extraQueryParameters: "") { (result) in
                if result.status != AD_SUCCEEDED {
                    completionHandler(nil,result.error)
                } else {
                    appData.userItem = result.tokenCacheStoreItem
                    print(result)
                    completionHandler(result.tokenCacheStoreItem.accessToken,nil)
                }
            }
        }
        
    }
    
    class func clearToken() {
        
        ADAuthenticationSettings.sharedInstance().defaultTokenCacheStore.removeAllWithError(nil)
        
        
    }
}
