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
        "http://bpaliychukwebsitetest.xp3.biz/index.html",
        "http://bpaliychukwebsitetest.xp3.biz/script.js",
        "http://bpaliychukwebsitetest.xp3.biz/styles.css",
        "http://bpaliychukwebsitetest.xp3.biz/document.patterns",
        "http://bpaliychukwebsitetest.xp3.biz/jquery.min.js",
        "http://bpaliychukwebsitetest.xp3.biz/manifest.appcache",
        "http://bpaliychukwebsitetest.xp3.biz/jquery.scrollTo-1.4.2/changes.txt",
        "http://bpaliychukwebsitetest.xp3.biz/jquery.scrollTo-1.4.2/jquery.scrollTo-min.js",
        "http://bpaliychukwebsitetest.xp3.biz/jquery.scrollTo-1.4.2/jquery.scrollTo.js",
        "http://bpaliychukwebsitetest.xp3.biz/documents/documentViewer1.mp4",
        "http://bpaliychukwebsitetest.xp3.biz/documents/exampleDocm.docm",
        "http://bpaliychukwebsitetest.xp3.biz/documents/exempleDocx.docx",
        "http://bpaliychukwebsitetest.xp3.biz/documents/exempleExel.xlsx",
        "http://bpaliychukwebsitetest.xp3.biz/documents/exemplePdf.pdf",
        "http://bpaliychukwebsitetest.xp3.biz/documents/exemplePptx.pptx",
        "http://bpaliychukwebsitetest.xp3.biz/documents/tests-example.xls"
    ]
    
    func load() {
        
        let group = DispatchGroup()
        
        for urlString in filesArr {
            let url = URL(string: urlString)!
            group.enter()
            let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
                if let localURL = localURL {
                    print(localURL)
                    self.saveDownloadedFile(localUrl: localURL.path, absoluteUrl: urlResponse!.url!)
                    group.leave()
                }
            }
            task.resume()
        }
        
        
        group.notify(queue: DispatchQueue.main) {
            print("Download task finished")
        }
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
}
