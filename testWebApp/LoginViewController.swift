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
    
//    let kClientID = "60bddaf7-d727-449b-883e-b49d86de61a1"
    let kClientID = "f3c59e7b-24f1-4608-9628-69b6ffd5e0ca" //iostest
    let kAuthority = "https://login.microsoftonline.com/17d4dcc9-ef32-44ec-b26a-51b8aea000d8"
//    let kGraphURI = "https://graph.microsoft.com/v1.0/me/"
//    let kScopes: [String] = ["https://graph.microsoft.com/user.read"]
//    let kRedirectURL = "https://fidelitypublic-pavelma.msappproxy.net"
//    let kRedirectURL = "https://login.microsoftonline.com/common/oauth2/nativeclient"
//    let kRedirectURL = "https://CoreValue.testWebApp"
    let kRedirectURL = "https://iOSTest/some/test/app"
//    bpaliychuk@pavelma.onmicrosoft.com
    var context: ADAuthenticationContext!
    var accessToken: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         context = ADAuthenticationContext(authority: kAuthority, error: nil)
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
//        let resource = "https://graph.microsoft.com"
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
//        let url = URL(string: "https://graph.microsoft.com/v1.0/deviceAppManagement/mobileapps/")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        URLSession.shared.downloadTask(with: request) { (localUrl, response, error) in
//            if let localUrl = localUrl {
//                let str = try? String(contentsOf: localUrl)
//                print(str)
//            }
//            print(localUrl)
//        }.resume()

        DataProvider.shared.load(baseurl: "https://fidelitypublic-pavelma.msappproxy.net", accessToken: self.accessToken) {
            print("finished")
        }
//         URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
//                return
//            }
//            print(result)
//          }.resume()
    }
}
