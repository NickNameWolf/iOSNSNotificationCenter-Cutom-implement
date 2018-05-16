//
//  CNotification.swift
//  CustomNotificationCenter
//
//  Created by 刘树华 on 2018/5/16.
//  Copyright © 2018年 刘树华. All rights reserved.
//

import Foundation

class CNotification :NSObject{
    var name:String?
    var object:Any?
    var userInfo:[String:Any]?
    init(name:String?=nil,obj:Any?=nil,userinfo:[String:Any]?=nil) {
        self.name = name
        self.object = obj
        self.userInfo = userinfo
    }
    
    
}
