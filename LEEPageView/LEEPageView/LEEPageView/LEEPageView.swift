//
//  LEEPageView.swift
//  LEEPageView
//
//  Created by 李杰 on 2017/3/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

import UIKit

class LEEPageView: UIView {
    
    fileprivate var titles : [String]
    fileprivate var parentVc : UIViewController
    fileprivate var childVcs : [UIViewController]
    fileprivate var style : LEEPageViewStyle
    
    fileprivate var titleView : LEETitleView!
    fileprivate var contentView : LEEContentView!

    init(frame: CGRect, titles: [String], parentVc: UIViewController, childVcs: [UIViewController], style: LEEPageViewStyle) {
        self.titles = titles
        self.parentVc = parentVc
        self.childVcs = childVcs
        self.style = style
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK:- 设置ui
extension LEEPageView {
    
    fileprivate func setupUI() {
        setupTitleView()
        setupContentView()
        //相互成为代理
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
    private func setupTitleView() {
        
        titleView = LEETitleView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: style.titleViewH), titles: titles, style: style)
        titleView.backgroundColor = style.titleViewBgColor
        self.addSubview(titleView)
    }
    
    private func setupContentView() {
        contentView = LEEContentView(frame: CGRect(x: 0, y: style.titleViewH, width: self.bounds.width, height: self.bounds.height - style.titleViewH), parentVc: parentVc, childVcs: childVcs)
        self.addSubview(contentView)
    }
}
