//
//  LoginViewController.swift
//  testWebApp
//
//  Created by Bohdan Paliychuk on 11/22/18.
//  Copyright © 2018 Bohdan Paliychuk. All rights reserved.
//

import UIKit
import ADALiOS
import IntuneMAM


class LoginViewController: UIViewController {
    
    let kClientID = "f3c59e7b-24f1-4608-9628-69b6ffd5e0ca" //iostest
    let kAuthority = "https://login.microsoftonline.com/17d4dcc9-ef32-44ec-b26a-51b8aea000d8"
    let kRedirectURL = "https://iOSTest/some/test/app"
    let resource = "https://fidelitypublic-pavelma.msappproxy.net/"

    var context: ADAuthenticationContext!
    var accessToken: String = ""
    
    //    bpaliychuk@pavelma.onmicrosoft.com
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IntuneMAMEnrollmentManager.instance().delegate = self
        IntuneMAMPolicyManager.instance().delegate = self
        
        if let account = IntuneMAMEnrollmentManager.instance().enrolledAccount() {
            print("user is loginned with account \(account)")
        }
        
        context = ADAuthenticationContext(authority: kAuthority, error: nil)
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        context.acquireToken(withResource: resource, clientId: kClientID, redirectUri: URL(string: kRedirectURL)!, userId: nil, extraQueryParameters: nil) { (result) in
            self.accessToken = result?.tokenCacheStoreItem.accessToken ?? ""
            print(result?.tokenCacheStoreItem.accessToken ?? "")
            if let userID = result?.tokenCacheStoreItem.userInformation.userId {
//                self.loadWebView()
                IntuneMAMEnrollmentManager.instance().registerAndEnrollAccount(userID)
            }
        }
    }
    
    
    func loadWebView() {
        DataProvider.shared.load(baseurl: "https://fidelitypublic-pavelma.msappproxy.net", accessToken: self.accessToken) {
            print("download finished")
            WebViewController.show(fromVC: self)
        }
    }
}

extension LoginViewController: IntuneMAMEnrollmentDelegate {
    
    func policyRequest(with status: IntuneMAMEnrollmentStatus) {
        print("policyRequest - \(status.didSucceed)")
        if !status.didSucceed {
            print("policyRequest status error - \(status.errorString ?? "")")
        }
    }
    
    func enrollmentRequest(with status: IntuneMAMEnrollmentStatus) {
        print("enrollmentRequest - \(status.didSucceed)")
        if !status.didSucceed {
            print("enrollmentRequest status error - \(status.errorString ?? "")")
        }
    }
    
    func unenrollRequest(with status: IntuneMAMEnrollmentStatus) {
        print("unenrollRequest - \(status.didSucceed)")
        if !status.didSucceed {
            print("unenrollRequest status error - \(status.errorString ?? "")")
        }
    }
}


extension LoginViewController: IntuneMAMPolicyDelegate {
    
    func restartApplication() -> Bool {
        return false
    }
}
