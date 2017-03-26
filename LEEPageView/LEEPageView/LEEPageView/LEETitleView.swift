//
//  LEETitleView.swift
//  LEEPageView
//
//  Created by 李杰 on 2017/3/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

import UIKit

protocol LEETitleViewDelegate : class {
    func titleView(_ title: LEETitleView, _ targetIndex: Int)
}

class LEETitleView: UIView {
    
    weak var delegate : LEETitleViewDelegate?
    
    fileprivate var titles : [String]
    fileprivate var style : LEEPageViewStyle
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false  //这个属性可以控制点击statuebar 是否 自动滚动到顶部
        return scrollView
    }()
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var preSelectIndex : Int = 0

    init(frame: CGRect, titles: [String], style: LEEPageViewStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame);
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK:- 设置UI
extension LEETitleView {
    fileprivate func setupUI() {
        self.addSubview(scrollView)
        
        setupTitleLabels()
        setupTitleLablesFrame()
    }
    
    private func setupTitleLabels() {
        
        for (i , title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.font = UIFont.systemFont(ofSize: style.titleFontSize)
            label.tag = i
            label.textColor = (i == 0) ? style.selectColor : style.normolColor
            label.textAlignment = .center
            scrollView.addSubview(label)
            titleLabels.append(label)
            
//            #selector(titleLabelClick)
            let tapG = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapG)
            label.isUserInteractionEnabled = true
        }
    }
    
    private func setupTitleLablesFrame() {
        var x : CGFloat = 0.0
        let y : CGFloat = 0
        var w : CGFloat = 0.0
        let h : CGFloat = self.bounds.height
        
        for (i, label) in titleLabels.enumerated() {
            if style.titleViewScrollEnable { // 可以滑动
                w = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil).width
                x = i == 0 ? 0.5 * style.titleViewItemMargin : titleLabels[i - 1].frame.maxX + style.titleViewItemMargin
            } else { // 不可滑动
                w = self.bounds.width / CGFloat(titles.count)
                x = w * CGFloat(i)
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        
        scrollView.contentSize = style.titleViewScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.titleViewItemMargin * 0.5, height: 0) : CGSize.zero
    }
}


//MARK:- 监听事件
extension LEETitleView {
    @objc fileprivate func titleLabelClick(_ tapG: UITapGestureRecognizer) {
        
        // 1.获取当前label
        let label = tapG.view as! UILabel
        
        // 2.调整标题的位置
        adjustTileLabel(currentIndex: preSelectIndex, targetIndex: label.tag)
        
        // 3.通知代理 点击标题
        delegate?.titleView(self, label.tag)
        
    }
    
    fileprivate func adjustTileLabel(currentIndex: Int, targetIndex: Int) {
        guard currentIndex != targetIndex else { return }
        // 1. 取出label
        let currentLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2. 修改颜色
        currentLabel.textColor = style.normolColor
        targetLabel.textColor = style.selectColor
        
        // 3. 调整位置
        
        if style.titleViewScrollEnable {
            
            var offset = targetLabel.center.x - scrollView.bounds.width / 2
            
            offset = offset < 0 ? 0 : offset
            offset = offset > scrollView.contentSize.width - scrollView.bounds.width ? scrollView.contentSize.width - scrollView.bounds.width : offset
            
            scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
        
        // 4.修改当前选中的index
        preSelectIndex = targetIndex
    }
}

//MARK:- LEEContentViewDelegate
extension LEETitleView : LEEContentViewDelegate {
    func contentView(_ contentView: LEEContentView, targetIndex: Int) {
        adjustTileLabel(currentIndex: preSelectIndex, targetIndex: targetIndex)
    }
    
    func contentView(_ contentView: LEEContentView, targetIndex: Int, progress: CGFloat) {
        print("\(targetIndex)---\(progress)")
    }
}

