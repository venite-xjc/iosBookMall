//
//  DetailViewController.swift
//  BookMall
//
//  Created by xjc on 2022/5/20.
//  Copyright © 2022 venite. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        price.text = list["price"]
        name.text = list["title"]
        code.text = list["code"]
        detail.text = list["description"]
        author.text = list["author"]
        let imgurl = list["pic"]!
        let url : URL = URL.init(string: imgurl)! // 初始化url图片
        let data : NSData! = NSData(contentsOf: url) //转为data类型
        if data != nil {
            image.image = UIImage.init(data: data as Data, scale: 1) //赋值图片
        }
    }
    
    var list:[String:String] = [:]
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var code: UILabel!
    
    @IBOutlet weak var detail: UILabel!
    
    @IBOutlet weak var author: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func insertIntoCart(_ sender: Any) {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){return}
        
        let sql = "INSERT INTO items(title, price, user) VALUES('\(list["title"] ?? "")', '\(list["price"] ?? "")', '\(global.user)')"
        if !sqlite.execNoneQuerySQL(sql: sql){
            sqlite.closeDB();return
        }
        else{
            print("购物车添加成功")
        }
        
        let d = sqlite.execQuerySQL(sql: "SELECT * FROM items")
        print(d as Any)
        
        let nav = tabBarController?.viewControllers![1] as! UINavigationController
        CartViewController.count += 1
        nav.tabBarItem!.badgeValue = "\(CartViewController.count)"
    }
}
