//
//  LeaderboardTableViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 4/26/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardTableViewController: UITableViewController {

    var currentGame : String = ""
    
    var scores : [Int] = []
    var names : [String] = []
    
    var ref: FIRDatabaseReference!
    
    let user = FIRAuth.auth()?.currentUser
    
    struct User { //starting with a structure to hold user data
        //var firebaseKey : String?
        var runs: Int?
        var username: String?
    }

    var userArray = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set currentGame
        
        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let currUserDict = snapshot.value as? NSDictionary
            
            self.currentGame = currUserDict?.value(forKey: "currentGame") as! String

        let query = self.ref.child("games").child(self.currentGame).child("leaderboard").queryOrdered(byChild: "runs")
            
            query.observe(.value, with: { (snapshot) in
                for child in snapshot.value as! [String:AnyObject]{
                    let runs = child.value["runs"] as! Int
                    let username = child.value["username"] as! String
                    let u = User(runs: runs, username: username)
                    
                    self.userArray.append(u)
                    
                    print("\n\n\n\n\n\n\n\n\n\n\nchild:\n",self.userArray)
                }
                self.tableView.reloadData()
            })
            
            
        }) { (error) in
            print(error.localizedDescription)
        }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.userArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let rankings = Array(self.userArray.reversed())

        let x : Int = rankings[indexPath.row].runs!
        
        let runString = String(x)
        
        
        
        if(indexPath.row == 0){
            cell.textLabel?.text = rankings[indexPath.row].username! + "        Runs: " + runString + "         $10"
        }else if(indexPath.row == 1){
            cell.textLabel?.text = rankings[indexPath.row].username! + "        Runs: " + runString + "         $5"
        }else{
            cell.textLabel?.text = rankings[indexPath.row].username! + "        Runs: " + runString + "         $0"
        }
        
        // Configure the cell...

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
