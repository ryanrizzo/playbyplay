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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //try! FIRAuth.auth()!.signOut()
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                
                // User is signed in. Show home screen
                print(user?.email)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let GVC = storyboard.instantiateViewController(withIdentifier: "GVC")
                self.present(GVC, animated: true, completion: nil)

            } else {
                // No User is signed in. Show user the login screen
            }
        }
        
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
