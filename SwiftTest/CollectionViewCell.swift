//
//  Kingfisher.swift
//  SwiftTest
//
//  Created by GeWei on 2016/12/23.
//  Copyright © 2016年 GeWei. All rights reserved.
//
import UIKit

class CollectionViewCell: UICollectionViewCell {
    var cellImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
         self.contentView.addSubview(cellImageView)
        cellImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(self.contentView)
        }
         cellImageView.clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
