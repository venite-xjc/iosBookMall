//
//  CartViewController.swift
//  BookMall
//
//  Created by xjc on 2022/5/20.
//  Copyright © 2022 venite. All rights reserved.
//

import UIKit

class CartViewController: UIViewController ,UITableViewDataSource{
    
    var list = [[String:AnyObject]]()
    static var count:Int = 0
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
        table.reloadData()
        let nav = tabBarController?.viewControllers![1] as! UINavigationController
        CartViewController.count = 0
        nav.tabBarItem!.badgeValue = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.textLabel?.text = list[indexPath.row]["title"] as? String
        cell.detailTextLabel?.text = list[indexPath.row]["price"] as? String
        return cell
        }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let sqlite = SQLiteManager.sharedInstance
            if !sqlite.openDB(){
                return
            }
            let sql = "DELETE FROM items WHERE id = \(list[indexPath.row]["id"]!)"
            if !sqlite.execNoneQuerySQL(sql: sql){
                sqlite.closeDB();print("删除失败");return
            }
            else{
                print("删除成功")
            }
            sqlite.closeDB()
            
            list.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func load(){
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){return}
        
        let sql = "SELECT * FROM items WHERE user='\(global.user)'"
        list = sqlite.execQuerySQL(sql: sql)! as [[String : AnyObject]]
        print(list)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func pay(_ sender: Any) {
        let alertController = UIAlertController(title: "确认要支付吗",message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {_ in
            self.performSegue(withIdentifier: "successfullyPay", sender: nil)
        })
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title:"取消", style: .cancel, handler: {_ in print("")})
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as! FinishPayViewController
        target.list = list
        
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){
            return
        }
        let sql = "DELETE FROM items"
        if !sqlite.execNoneQuerySQL(sql: sql){
            sqlite.closeDB();print("删除失败");return
        }
        
        sqlite.closeDB()
    }
}
