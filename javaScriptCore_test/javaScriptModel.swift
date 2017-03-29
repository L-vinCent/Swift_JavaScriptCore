
//
//  javaScriptModel.swift
//  javaScriptCore_test
//
//  Created by Liao PanPan on 2017/3/29.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol swiftDelegate : JSExport
{
    
    func wxPay(_ orderNo: String)
    
    func wxShare(_ dict: [String : AnyObject])
    
    func showDMessage(_ dict1:[String : String], _ dict2 : String)
    // js调用App的功能后 App再调用js函数执行回调

    func callHandler(_ handleFuncName: String)
    
}

@objc class javaScriptModel: NSObject ,swiftDelegate {

    weak var controller: UIViewController?
    
    weak var jsContext: JSContext?
    
    
    func wxPay(_ orderNo: String) {
        
//        print("订单号：", orderNo)
        showDialog("", message: "获取到订单号\(orderNo)，调用微信支付")
        
        // 调起微信支付逻辑
    }
    
    func showDMessage(_ dict1: [String : String], _ dict2: String) {
        
        showDialog("", message:"我是第一个字典\(dict1)-----我是第二个字符串\(dict2)")
        
    }
  
    
    func wxShare(_ dict: [String : AnyObject]) {
        
        showDialog("", message: "获取到分享的字典\(dict)，调用微信支付")

    }
    
    func callHandler(_ handleFuncName: String) {
        
        let  jshandFunc = jsContext?.objectForKeyedSubscript("\(handleFuncName)")
        let dict = ["name" : "pp"] as [String : Any]
        jshandFunc?.call(withArguments: [dict])
    }
    
    
    func showDialog(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
        
        
    }
    
}
