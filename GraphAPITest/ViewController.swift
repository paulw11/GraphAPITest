//
//  ViewController.swift
//  GraphAPITest
//
//  Created by Paul Wilkinson on 22/08/2016.
//  Copyright © 2016 Paul Wilkinson. All rights reserved.
//

import UIKit
import p2_OAuth2

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var oauth2: OAuth2ClientCredentials!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupOAuth2AccountStore()
        
        self.requestOAuthAccess()
        
        let urlCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        
        NSURLCache.setSharedURLCache(urlCache)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func requestOAuthAccess() {
        
     self.oauth2.doAuthorize()
        
    }
    
    func setupOAuth2AccountStore() {
        let appData = AppData.getInstance
        
        let settings = [
            "client_id": appData.clientId!,
            "client_secret": appData.secret!,
            "authorize_uri": appData.authString!,
            "token_uri": appData.tokenString!,   // code grant only
            "redirect_uris": [appData.redirectUriString!],   // register the "myapp" scheme in Info.plist
            "keychain": true,     // if you DON'T want keychain integration
            "secret_in_body": true
            ] as OAuth2JSON
        
        self.oauth2 = OAuth2ClientCredentials(settings: settings)
        
        self.oauth2.onAuthorize = { parameters in
            print("Did authorize with parameters: \(parameters)")
            if let _ = parameters["access_token"] as? String {
                self.getUsers(nil)
            }
        }
        self.oauth2.onFailure = { error in        // `error` is nil on cancel
            if let error = error {
                print("Authorization went wrong: \(error)")
            }
        }
    }
    
    func getUsers(searchString: String?) {
        
        let appData = AppData.getInstance
        
        var filterString = ""
        
        if searchString != nil {
            filterString = String(format:"&$filter=startswith(displayName,'%@')",searchString!)
        }
        
        let urlString = String(format: "%@%@/users?api-version=%@%@", appData.graphAPI,appData.tenant,appData.apiVersion,filterString).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let req = self.oauth2.request(forURL: NSURL(string:urlString!)!)
        // set up your request, e.g. `req.HTTPMethod = "POST"`
        let task = oauth2.session.dataTaskWithRequest(req) { data, response, error in
            if let error = error {
                // something went wrong, check the error
                print(error)
            }
            else {
                // check the response and the data
                // you have just received data with an OAuth2-signed request!
                do {
                    
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject] {
                        var newUsers = [User]()
                        if let usersArray = json["value"] as? [[String:AnyObject]] {
                            newUsers = usersArray.map(  {
                                User(displayName: $0["displayName"] as! String, userName: $0["userPrincipalName"] as! String)
                            })
                            dispatch_async(dispatch_get_main_queue(), {
                                self.users = newUsers
                                self.tableView.reloadData()
                            })
                        }
                        
                    }
                
                } catch {
                    print("Invalid JSON")
                }
            }
        }
        task.resume()
        
       }
   
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    @objc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let user = self.users[indexPath.row]
        
        cell.textLabel!.text = user.displayName
        cell.detailTextLabel!.text = user.userName
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.getUsers(searchText)
    }
}
