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
    
    private let baseURL = "http://bpaliychukwebsitetest.xp3.biz"
    
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
//        "/documents/documentViewer1.mp4",
//        "/documents/exampleDocm.docm",
//        "/documents/exempleDocx.docx",
//        "/documents/exempleExel.xlsx",
//        "/documents/exemplePdf.pdf",
//        "/documents/exemplePptx.pptx",
//        "/documents/tests-example.xls",
//        "/img/test_logo.png",
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
            
//            URLSession.shared.downloadTask(with: request) { (localUrl, response, error) in
//                if let localUrl = localUrl {
//                    self.saveDownloadedFile(localUrl: localUrl.path, absoluteUrl: response!.url!)
//                }
//                print(localUrl)
//            }.resume()

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                group.leave()
                if let response = response {
                    print(response.url)
                    self.saveWithData(data: data!, url: response.url!)
                }
            }.resume()
            
//            let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
//                if let localURL = localURL {
//                    self.saveDownloadedFile(localUrl: localURL.path, absoluteUrl: urlResponse!.url!)
//                    group.leave()
//                }
//            }
//            task.resume()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            print("Download task finished")
            completion()
        }
    }
    
    func saveWithData(data: Data, url: URL) {
        let fileManager = FileManager.default
        let libraryURLString = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).last?.path
        
        let mainFolder = libraryURLString! + "/Site/"
        let localURL = mainFolder + url.lastPathComponent
        
//        if mainFolder != mainFolder {
            var isDir : ObjCBool = true
            if !fileManager.fileExists(atPath: mainFolder, isDirectory: &isDir) {
                try? fileManager.createDirectory(atPath: mainFolder, withIntermediateDirectories: true, attributes: nil)
            }
//        }
        fileManager.createFile(atPath: localURL, contents: data, attributes: nil)
        
    }
    
    
    private func saveDownloadedFile(localUrl: String, absoluteUrl: URL) {
        let fileManager = FileManager.default
        let libraryURLString = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).last?.path
        
        let mainFolder = libraryURLString! + "/Site/"
        let urlWithOutFileName = absoluteUrl.deletingLastPathComponent()
        let newLocalUrl = urlWithOutFileName.absoluteString.replacingOccurrences(of: baseURL, with: mainFolder)
        
        if newLocalUrl != mainFolder {
            var isDir : ObjCBool = true
            if !fileManager.fileExists(atPath: newLocalUrl, isDirectory: &isDir) {
                try? fileManager.createDirectory(atPath: newLocalUrl, withIntermediateDirectories: true, attributes: nil)
            }
        }
        
        let fullLocalPath = newLocalUrl + absoluteUrl.lastPathComponent
        let fileData = fileManager.contents(atPath: localUrl)
        fileManager.createFile(atPath: fullLocalPath, contents: fileData, attributes: nil)
        try? fileManager.removeItem(atPath: localUrl)
    }
    
    
    private func replaceLinksInIndexFile(localUrl: String) {
        guard let beforeReplaceString = try? String(contentsOfFile: localUrl) else {
            return
        }
        let fileManager = FileManager.default
        let libraryURLString = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).last?.path
        
        let mainFolder = libraryURLString! + "/Site/"
        var isDir : ObjCBool = true
        if !fileManager.fileExists(atPath: mainFolder, isDirectory: &isDir) {
            try? fileManager.createDirectory(atPath: mainFolder, withIntermediateDirectories: true, attributes: nil)
        }
        let replacedString = beforeReplaceString.replacingOccurrences(of: baseURL, with: mainFolder)
        
        let data = replacedString.data(using: .utf8)
        let fullLocalPath = mainFolder + indexFileName
        fileManager.createFile(atPath: fullLocalPath, contents: data, attributes: nil)
        try? fileManager.removeItem(atPath: localUrl)
    }
}
