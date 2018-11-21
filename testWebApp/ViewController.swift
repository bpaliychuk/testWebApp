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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        loadFiles()
    }

    
    private func loadFiles() {
        DataProvider.shared.load {
            self.loadLocalSite()
            //self.loadLocalWebServer()
        }
    }
    
    private func loadLocalWebServer() {
        do {
            let server = demoServer(Bundle.main.resourcePath!)
            try server.start(9080)
            //self.server = server
        } catch {
            print("Server start error: \(error)")
        }
        
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

