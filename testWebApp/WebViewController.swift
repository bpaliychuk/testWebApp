//
//  ViewController.swift
//  testWebApp
//
//  Created by Bohdan Paliychuk on 11/20/18.
//  Copyright © 2018 Bohdan Paliychuk. All rights reserved.
//

import UIKit
import WebKit
import Swifter

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    private var webServer: CustomWebServer?
    
    
    static func show(fromVC: UIViewController) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController
        fromVC.present(vc!, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        loadFiles()
        //loadLocalWebServer()
        //loadLocalSite()
    }

    
    private func loadFiles() {


//        DataProvider.shared.load {
            //self.loadLocalSite()
//            self.loadLocalWebServer()
//        }
        self.loadLocalWebServer()
    }
    
    private func loadLocalWebServer() {
        
        let libraryPathString = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        
        let basePathString = libraryPathString + "/Site";
        
        webServer = CustomWebServer(publicDir: basePathString, secretKey: "qwerty123" )
        webServer?.start(9080)
        
        let cookie = HTTPCookie(properties: [
            .domain: "localhost",
            .path: "/",
            .name: "localWebServerKey",
            .value: "qwerty123",
            ])!
        
        let cookieDummy = HTTPCookie(properties: [
            .domain: "localhost",
            .path: "/",
            .name: "asdfr",
            .value: "dfgdfg",
            ])!
        
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookieDummy)
        webView.load(URLRequest(url: URL(string: "http://localhost:9080")!))
        
        
    }
    
    private func loadLocalSite() {
        let libraryURLString = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last?.path
        let indexURLString = libraryURLString! + "/Site/index.html"
        let url = URL(fileURLWithPath: indexURLString)
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

