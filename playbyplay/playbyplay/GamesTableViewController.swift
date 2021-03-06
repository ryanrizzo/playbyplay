//
//  GamesTableViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 2/27/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

class GamesTableViewController: UITableViewController {

    var ref: FIRDatabaseReference!
    var games : [String] = []
    var gameID : String = ""
    
    let rand = Int(arc4random_uniform(9))
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("games").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.games = []
            for game in (value?.allKeys)!{
                
                self.games.append(game as! String)
                
            }
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
        
     
    

        
        return self.games.count + 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
                // Configure the cell...
        if(indexPath.row < self.games.count){
            let str = self.games[indexPath.row]
            let index = str.index(str.startIndex, offsetBy: 3)
            let awayTeam = str.substring(to: index)
            
            let homeTeam = str.substring(from: index)
            cell.textLabel?.text = awayTeam + " @ " + homeTeam
        }
        
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = FIRAuth.auth()?.currentUser
        if(indexPath.row < self.games.count){
        self.ref.child("games").child(self.games[indexPath.row]).observeSingleEvent(of: .value, with: {(snapshot) in
            
                let value = snapshot.value as? NSDictionary
                self.gameID = value?["gameID"] as? String ?? ""
                print(self.gameID)
                
                self.ref.child("users").child((user?.uid)!).child("gameID").setValue(self.gameID)
                self.ref.child("users").child((user?.uid)!).child("inGame").setValue("true")
                self.ref.child("users").child((user?.uid)!).child("score").setValue(0)
                self.ref.child("users").child((user?.uid)!).child("money").setValue(0)
                self.ref.child("users").child((user?.uid)!).child("currentGame").setValue(self.games[indexPath.row])
            
            
            self.ref.child("games").child(self.games[indexPath.row]).child("leaderboard").child((user?.uid)!).child("runs").setValue(0)
            
            self.ref.child("games").child(self.games[indexPath.row]).child("leaderboard").child((user?.uid)!).child("outs").setValue(0)
            
            self.ref.child("games").child(self.games[indexPath.row]).child("leaderboard").child((user?.uid)!).child("diamond").setValue(0)
            
            self.ref.child("games").child(self.games[indexPath.row]).child("leaderboard").child((user?.uid)!).child("lastPick").setValue("")
            
            self.ref.child("games").child(self.games[indexPath.row]).child("leaderboard").child((user?.uid)!).child("inning").setValue(1)
            
            self.ref.child("games").child(self.games[indexPath.row]).child("leaderboard").child((user?.uid)!).child("hiscore").setValue(0)
            
            self.ref.child("games").child(self.games[indexPath.row]).child("leaderboard").child((user?.uid)!).child("pup").setValue(self.rand)
            
            self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: {(snapshot) in
                
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? ""
                
                self.ref.child("games").child(self.games[indexPath.row]).child("leaderboard").child((user?.uid)!).child("username").setValue(username)
                
            })
            

            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let GVC = storyboard.instantiateViewController(withIdentifier: "GVC")
            self.present(GVC, animated: true, completion: nil)
            
        }) { (error) in
            print(error.localizedDescription)
        }

        
        
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
