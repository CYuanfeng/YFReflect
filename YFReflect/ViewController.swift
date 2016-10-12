//
//  ViewController.swift
//  YFReflect
//
//  Created by yuanyeerchen on 16/10/11.
//  Copyright © 2016年 yuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = ["name" : "tony","age" : 15,"book" : ["name":"语文"],"books":[["name":"one"],["name":"two"]],"tag":["s1","s2","s3"]]
        let stu = Student()
        stu.DictToModel(dict)
        for item in stu.books {
            print("\(item.name)")
        }
        
        let dict2 = stu.ModelToDict_mod()
        print(dict2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

