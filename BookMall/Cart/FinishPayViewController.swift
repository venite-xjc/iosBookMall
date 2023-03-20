//
//  FinishPayViewController.swift
//  BookMall
//
//  Created by xjc on 2022/5/22.
//  Copyright © 2022 venite. All rights reserved.
//

import UIKit

class FinishPayViewController: UIViewController {

    var list = [[String:AnyObject]]()
    
    @IBOutlet weak var Money: UILabel!
    
    @IBOutlet weak var ID: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var money:Float = 0.0
        for row in list{
            let a = Float(row["price"]! as! String) ?? 1.0
            
            money+=a
            print(money, a)
        }
        Money.text = String(money)
        let time = gettime()
        let idForUser = time+"-\(global.user)"+"-\(list.count)"
        ID.text = idForUser
        
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){
            return
        }
        for row in list{
            let sql = "INSERT INTO history(id, title, price, time, user) VALUES('\(idForUser)', '\(row["title"]! as? String ?? "")', '\(row["price"]! as? String ?? "")', '\(time)', '\(global.user)')"
            if !sqlite.execNoneQuerySQL(sql: sql){
                sqlite.closeDB();return
            }
        }
        sqlite.closeDB()
    }
    
    func gettime()->String{
        let now = Date()
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return d.string(from: now)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
