//
//  BookTableViewController.swift
//  BookMall
//
//  Created by xjc on 2022/5/15.
//  Copyright © 2022 venite. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {

    
    var books = [[String:String]]()
    
    var keys = [[String:String]]()
    
    var booksDevided:[[[String:String]]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView?.register(UINib.init(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomBookCell")
        tableView.rowHeight = 200
        
        let sqlite = SQLiteManager.sharedInstance
        let _ = sqlite.openDB()
        books = sqlite.execQuerySQL(sql: "SELECT * FROM books")! as! [[String : String]]
        
        let k = sqlite.execQuerySQL(sql: "SELECT DISTINCT kind FROM books")
        keys = k as! [[String:String]]
        sqlite.closeDB()
        
        var singlekind:[[String:String]] = []
        for kind in keys{
            for book in books{
                if book["kind"] == kind["kind"]{
                    singlekind.append(book)
                }
                
            }
            booksDevided.append(singlekind)
            singlekind = []
        }
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return keys.count
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        booksDevided[section].count
    }

    
    @IBOutlet weak var name: UILabel!
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]["kind"]!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomBookCell", for: indexPath) as! BookTableViewCell
        
        cell.name.text = books[indexPath.row]["title"]
        cell.price.text = books[indexPath.row]["price"]
        
        let imgurl = books[indexPath.row]["pic"]!
        let url : URL = URL.init(string: imgurl)! // 初始化url图片
        let data : NSData! = NSData(contentsOf: url) //转为data类型
        if data != nil {
            cell.img.image = UIImage.init(data: data as Data, scale: 1) //赋值图片
        }
        */
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.text = booksDevided[indexPath.section][indexPath.row]["title"]
        cell.detailTextLabel?.text =  "价格： "+booksDevided[indexPath.section][indexPath.row]["price"]!
        cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        let imgurl = booksDevided[indexPath.section][indexPath.row]["pic"]!
        let url : URL = URL.init(string: imgurl)! // 初始化url图片
        let data : NSData! = NSData(contentsOf: url) //转为data类型
        if data != nil {
            cell.imageView?.image = UIImage.init(data: data as Data, scale: 1) //赋值图片
        }
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as! DetailViewController
        let source = segue.source
        print(source)
        print(target)
        target.list = books[tableView.indexPathForSelectedRow!.row]
    }
}
