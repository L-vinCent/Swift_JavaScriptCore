//
//  ViewController.swift
//  javaScriptCore_test
//
//  Created by Liao PanPan on 2017/3/29.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

import UIKit
import JavaScriptCore
class ViewController: UIViewController,UIWebViewDelegate {

    var pp_webview : UIWebView!
    var pp_jsContext: JSContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        addWebview()
//        getJSVar()  //测试调用原生代码
        
        
    }
    

//添加webview
    
    func addWebview()  {
        
        pp_webview = UIWebView(frame: view.bounds)
        pp_webview.delegate=self
        pp_webview.scalesPageToFit=true
        view .addSubview(pp_webview)
        
        
        guard let url = Bundle.main.url(forResource: "demo", withExtension: "html")else{
            
            return
            
        }
        
        let request = URLRequest(url:url)
        
        pp_webview.loadRequest(request)
        
    }
  

}



//JS掉用原生
extension ViewController
{

    
        //webview代理中，绑定原生协议方法
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        
        pp_jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        let model = javaScriptModel()
        model.controller = self
        model.jsContext = pp_jsContext
        
        // 这一步是将SwiftJavaScriptModel模型注入到JS中，在JS就可以通过WebViewJSBridge调用我们暴露的方法了。
        pp_jsContext.setObject(model, forKeyedSubscript: "WebViewJSBridge" as (NSCopying & NSObjectProtocol)!)

        
        pp_jsContext.exceptionHandler = { (context, exception) in
            //打印异常
            print("exception：", exception)
        }
    }

}

//原生调用JS
extension ViewController {
    
    // JS数据
    func getJSVar() {
        
        let context: JSContext = JSContext() //定义JS环境
        let result1: JSValue = context.evaluateScript("1 + 1") //执行JS代码
        print(result1)  // 输出2
   
        // 定义js变量和函数
        context.evaluateScript("function sum(param1, param2) { return param1 + param2; }")
        
        //通过下标来获取js方法并调用方法
        let pp_func = context.objectForKeyedSubscript("sum")
        let result = pp_func?.call(withArguments: [10,10]).toString()
        print(result!)  //输出20
        
        
        //下标获取js数组的值
        context.evaluateScript("var names = ['vincen1', 'vincen2', 'vincen3']")
        
        let names = context.objectForKeyedSubscript("names")
        
        let name = names?.objectAtIndexedSubscript(0).toString()
        
        print(name ?? "空值处理")  //输出 Grace
        
    }

}
