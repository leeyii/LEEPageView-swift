//
//  LEEViewController.swift
//  LEEPageView
//
//  Created by 李杰 on 2017/3/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

import UIKit

class LEEViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        print(view.tag)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("DIS\(view.tag)")
    }
}
