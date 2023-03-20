//
//  HistoryTableViewController.swift
//  BookMall
//
//  Created by xjc on 2022/5/22.
//  Copyright © 2022 venite. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    
    var data = [[String:AnyObject]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){
            return 0;
        }
        let sql = "SELECT DISTINCT id FROM history WHERE user = '\(global.user)'"
        data = sqlite.execQuerySQL(sql: sql)!
        print(data)
        sqlite.closeDB()
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]["id"] as? String
        
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){
            
        }
        let sql = "SELECT * FROM history WHERE id = '\(data[indexPath.row]["id"] as! String)' AND user = '\(global.user)'"
        let d = sqlite.execQuerySQL(sql: sql)!
        sqlite.closeDB()
        
        var money:Float = 0.0
        for row in d{
            let a = Float(row["price"]! as! String) ?? 1.0
            money+=a
            print(money, a)
        }
        
        cell.detailTextLabel?.text = "图书数目：\(d.count), 总价：\(money), 购买时间：\(d[0]["time"] as! String ?? "")"
        cell.detailTextLabel?.numberOfLines = 3
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as! DetailHistoryTableViewController
        
        target.id = data[tableView.indexPathForSelectedRow!.row]["id"]! as! String
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
