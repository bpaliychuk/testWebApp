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
    private var publicDir: String
    
    public init(_ publicDir: String) {
        server = HttpServer()
        self.publicDir = publicDir
        
        server.GET["/:path"] = { r in
            var filePath = r.path == "/" ? "/index.html" : r.path;
            filePath = publicDir + filePath;
            var body = "";
            var data: Data!
            
            //reading
            do {
                do {
                    data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                } catch {
                    return HttpResponse.notFound
                }
                body = try String(contentsOf: URL(fileURLWithPath: filePath), encoding: .utf8)
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

