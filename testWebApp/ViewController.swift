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

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    private var webServer: CustomWebServer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        //loadFiles()
        loadLocalWebServer()
        //loadLocalSite()
    }

    
    private func loadFiles() {
        DataProvider.shared.load {
            //self.loadLocalSite()
            self.loadLocalWebServer()
        }
    }
    
    private func loadLocalWebServer() {
        
        let libraryPathString = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        
        let basePathString = libraryPathString + "/Site";
        
        webServer = CustomWebServer(basePathString)
        webServer?.start(9080)
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

