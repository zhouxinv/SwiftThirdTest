//
//  SnpKitTest.swift
//  SwiftTest
//
//  Created by GeWei on 2016/12/23.
//  Copyright © 2016年 GeWei. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SnapKitViewController: UIViewController {
    
    var functionName: NSInteger = 0
    init(function: NSInteger){
        super.init(nibName: nil, bundle: nil)
        self.functionName = function
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //方块1
    lazy var box1 = UIView()
    //方块2
    lazy var box2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        box1.backgroundColor = UIColor.orange
        self.view.addSubview(box1)
        box2.backgroundColor = UIColor.green
        self.view.addSubview(box2)
        
        switch functionName {
        case 0:
            ///一个中心view
            addBoxView()
        case 1:
            ///绿色方块放置橙色方块内部的右下角位置
            addInnerBoxOutterBox()
         case 2:
            ///绿色方块视图大小同上面橙色方块相同，下面视图与上面视图左侧平齐，下面视图顶部与上面视图底部平齐。
            equalBoxes()
         case 3:
            ///距离父视图上、左、下、右边距分别是10、15、20、25
            insertBox()
        case 4:
            ///绿色视图比橙色视图宽度、高度均减50
            offsetBox()
        case 5:
            ///绿色视图的尺寸设置成橙色视图一半大小。
            halfBoxView()
        default: break
            
        }
 
        /* updateConstraints 更新约束
         remakeConstraints 重新约束
         removeConstraints 删除约束
         */
        
    }
    
    func updateCons(){
        let snapKitButton: UIButton = UIButton()
        snapKitButton.setTitle("updataUI", for:.normal)
        snapKitButton.backgroundColor = UIColor.red
        snapKitButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        self.view .addSubview(snapKitButton)
        snapKitButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-80)
        }
    }
    
    func tapped(){
      box2.snp.updateConstraints { (make) in
        make.center.equalTo(box1).offset(20)
        }
    }
    func halfBoxView(){
        box1.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(200)
            make.center.equalTo(self.view)
        }
        
        box2.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(box1)
            // make width = superview.width / 2, height = superview.height / 2
            make.size.equalTo(box1).multipliedBy(0.5)
        }
        
        ///绿色视图的中心偏移橙色视图中心。
        updateCons()
    }
    
    func offsetBox(){
        box1.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(200)
            make.center.equalTo(self.view)
        }
        
        box2.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(box1)
            // make width = superview.width - 50, height = superview.height - 50
            make.size.equalTo(box1).offset(-50)
        }
    }
    
    func insertBox(){
        box1.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(200)
            make.center.equalTo(self.view)
        }
        box2.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(box1).inset(UIEdgeInsetsMake(10, 15, 20, 25))
        }
    }
    
    func equalBoxes(){
        box1.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(64)
        }
        
        box2.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(box1)
            make.left.equalTo(box1) //等同于 make.left.equalTo(box1.snp.left)
            make.top.equalTo(box1.snp.bottom)
        }
    }
    /*
     
     left、right、top、centerX、centerY
     */
    func addInnerBoxOutterBox(){
        
        box1.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(200)
            make.center.equalTo(self.view)
        }
        
        box2.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100)
            make.right.equalTo(box1)
            make.bottom.equalTo(box1)
        }
        
    }
    /*
     .equalTo：等于
     .lessThanOrEqualTo：小于等于
     .greaterThanOrEqualTo：大于等于
     inset、offset: 位移修正
     multipliedBy: 倍率修正
     */
   private func addBoxView(){
        box1.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.center.equalTo(self.view)
        }
        
    }


}
