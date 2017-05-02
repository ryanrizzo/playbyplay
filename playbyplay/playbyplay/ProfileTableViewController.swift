//
//  ProfileTableViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 5/2/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {

    var ref: FIRDatabaseReference!
    
    let user = FIRAuth.auth()?.currentUser
    /*
    struct User { //starting with a structure to hold user data
        //var firebaseKey : String?
        var username: String?
        var hits: Int?
        var doubles: Int?
        var homers: Int?
        var atbats: Int?
        var avg: String?
        var slg: String?
        var winnings: Int?
        
    }
 */
    
    //let indexArray : [String] = ["username", "atbats", "hits", "doubles", "homers", "avg", "slg", "winnings"]
    
    let labelArray : [String] = ["", "AB", "H", "2B", "HR", "AVG", "SLG", "$"]

    var currUser : [String] = ["","","","","","","",""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let currUserDict = snapshot.value as? NSDictionary
            
            let atbats = currUserDict?.value(forKey: "atbats") as! Int
            let hits = currUserDict?.value(forKey: "hits") as! Int
            let doubles = currUserDict?.value(forKey: "doubles") as! Int
            let homers = currUserDict?.value(forKey: "homers") as! Int
            
            self.currUser[0] = currUserDict?.value(forKey: "username") as! String
            self.currUser[1] = String(atbats)
            self.currUser[2] = String(hits)
            self.currUser[3] = String(doubles)
            self.currUser[4] = String(homers)
            
            var avgD : Double = 0
            var slgD : Double = 0
            
            
            
            if(hits > 0){
                avgD = Double(hits)/Double(atbats)
                slgD = ( Double(hits-doubles-homers) + Double(2*doubles) + Double(4*homers) )/Double(atbats)
                
                avgD = (avgD * 1000).rounded() / 1000
                slgD = (slgD * 1000).rounded() / 1000
                
                
            }

            self.currUser[5] = String(avgD)
            self.currUser[6] = String(slgD)
            
            
            
            let money = currUserDict?.value(forKey: "money") as! Int
            self.currUser[7] = String(money)
            
            
            
            self.tableView.reloadData()
            
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
        return 30
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        
        // Configure the cell...
        if(self.currUser[0] != "" && indexPath.row < self.currUser.count){
            if(indexPath.row == 7){
                cell.textLabel?.text = labelArray[indexPath.row] + self.currUser[indexPath.row]
            }
            else if(indexPath.row == 0){
                cell.textLabel?.text = self.currUser[indexPath.row]
            }
            else{
                cell.textLabel?.text = labelArray[indexPath.row] + ":   " + self.currUser[indexPath.row]
            }
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
