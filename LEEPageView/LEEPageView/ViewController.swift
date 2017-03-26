//
//  ViewController.swift
//  LEEPageView
//
//  Created by 李杰 on 2017/3/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let titles = ["全部", "美女", "游戏", "趣玩", "户外"]
        
//        let titles = ["全部美女", "美女美女美女", "游戏啊", "趣玩", "户外", "美女美女","美女"]
        
        var vcs = [LEEViewController]()
        
        for i in 0 ... titles.count - 1 {
            let vc = LEEViewController()
            vc.view.tag = i
            vc.view.backgroundColor = UIColor.randomColor()
            vcs .append(vc)
        }
        
        let style = LEEPageViewStyle()
//        style.titleViewScrollEnable = true
        
        let pageFrame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        let pageView = LEEPageView(frame: pageFrame, titles: titles, parentVc: self, childVcs: vcs, style: style)
        view.addSubview(pageView)
    
    }


}

