//
//  RegisterViewController.swift
//  BookMall
//
//  Created by xjc on 2022/5/15.
//  Copyright © 2022 venite. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var password2: UITextField!
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func enter(_ sender: Any) {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){return}
        
        let users = sqlite.execQuerySQL(sql: "SELECT * FROM users")
        print(users!)
        
        var enter:Bool = true
        
        for row in users!{
            let name = row["name"] as! String
            if userName.text == name{
                let alertController = UIAlertController(title: "系统提示",message: "用户名已存在，请重新输入", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                    action in
                    print("点击了确定")
                })
                alertController.addAction(okAction)
                password.text = ""
                password2.text = ""
                self.present(alertController, animated: true, completion: nil)
                enter = false
            }
            
        }
        
        if password.text == ""{
            let alertController = UIAlertController(title: "系统提示",message: "密码不能为空", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
                print("点击了确定")
            })
            alertController.addAction(okAction)
            password.text = ""
            password2.text = ""
            self.present(alertController, animated: true, completion: nil)
            enter = false
        }
        
        if password.text != password2.text{
            let alertController = UIAlertController(title: "系统提示",message: "您的两次密码不一致，请重新输入", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
                print("点击了确定")
            })
            alertController.addAction(okAction)
            password.text = ""
            password2.text = ""
            self.present(alertController, animated: true, completion: nil)
            enter = false
        }
        print("注册",enter)
        //register
        if enter{
        let register = "INSERT INTO users(name, password) VALUES('\(userName.text ?? "")', '\(password.text ?? "")')"
        if !sqlite.execNoneQuerySQL(sql: register){
            sqlite.closeDB();return
        }
        print("成功注册，用户名为：\(userName.text ?? "")，密码为：\(password.text ?? "")")
        sqlite.closeDB()
        let alertController = UIAlertController(title: "系统提示",message: "注册成功", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            print("点击了确定")
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
