//
//  ViewController.swift
//  PoemShow
//
//  Created by Lois_pan on 16/3/31.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

import UIKit
//
//
//渔樵江渚，几回烟雨初上，
//山长水阔，倚棹醉梦行舟
//

class ViewController: UIViewController {

    var myLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = UIImageView()
        backImage.image = UIImage.init(named:"bg-1")
        backImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.insertSubview(backImage, atIndex: 0)
        
        let viewPoem = PoemShow(frame: CGRectMake(0, 200, self.view.frame.size.width, 50), message: "楚城今近远，")
         view.addSubview(viewPoem)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5*Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            let viewPoem1 = PoemShow(frame: CGRectMake(0, 250, self.view.frame.size.width, 50), message: "积霭寒塘暮。")
            self.view.addSubview(viewPoem1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5*Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                let viewPoem2 = PoemShow(frame: CGRectMake(0, 300, self.view.frame.size.width, 50), message: "水浅舟且迟，")
                self.view.addSubview(viewPoem2)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5*Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    let viewPoem3 = PoemShow(frame: CGRectMake(0, 350, self.view.frame.size.width, 50), message: "淮潮至何处。")
                    self.view.addSubview(viewPoem3)
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
    
    

    
    