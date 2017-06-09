//
//  MenuTableViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 2/26/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

class MenuTableViewController: UITableViewController {
    var menuItems: [String] = ["Play!", "Leaderboard", "View Profile","View Tutorial", "Log Out"]
    
    var ref: FIRDatabaseReference!
    var inGame : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return self.menuItems.count + 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell..
        if(indexPath.row <= self.menuItems.count-1){
            cell.textLabel?.text = self.menuItems[indexPath.row]
            cell.textLabel?.textColor = UIColor.yellow
            cell.backgroundColor = UIColor.black
        }else{
            cell.textLabel?.text = ""
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.black
        }
        
        
        self.ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        
        self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.inGame = (value?["inGame"] as? String)!
            
            if(indexPath.row == 0 && self.inGame.isEqual("true")){
                cell.textLabel?.text = "Return to Game"
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        

        
        
        
        
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //log out
        if(indexPath.row == 0){
            if(self.inGame == "false"){
                self.performSegue(withIdentifier: "segueToGames", sender: self)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let GVC = storyboard.instantiateViewController(withIdentifier: "GVC")
                self.present(GVC, animated: true, completion: nil)
            }
        }else if(indexPath.row == 3){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let FTVC = storyboard.instantiateViewController(withIdentifier: "FTVC")
            self.present(FTVC, animated: true, completion: nil)
            
        } else if(indexPath.row == 4){
            
            let logoutAlert = UIAlertController(title: "Are you sure you want to log out?", message: "You will be taken back to the Log In/Sign Up page.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertActionStyle.default) { (action) in
                
            }
            let logoutAction = UIAlertAction(
            title: "Log Out", style: UIAlertActionStyle.default) { (action) in
                let user = FIRAuth.auth()
                do{
                    try user?.signOut()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let FVC = storyboard.instantiateViewController(withIdentifier: "FVC")
                    self.present(FVC, animated: true, completion: nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }

            }
            logoutAlert.addAction(cancelAction)
            logoutAlert.addAction(logoutAction)
            self.present(logoutAlert, animated:true)
            
                    } else if(indexPath.row == 1 && self.inGame == "true"){
            self.performSegue(withIdentifier: "segueToLeaderboard", sender: self)
        } else if(indexPath.row == 2){
            self.performSegue(withIdentifier: "segueToProfile", sender: self)
        }
        
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
