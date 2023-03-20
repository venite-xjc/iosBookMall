//
//  DetailHistoryTableViewController.swift
//  BookMall
//
//  Created by xjc on 2022/5/22.
//  Copyright © 2022 venite. All rights reserved.
//

import UIKit

class DetailHistoryTableViewController: UITableViewController {

    var id:String = ""
    
    var booklist = [[String: AnyObject]]()
    
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
            
        }
        let sql = "SELECT title FROM history WHERE id = '\(id)'"
        booklist = sqlite.execQuerySQL(sql: sql)!
        sqlite.closeDB()
        return booklist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath)

        cell.textLabel?.text = booklist[indexPath.row]["title"]! as? String
        cell.textLabel?.numberOfLines = 3
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as! DetailViewController
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB(){
            
        }
        let sql = "SELECT * FROM books WHERE title = '\(booklist[tableView.indexPathForSelectedRow!.row]["title"] as! String )'"
        target.list = sqlite.execQuerySQL(sql: sql)![0] as! [String:String]
        sqlite.closeDB()
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
