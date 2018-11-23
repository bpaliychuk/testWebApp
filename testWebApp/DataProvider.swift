//
//  DataProvider.swift
//  testWebApp
//
//  Created by Bohdan Paliychuk on 11/20/18.
//  Copyright © 2018 Bohdan Paliychuk. All rights reserved.
//

import Foundation

class DataProvider {
    
    static let shared = DataProvider()
    
    private let filesArr = [
        "/index.html",
        "/script.js",
        "/styles.css",
        "/document.patterns",
        "/jquery.min.js",
        "/manifest.appcache",
        "/jquery.scrollTo-1.4.2/changes.txt",
        "/jquery.scrollTo-1.4.2/jquery.scrollTo-min.js",
        "/jquery.scrollTo-1.4.2/jquery.scrollTo.js",
        "/documents/documentViewer1.mp4",
        "/documents/exampleDocm.docm",
        "/documents/exempleDocx.docx",
        "/documents/exempleExel.xlsx",
        "/documents/exemplePdf.pdf",
        "/documents/exemplePptx.pptx",
        "/documents/tests-example.xls",
        "/img/test_logo.png"
    ]
    private let indexFileName = "index.html"
    
    func load(baseurl: String, accessToken: String? = nil, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        for urlString in filesArr {
            let url = URL(string: baseurl + urlString)!
            var request = URLRequest(url: url)
            if let token = accessToken {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            group.enter()
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                group.leave()
                if let response = response {
                    print(response.url)
                    self.saveWithData(baseurl: baseurl, data: data!, url: response.url!)
                }
            }.resume()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            print("Download task finished")
            completion()
        }
    }
    
    func saveWithData(baseurl: String, data: Data, url: URL) {
        let fileManager = FileManager.default
        let libraryURLString = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).last?.path
        
        let mainFolder = libraryURLString! + "/Site/"
        let urlWithOutFileName = url.deletingLastPathComponent()
        let newLocalUrl = urlWithOutFileName.absoluteString.replacingOccurrences(of: baseurl, with: mainFolder)
        
        if newLocalUrl != mainFolder {
            var isDir : ObjCBool = true
            if !fileManager.fileExists(atPath: newLocalUrl, isDirectory: &isDir) {
                try? fileManager.createDirectory(atPath: newLocalUrl, withIntermediateDirectories: true, attributes: nil)
            }
        }
        let fullLocalPath = newLocalUrl + url.lastPathComponent
        fileManager.createFile(atPath: fullLocalPath, contents: data, attributes: nil)
    }
}
