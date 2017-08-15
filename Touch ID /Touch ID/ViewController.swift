//
//  ViewController.swift
//  Touch ID
//
//  Created by pkss on 2017/5/24.
//  Copyright © 2017年 J. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        IQNetAPIClient.requestJson(method: .get,parameters: ["c":"tv","a":"channel"], succeed: { (obj:[String : Any]) in
            print(obj)
        }) { (error:NSError) in
            print(error)
        }
        
    }
}

