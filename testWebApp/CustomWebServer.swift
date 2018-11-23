//
//  CustomWebServer.swift
//  testWebApp
//
//  Created by Maksym Kondakov on 11/22/18.
//  Copyright © 2018 Bohdan Paliychuk. All rights reserved.
//

import Foundation
import Swifter

public class CustomWebServer {
    
    private var server: HttpServer!
    private var secretKey: String
    
    private var publicDir: String
    
    public init(publicDir: String, secretKey:String) {
        
        server = HttpServer()
        self.publicDir = publicDir
        self.secretKey = secretKey
        
        server.GET["/:path"] = { r in
            var filePath = r.path == "/" ? "/index.html" : r.path;
            filePath = publicDir + filePath
            let fileURL = URL(fileURLWithPath: filePath)
            
            guard let cookies = r.headers["cookie"] else {
                return HttpResponse.notFound
            }

            if cookies.range(of:"localWebServerKey="+secretKey) == nil {
                return HttpResponse.notFound
            }
            //var body = "";
            var data: Data!
            
            
            
            //reading
            do {
                do {
                    data = try Data(contentsOf: fileURL)
                } catch {
                    return HttpResponse.notFound
                }
                //body = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {/* error handling here */}
            
            return HttpResponse.ok(.data(data))
        }
    }
    
    public func start(_ port: in_port_t = 8080) {
        do {
            try server.start(port)
        } catch {
            print("Server start error: \(error)")
        }
    }
    
    public func stop() {
        server.stop()
    }
}

