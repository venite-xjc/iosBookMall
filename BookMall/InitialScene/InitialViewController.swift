//
//  InitialViewController.swift
//  BookMall
//
//  Created by xjc on 2022/5/15.
//  Copyright © 2022 venite. All rights reserved.
//

import UIKit
import Foundation
//import PlaygroundSupport
//PlaygroundSupport.current.needsIndefiniteExecution = true



class InitialViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try userName.text = defaults.string(forKey: "Name")
        try password.text = defaults.string(forKey: "Password")
        // Do any additional setup after loading the view.
        //create users table
        initialUserList()
        initialBookList()
        initialCartList()
        initialHistoryList()
    }
    
    func initialUserList(){
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){return}
        
        if !sqlite.execNoneQuerySQL(sql: "DROP TABLE IF EXISTS users"){
            sqlite.closeDB();return
        }
        else{
            print("删除了用户表")
        }
        
        let createSql = "CREATE TABLE IF NOT EXISTS users('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 'name' TEXT, 'password' TEXT);"
        if !sqlite.execNoneQuerySQL(sql: createSql){
            sqlite.closeDB();return
        }
        else{
            print("生成了用户表")
        }
        
        
        let resetStu = "DELETE FROM sqlite_sequence WHERE name = 'users';"
        if !sqlite.execNoneQuerySQL(sql: resetStu){
            sqlite.closeDB();return
        }
        
        if !sqlite.execNoneQuerySQL(sql: "INSERT INTO users(name, password) VALUES('xjc', '123')"){
            sqlite.closeDB();return
        }
        sqlite.closeDB()
    }
    
    func initialBookList(){
        
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){return}
        
        if !sqlite.execNoneQuerySQL(sql: "DROP TABLE IF EXISTS books"){
            sqlite.closeDB();return
        }
        else{
            print("删除了图书表")
        }
        
        let createSql = "CREATE TABLE IF NOT EXISTS books('id' TEXT, 'kind' TEXT, 'title' TEXT, 'author' TEXT, 'publisher' TEXT, 'code' TEXT, 'price' TEXT, 'description' TEXT, 'pic' TEXT);"
        
        if !sqlite.execNoneQuerySQL(sql: createSql){
            sqlite.closeDB();return
        }
        else{
            print("生成了图书表")
        }
        
        sqlite.closeDB()
        
        //var Data:[[String:String]]
        
        let baseURL = URL(string: "http://zy.whu.edu.cn/cs/api/book/list")!
        let url = baseURL
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
                let jsonobj = try? JSONSerialization.jsonObject(with: data, options:.mutableLeaves),
                let json = jsonobj as? [String:Any],
                let dic = json["result"] as? [[String:String]]{
                
                let sqlite1 = SQLiteManager.sharedInstance
                if !sqlite1.openDB(){return}
                
                for row in dic{
                    let id = row["id"]
                    let kind = row["kind"]
                    let title = row["title"]
                    let author = row["author"]
                    let publisher = row["publisher"]
                    let code = row["code"]
                    let price = row["price"]
                    let description = row["description"]
                    let pic = row["pic"]
                    
                    let sql = "INSERT INTO books(id, kind, title, author, publisher, code, price, description, pic) VALUES('\(id ?? "")', '\(kind ?? "")', '\(title ?? "")', '\(author ?? "")', '\(publisher ?? "")', '\(code ?? "")', '\(price ?? "")', '\(description ?? "")', '\(pic ?? "")')"
                    
                    print(sql)
                    
                    
                    if sqlite1.execNoneQuerySQL(sql: sql){
                        print("数据库添加成功")
                    }
                    else{
                        print("数据库添加失败")
                    }
                    
                }
                sqlite1.closeDB()
                }
        }
        
        task.resume()
        
        
    }
    
    func initialCartList(){
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){return}

        
        let createSql = "CREATE TABLE IF NOT EXISTS items('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 'title' TEXT, 'price' TEXT, 'user' TEXT);"
        if !sqlite.execNoneQuerySQL(sql: createSql){
            sqlite.closeDB();return
        }
        else{
            print("生成了购物车表")
        }

        sqlite.closeDB()
    }
    
    func initialHistoryList(){
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){return}

        if !sqlite.execNoneQuerySQL(sql: "DROP TABLE IF EXISTS history"){
            sqlite.closeDB();print("删除历史表");return
        }
        let createSql = "CREATE TABLE IF NOT EXISTS history('id' TEXT, 'title' TEXT, 'price' TEXT, 'time' TEXT, 'user' TEXT);"
        if !sqlite.execNoneQuerySQL(sql: createSql){
            sqlite.closeDB();return
        }
        else{
            print("生成了历史表")
        }

        sqlite.closeDB()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func Login(_ sender: Any) {
        //let loginVC = LoginViewController()
        //present(loginVC, animated: true, completion: nil)
        var match:Bool = false
        
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){return}
        
        let users = sqlite.execQuerySQL(sql: "SELECT * FROM users")
        print(users!)
        
        for row in users!{
            let name = row["name"] as! String
            let pwd = row["password"] as! String
            if name == userName.text&&pwd == password.text{
                match = true
                break
            }
        }
        
        
        if match{
            defaults.set(userName.text, forKey: "Name")
            defaults.set(password.text, forKey: "Password")
            
            print("登录成功，用户名为：\(userName.text ?? "")， 密码为：\(password.text ?? "")")
            global.user = userName.text ?? ""
            let mainBoard:UIStoryboard! = UIStoryboard(name:"Main", bundle:nil)
            
            let VCMain = mainBoard!.instantiateViewController(withIdentifier:"vcMain")
            
            UIApplication.shared.windows[0].rootViewController = VCMain
        }
        else {
            let p = UIAlertController(title:"登陆失败", message:"用户名或密码错误", preferredStyle: .alert)
            p.addAction(UIAlertAction(title:"确定", style:.default, handler:{
                (act:UIAlertAction) in self.password.text = ""
            }))
            present(p, animated:false, completion: nil)
        }
        
    }
}
