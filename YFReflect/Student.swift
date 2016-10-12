//
//  Student.swift
//  YFReflect
//
//  Created by yuanyeerchen on 16/10/11.
//  Copyright © 2016年 yuan. All rights reserved.
//

import UIKit

class Student: NSObject {
    var name : String = ""
    var agE : Int = 0
    var book : Book = Book()
    var books : [Book] = []
    var tag : [String] = []
    
    
    override class func GetModelProperty() -> [String : AnyClass] {
        return ["book" : Book.classForCoder()]
    }
    override class func GetSpecailProperty() -> NSDictionary {
        return ["agE" : "age"]
    }
    override class func GetModelArrProperty() -> [String : AnyClass] {
        return ["books" : Book.classForCoder()]
    }
}
