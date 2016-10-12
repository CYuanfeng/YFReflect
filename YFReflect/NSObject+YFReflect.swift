//
//  NSObject+YFReflect.swift
//  YFReflect
//
//  Created by yuanyeerchen on 16/10/11.
//  Copyright © 2016年 yuan. All rights reserved.
//

import UIKit
// MARK: - 反射机制转换模型
extension NSObject {
    /** 字典转模型 */
    func DictToModel(dict : NSDictionary) {
        let hMirror = Mirror(reflecting: self)
        for item in hMirror.children {
            let speProArr = self.classForCoder.GetSpecailProperty()
            if speProArr.count > 0 { //存在特殊属性值
                if speProArr[item.label!] != nil  { //用特殊的属性值
                    if dict[speProArr[item.label!] as! String] != nil && dict[speProArr[item.label!] as! String]?.isKindOfClass(NSNull) == false{
                        self.setValue(dict[speProArr[item.label!] as! String], forKey: item.label!)
                    }
                    continue
                }
            }
            
            let modProArr = self.classForCoder.GetModelProperty()
            if modProArr.count > 0 { //存在模型属性
                if modProArr[item.label!] != nil {
                    let model = modProArr[item.label!]?.alloc()
                    if dict[item.label!] != nil && dict[item.label!]?.isKindOfClass(NSNull) == false {
                        model?.DictToModel(dict[item.label!] as! NSDictionary)
                        self.setValue(model, forKey: item.label!)
                        continue
                    }
                    
                }
            }
            
            let modProArr_spe = self.classForCoder.GetModelProperty_speName()
            if modProArr_spe.count > 0 { //存在模型属性（名称不对应）
                let dict1 = modProArr_spe[0]
                let rightKey = dict1[item.label!] as! String
                let dict2 = modProArr_spe[1]
                let modelClass = dict2[rightKey] as! AnyClass
                let model = modelClass.alloc()
                if dict[rightKey] != nil && dict[rightKey]?.isKindOfClass(NSNull) == false {
                    model.DictToModel(dict[rightKey] as! NSDictionary)
                    self.setValue(model, forKey: item.label!)
                    continue
                }
            }
            
            let modArrProArr = self.classForCoder.GetModelArrProperty()
            if modArrProArr.count > 0 { //如果存在模型数组属性
                if modArrProArr[item.label!] != nil {
                    let modelClass = modArrProArr[item.label!]
                    if dict[item.label!] != nil && dict[item.label!]?.isKindOfClass(NSNull) == false {
                        let modelArr = modelClass?.DictToModelArray(dict[item.label!] as! [NSDictionary])
                        self.setValue(modelArr, forKey: item.label!)
                        continue
                    }
                }
            }
            
            let modArrProArr_spe = self.classForCoder.GetModelArrProperty_speName()
            if modArrProArr_spe.count > 0 { //如果存在模型数组属性(名称不对应)
                let dict1 = modArrProArr_spe[0]
                let rightKey = dict1[item.label!] as! String
                let modelClass = modArrProArr_spe[1][rightKey] as! AnyClass
                if dict[rightKey] != nil && dict[rightKey]?.isKindOfClass(NSNull) == false {
                    let modelArr = modelClass.DictToModelArray(dict[rightKey] as! [NSDictionary])
                    self.setValue(modelArr, forKey: item.label!)
                    continue
                }
            }
            if dict[item.label!] != nil {
                //没有特殊属性和模型属性
                self.setValue(dict[item.label!], forKey: item.label!)
            }
        }
    }
    
    class func PrintPropertyList() {
        let hMirror = Mirror(reflecting: self.init())
        var str : String = "["
        for item in hMirror.children {
            str = str + "\"" + item.label! + "\":" + "\"" + item.label! + "\","
        }
        str = str + "]"
        print(str)
    }
    
    /** 字典转模型数组 */
    class func DictToModelArray(dictArr : [NSDictionary]) ->[AnyObject]  {
        var arr : [AnyObject] = []
        for dict in dictArr {
            let obj = self.init()
            obj.DictToModel(dict)
            arr.append(obj)
        }
        return arr
    }
    /** 单个字典转换模型 */
    class func DictModelSignle(dict : NSDictionary) -> AnyObject {
        let obj = self.init()
        obj.DictToModel(dict)
        return obj
    }
    
    
    
    
    
    /**
     子类需要重写的类方法
     
     */
    
    
    /** 获取特定的属性值列表 (属性值与字典中属性不对应)*/
    class func GetSpecailProperty() -> NSDictionary {
        return NSDictionary()
    }
    
    /** 获取特定的模型属性值列表 (含有模型的属性)*/
    class func GetModelProperty() -> [String : AnyClass] {
        return [:]
    }
    /** 获取特定的模型属性值列表(含有模型的属性)  第一个存放正确的名称，第二个存放对应的属性类
     例: return [["自定义的属性名":"字典的属性名"],["字典的属性名",该模型的类名]]
     */
    class func GetModelProperty_speName() -> [NSDictionary] {
        return []
    }
    /** 获取特性的模型数组属性值列表 (含有模型数组的属性)*/
    class func GetModelArrProperty() -> [String : AnyClass] {
        return [:]
    }
    /** 获取特定的模型数组属性值列表(含有模型数组的属性)  第一个存放正确的名称，第二个存放对应的属性类  */
    class func GetModelArrProperty_speName() -> [NSDictionary] {
        return []
    }
    
    /**
     模型转换字典：
     
     */
    
    /** 不包含模型 */
    func ModelToDict() -> [String : AnyObject] {
        let hMirror = Mirror(reflecting: self)
        var dict : [String : AnyObject] = [:]
        for item in hMirror.children {
            dict[item.label!] = item.value as! AnyObject
        }
        return dict
    }
    
    /**
     包含模型
     */
    func ModelToDict_mod() -> [String : AnyObject] {
        let hMirror = Mirror(reflecting: self)
        
        var dict : [String : AnyObject] = [:]
        for item in hMirror.children {
            if self.isArrClass(item.value as! AnyObject) == true { //包含数组
                let modelArr = item.value as! NSArray
                var dictArr : [AnyObject] = []
                for modelItem in modelArr {
                    if self.isCusClass(modelItem) == true {
                       dictArr.append(modelItem.ModelToDict_mod())
                    }else {
                        dictArr.append(modelItem)
                    }
                    
                }
                dict[item.label!] = dictArr
                continue
            }
            if self.isCusClass(item.value as! AnyObject) == true {
                //是模型属性
                let model = item.value as! AnyObject
                dict[item.label!] = model.ModelToDict_mod()
                continue
            }
            //不是模型属性
            dict[item.label!] = item.value as? AnyObject
        }
        return dict
    }
    
    func isCusClass(obj : AnyObject) -> Bool {
        let anyClass = obj.classForCoder
        let mainB = NSBundle.init(forClass: anyClass)
        if mainB == NSBundle.mainBundle() { //自定义的
            return true
        }else { //不是自定义的
            return false
        }
    }
    func isArrClass(obj : AnyObject) -> Bool {
        if obj.isKindOfClass(NSArray) == true || obj.isKindOfClass(NSMutableArray) == true {
            return true
        }else {
            return false
        }
    }
    
    
    
    
}