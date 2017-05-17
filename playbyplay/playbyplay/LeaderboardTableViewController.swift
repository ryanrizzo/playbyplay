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
    
    
    var ref: FIRDatabaseReference!
    
    let user = FIRAuth.auth()?.currentUser
    
    
    var array : [NSDictionary] = []
    
    var stateArray: [UIImage] = [ UIImage(named: "0.png")!, UIImage(named: "1.png")!, UIImage(named: "1+2.png")!,UIImage(named: "13.png")!, UIImage(named: "loaded.png")!, UIImage(named: "2.png")!, UIImage(named: "23.png")!,UIImage(named: "3.png")!,]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set currentGame
        
        self.tableView.backgroundColor = UIColor.darkGray
        
        self.ref = FIRDatabase.database().reference()
        
        self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let currUserDict = snapshot.value as? NSDictionary
            
            self.currentGame = currUserDict?.value(forKey: "currentGame") as! String

        let query = self.ref.child("games").child(self.currentGame).child("leaderboard").queryOrdered(byChild: "runs")
            
            query.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let enumerator = snapshot.children
                self.array = []
                while let rest = enumerator.nextObject() as? FIRDataSnapshot{
                    
                    self.array.append(rest.value as! NSDictionary)
                    
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
        
        return self.array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! LeaderboardTableViewCell
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        
        let rankings = Array(self.array.reversed())
        
        if(indexPath.row < rankings.count){
            let runs : Int = rankings[indexPath.row].value(forKey: "runs") as! Int
            let inn = rankings[indexPath.row].value(forKey: "inning") as! Int
            
            if (rankings[indexPath.row].value(forKey:"pup") as! Int == 1){
                cell.usernameLabel.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
                cell.runsLabel.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
                cell.inningLabel.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
                cell.moneyLabel.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
                cell.innSignifier.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
                cell.rSignifier.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
            }else if (rankings[indexPath.row].value(forKey:"pup") as! Int == 2){
                cell.usernameLabel.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
                cell.runsLabel.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
                cell.inningLabel.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
                cell.moneyLabel.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
                cell.innSignifier.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
                cell.rSignifier.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
            }else if (rankings[indexPath.row].value(forKey:"pup") as! Int == 3){
                cell.usernameLabel.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
                cell.runsLabel.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
                cell.inningLabel.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
                cell.moneyLabel.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
                cell.innSignifier.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
                cell.rSignifier.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
            }
            
            cell.usernameLabel.text = rankings[indexPath.row].value(forKey:"username") as? String
            
            cell.runsLabel.text = String(runs)
            
            cell.inningLabel.text = String(inn)
        
            let state = rankings[indexPath.row].value(forKey: "diamond") as! Int
            
            cell.diamond.image = stateArray[state]
            
            if(indexPath.row == 0){
                 cell.moneyLabel.text = "$10"
            }else if(indexPath.row == 1){
                cell.moneyLabel.text = "$5"
            }else if(indexPath.row < rankings.count){
                cell.moneyLabel.text = "$0"
            }
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
