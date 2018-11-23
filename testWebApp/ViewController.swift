//
//  ViewController.swift
//  testWebApp
//
//  Created by Bohdan Paliychuk on 11/20/18.
//  Copyright © 2018 Bohdan Paliychuk. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        loadFiles()
    }

    
    private func loadFiles() {
//        DataProvider.shared.load {
//            self.loadLocalSite()
//        }
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

