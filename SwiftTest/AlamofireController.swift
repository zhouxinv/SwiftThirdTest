//
//  AlamofireController.swift
//  SwiftTest
//
//  Created by GeWei on 2017/1/10.
//  Copyright © 2017年 GeWei. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class AlamofireController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的商家";
        
        self.getListValue()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //nib 已经存在cell的时候调用
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier:"reuseIdentifier")
        }
        
        cell?.textLabel?.text = "celllllll";

        return cell!
    }
    
    
    
    func toSortedWithAppKey(newParams: NSMutableDictionary) -> (String) {
        let APPKEY = "CHE168CRMMRC"
        let str = NSMutableString(string: "CHE168CRMMRC")
        
        let keys = newParams.allKeys as Array
        let sortedArray = keys.sorted(by: { (obj1, obj2) -> Bool in
            return true
        })
        
        for  key in sortedArray {
            let value = newParams.object(forKey: key)
            str.appendFormat(key as! NSString,value as! CVarArg)
        }
        
        str.append(APPKEY as String)
        
        let strs = str as String
        
        return strs.md5();
    }
    
    
   
    // MARK: - NetWork
    func getListValue() -> Void {
        
        let params = self.getParams()
        
        let urlStr = "https://apicrm.che168.com/api/DealerNew/GetDealerListByCondition"
        
        let headers: HTTPHeaders = [
            "set-Cookie": "aaUSpwbiqekJh0YhhFuAEo4B6NYT5q81d0SAeixF/vp2Bb1Dfr48ovMPFHVGO2/IKF13YZ7Tcma06piBIZo47YlPetJ8S2c9Vfu0/1pe3siUk9bvQbTuNxjwMSs5K3iGw9FTMpH3NiYKbQUXoQ1r1pSGbgNqXRoVWFCL1fxehsO8="
        ]

        
        Alamofire.request(urlStr, method: .get, parameters: params as? Parameters, headers: headers)
            .responseJSON { (response) in
                /*这里使用了闭包*/
                //当请求后response是我们自定义的，这个变量用于接受服务器响应的信息
                //使用switch判断请求是否成功，也就是response的result
                switch response.result {
                //swift 值绑定的写法
                case .success(_):
                    //当响应成功是，使用临时变量value接受服务器返回的信息并判断是否为[String: AnyObject]类型 如果是那么将其传给其定义方法中的success
                    if let value = response.result.value as? [String : AnyObject] {
//                        success(value)
                        let json = JSON(value)
                        print("JSON: \(json)")
                    }
                case .failure(_):
//                    failture(error)
                    print("error")
                }
        }
        
    }
    
    
    func getParams() -> NSDictionary {
        // _device	iOS 10.2(iPhone Simulator)
        //        _latitude	0
        //        _longitude	0
        //        _net	Wifi
        //        _sign	b628ec882900e4beac7552ff86b2f01d
        //        _timestamp	1484014953583
        //        _token	aUSpwbiqekJh0YhhFuAEo4B6NYT5q81d0SAeixF/vp2Bb1Dfr48ovMPFHVGO2/IKF13YZ7Tcma06piBIZo47YlPetJ8S2c9Vfu0/1pe3siVqMN64MarARLg7PmLL/Y1J9FTMpH3NiYKbQUXoQ1r1pSGbgNqXRoVWFCL1fxehsO8=
        //        _udid	bf83c555dd8544e0aec2e877bb200fcae9fa1c80
        //        _ver	3.3.0
        //        adviserid	0
        //        areaid	0
        //        carstatus	-1
        //        cityid	0
        //        collarstate	-1
        //        dealerkeyword
        //        dealerstatus	1
        //        dealertype	0
        //        focusstatus	-1
        //        marketingstate	-1
        //        pageindex	1
        //        pagesize	20
        //        paystatus	-1
        //        sorttype	40
        //        tasktype	-1
        
        let _token = "aUSpwbiqekJh0YhhFuAEo4B6NYT5q81d0SAeixF/vp2Bb1Dfr48ovMPFHVGO2/IKF13YZ7Tcma06piBIZo47YlPetJ8S2c9Vfu0/1pe3siUk9bvQbTuNxjwMSs5K3iGw9FTMpH3NiYKbQUXoQ1r1pSGbgNqXRoVWFCL1fxehsO8="
        let _udid = "bf83c555dd8544e0aec2e877bb200fcae9fa1c80 "
        let _device = "iOS 10.2(iPhone Simulator)"
        let _version = "3.3.0";
        let _netwoktype = "Wifi";
        let _longitude = "0";
        let _latitude = "0"
        let _timestamp = Date().timeIntervalSince1970 * 1000
        //        [[NSDate date] timeIntervalSince1970] * 1000;
        
        let dict = NSMutableDictionary()
        dict .setValue ("20 ", forKey: "pagesize")
        dict .setValue ("1 ", forKey: "pageindex")
        let newParams = NSMutableDictionary(dictionary: dict)
        newParams.setValue(_udid, forKey: "_udid")
        newParams.setValue(_device, forKey: "_device")
        newParams.setValue(_version, forKey: "_ver")
        newParams.setValue(_netwoktype, forKey: "_net")
        newParams.setValue(_longitude, forKey: "_longitude")
        newParams.setValue(_latitude, forKey: "_latitude")
        newParams.setValue(_timestamp, forKey: "_timestamp")
        newParams.setValue(_token, forKey: "c")
        
        // 获取sign加密
        //        _sign = [newParams cmToSorted];
        let _sign = self.toSortedWithAppKey(newParams: newParams)
        newParams.setValue(_sign, forKey: "_sign")
        newParams.setValue(_token, forKey: "_token")
        newParams.removeObject(forKey: "c")
        //        [newParams setValue:_sign forKey:@"_sign"];
        //        [newParams setValue:_token forKey: @"_token" ];//_token不参与加密
        //        [newParams removeObjectForKey:@"c"]; //加密后剔除
        return newParams ;
    }


}
