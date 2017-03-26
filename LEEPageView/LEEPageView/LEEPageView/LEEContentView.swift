//
//  LEEContentView.swift
//  LEEPageView
//
//  Created by 李杰 on 2017/3/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

import UIKit

protocol LEEContentViewDelegate : class {
    // contentView滑动到另一页时调用
    func contentView(_ contentView: LEEContentView, targetIndex: Int)
    // 监听page切换的进度
    func contentView(_ contentView: LEEContentView, targetIndex: Int, progress: CGFloat)
}

let kCellID = "cellID"

class LEEContentView: UIView {
    
    weak var delegate : LEEContentViewDelegate?
    
    fileprivate var parentVc : UIViewController
    fileprivate var childVcs : [UIViewController]
    
    fileprivate lazy var startOffset : CGFloat = 0.0
    fileprivate lazy var currentSelectPage : Int = 0 // 记录当前选中page
    
    fileprivate lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        var collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    init(frame: CGRect, parentVc: UIViewController, childVcs: [UIViewController]) {
        self.parentVc = parentVc
        self.childVcs = childVcs
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK:- 设置UI
extension LEEContentView {
    
    fileprivate func setupUI() {
        self.addSubview(collectionView)
        
    }
}

//MARK:- UICollectionViewDelegate 
extension LEEContentView : UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("scrollViewDidEndDragging")
        if !decelerate {
            contentEndScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
        contentEndScroll()
    }
    
    private func contentEndScroll() {
        // 1. 获取滚动到的位置
        let targetIndex = collectionView.contentOffset.x / collectionView.bounds.width
        // 2. 通知titleView
        delegate?.contentView(self, targetIndex: Int(targetIndex))
        // 3. 记录当前选中页
        currentSelectPage = Int(targetIndex);
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 在这里记录开始的offset 有一个问题，当用户拖拽一段距离时， cell还未完全复原时， 用户再一次开始拖拽cell  则记录的开始的偏移量不准确
//        startOffset = scrollView.contentOffset.x
        // 在这里每当滑动结束时，记录一下当前选中的页面， 在这里可以解决上面的问题
        startOffset = CGFloat(currentSelectPage) * collectionView.bounds.width
//        print("scrollViewWillBeginDragging\(startOffset)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.x != startOffset else {
            return
        }
        // 1.定义targetIndex progress
        var targetIndex : Int
        var progress : CGFloat
        
        // 2. 赋值
        if startOffset < scrollView.contentOffset.x { // 左滑动
            targetIndex = currentSelectPage + 1
            //安全判断
            if targetIndex == childVcs.count {
                targetIndex -= 1
            }
        } else { // 右滑动
            targetIndex = currentSelectPage - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
        }
        
        progress = abs(startOffset - scrollView.contentOffset.x) / scrollView.bounds.width
        
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
        
    }
}

//MARK:- UICollectionViewDataSource
extension LEEContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellID, for: indexPath)
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let vc = childVcs[indexPath.item]
        cell.contentView.addSubview(vc.view)
        return cell
    }
}

//MARK:- LEETitleViewDelegate
extension LEEContentView : LEETitleViewDelegate {
    func titleView(_ title: LEETitleView, _ targetIndex: Int) {
        currentSelectPage = targetIndex
        let indexpath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexpath, at: .left, animated: false)
    }
}





