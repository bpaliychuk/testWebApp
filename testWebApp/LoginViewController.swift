//
//  LoginViewController.swift
//  testWebApp
//
//  Created by Bohdan Paliychuk on 11/22/18.
//  Copyright © 2018 Bohdan Paliychuk. All rights reserved.
//

import UIKit
import ADALiOS


class LoginViewController: UIViewController {
    
    let kClientID = "f3c59e7b-24f1-4608-9628-69b6ffd5e0ca" //iostest
    let kAuthority = "https://login.microsoftonline.com/17d4dcc9-ef32-44ec-b26a-51b8aea000d8"
    let kRedirectURL = "https://iOSTest/some/test/app"

    var context: ADAuthenticationContext!
    var accessToken: String = ""
    
    //    bpaliychuk@pavelma.onmicrosoft.com
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         context = ADAuthenticationContext(authority: kAuthority, error: nil)
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        let resource = "https://fidelitypublic-pavelma.msappproxy.net/"
        
        context.acquireToken(withResource: resource, clientId: kClientID, redirectUri: URL(string: kRedirectURL)!, userId: nil, extraQueryParameters: nil) { (result) in
            self.accessToken = result?.tokenCacheStoreItem.accessToken ?? ""
            print(result?.tokenCacheStoreItem.accessToken)
            if let _ = result?.tokenCacheStoreItem.accessToken {
                self.loadWebView()
            }
        }
        
        
    }
    
    
    func loadWebView() {
        DataProvider.shared.load(baseurl: "https://fidelitypublic-pavelma.msappproxy.net", accessToken: self.accessToken) {
            print("finished")
        }
    }
}
