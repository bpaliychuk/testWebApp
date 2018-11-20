//
//  ViewController.swift
//  testWebApp
//
//  Created by Bohdan Paliychuk on 11/20/18.
//  Copyright © 2018 Bohdan Paliychuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataProvider.shared.load()
    }

    

}

