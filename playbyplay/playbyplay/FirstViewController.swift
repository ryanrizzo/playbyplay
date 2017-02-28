//
//  FirstViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 2/20/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: ViewController {

    var inGame : String = ""
    
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //try! FIRAuth.auth()!.signOut()
        
        
        
        if FIRAuth.auth()?.currentUser != nil {
            self.ref = FIRDatabase.database().reference()
            
            
            // User is signed in.
            print(FIRAuth.auth()?.currentUser?.email)
            let user = FIRAuth.auth()?.currentUser
            
            self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                self.inGame = value?["inGame"] as? String ?? ""
                print(self.inGame)
                
                if(self.inGame.isEqual("true")){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let GVC = storyboard.instantiateViewController(withIdentifier: "GVC")
                    
                    self.present(GVC, animated: true, completion: nil)
                }
                    
                else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let MTVC = storyboard.instantiateViewController(withIdentifier: "MTVC")
                    let MNC = UINavigationController(rootViewController: MTVC)
                    self.present(MNC, animated: true, completion: nil)
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }


    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
