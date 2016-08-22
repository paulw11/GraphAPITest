//
//  ViewController.swift
//  GraphAPITest
//
//  Created by Paul Wilkinson on 22/08/2016.
//  Copyright © 2016 Paul Wilkinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func loginTapped(sender: AnyObject) {
        GraphAPICaller.getToken(false, silent: false, parent: self) { (token, error) in
            if error != nil {
                print(error)
            } else {
                print(token!)
            }
        }
    }
    @IBAction func logoutTapped(sender: AnyObject) {
        GraphAPICaller.clearToken()
    }

}

