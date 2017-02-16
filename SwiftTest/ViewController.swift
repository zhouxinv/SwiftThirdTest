//
//  ViewController.swift
//  SwiftTest
//
//  Created by GeWei on 2016/12/19.
//  Copyright © 2016年 GeWei. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let snapKitButton: UIButton = UIButton()
        snapKitButton.tag = 1
        snapKitButton.setTitle("SnapKit", for:.normal)
        snapKitButton.backgroundColor = UIColor.red
        snapKitButton.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        self.view .addSubview(snapKitButton)
        snapKitButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.center.equalTo(self.view)
        }
        
        let kingfisherButton: UIButton = UIButton()
        kingfisherButton.tag = 2
        kingfisherButton.setTitle("Kingfisher", for:.normal)
        kingfisherButton.backgroundColor = UIColor.red
        kingfisherButton.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        self.view .addSubview(kingfisherButton)
        kingfisherButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(snapKitButton.snp.bottom).offset(10)
            make.centerX.equalTo(snapKitButton)
        }
        
        let AlamofireButton: UIButton = UIButton()
        AlamofireButton.tag = 3
        AlamofireButton.setTitle("Alamofire", for:.normal)
        AlamofireButton.backgroundColor = UIColor.red
        AlamofireButton.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        self.view .addSubview(AlamofireButton)
        AlamofireButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(kingfisherButton.snp.bottom).offset(10)
            make.centerX.equalTo(snapKitButton)
        }
        
    }
    
    func tapped(_ button: UIButton){
        print("tapped")
        if button.tag == 1 {
            let snapKitVC = SnapKitTableViewController()
           navigationController?.pushViewController(snapKitVC, animated: true)
        }
        else if button.tag == 2{
            let kingfisherVC = KingfisherViewController()
            navigationController?.pushViewController(kingfisherVC, animated: true)
        }else if button.tag == 3{
            let alamofireVC = AlamofireController()
            navigationController?.pushViewController(alamofireVC, animated: true);
            
        }
        
    }

}

