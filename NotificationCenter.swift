//
//  NotificationCenter.swift
//  CustomNotificationCenter
//
//  Created by 刘树华 on 2018/5/16.
//  Copyright © 2018年 刘树华. All rights reserved.
//

import Foundation

fileprivate class ObserverModel {
    var observer:AnyObject?
    var sel:Selector?
    var name:String?
    
    
}

final class CNotificationCenter:NSObject  {
    
    static let defaultCenter = CNotificationCenter()
    private var observerDic = [String:[String:ObserverModel]]()
    
    private override init() {
        
    }
    
   private func addObserverToDic(name:String,sel:Selector,observer:AnyObject)  {
       let model = ObserverModel()
        model.name = name
        model.sel = sel
        model.observer = observer
        let classname = NSStringFromClass(observer.classForCoder)
    if CNotificationCenter.defaultCenter.observerDic[name] == nil{
       CNotificationCenter.defaultCenter.observerDic[name] = [classname:model]
    }else{
        CNotificationCenter.defaultCenter.observerDic[name]![classname] = model
    }
    
    
    }
  private func getObserverFromDic(name:String) ->[String:ObserverModel]? {
        return CNotificationCenter.defaultCenter.observerDic[name]
    }
    func addObserver(observer:AnyObject,selector:Selector,name:String,obj:Any?)  {
       addObserverToDic(name: name, sel: selector, observer: observer)
    }
    func postNotification(notification:CNotification)  {
        guard let name = notification.name ,let dic = getObserverFromDic(name: name) else {
            return
        }
       _ = dic.map{
            guard let sel = $0.value.sel,let observer = $0.value.observer else{
                return
            }
                  _=observer.perform(sel, with: notification)
        }

    }
    func postNotificationName(name:String,obj:Any?)  {
        guard let dic = getObserverFromDic(name: name) else {
            return
        }
       let noti = CNotification(name: name, obj: obj, userinfo: nil)
        _ = dic.map{
            guard let sel = $0.value.sel,let observer = $0.value.observer else{
                return
            }
            _=observer.perform(sel, with: noti)
        }
        
    }
    func postNotificationName(name:String,obj:Any?,userinfo:[String:Any]?)  {
        guard let dic = getObserverFromDic(name: name) else {
            return
        }
        let noti = CNotification(name: name, obj: obj, userinfo: userinfo)
        _ = dic.map{
            guard let sel = $0.value.sel,let observer = $0.value.observer else{
                return
            }
            _=observer.perform(sel, with: noti)
        }
    }
    func removeObserver(observer:AnyObject)  {
        
        for (key,var val) in CNotificationCenter.defaultCenter.observerDic {
            if val.keys.contains(NSStringFromClass(observer.classForCoder)){
                val.removeValue(forKey: NSStringFromClass(observer.classForCoder))
                CNotificationCenter.defaultCenter.observerDic.updateValue(val, forKey: key)
            }
        }
        
        
    }
    func removeObserver(observer:AnyObject,name:String,obj:Any?) {
        guard var dic = CNotificationCenter.defaultCenter.observerDic[name] else {
            return
        }
        dic.removeValue(forKey: NSStringFromClass(observer.classForCoder))
        CNotificationCenter.defaultCenter.observerDic[name] = dic
    }
    
}
