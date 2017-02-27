//
//  LoginViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 2/24/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: ViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var inGame : String = ""

    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: UIButton) {
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!) { (user, error) in
                
                if FIRAuth.auth()?.currentUser != nil {
                    // User is signed in.
                    
                    self.ref = FIRDatabase.database().reference()
                    let user = FIRAuth.auth()?.currentUser
                    
                    self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        self.inGame = value?["inGame"] as? String ?? ""
                        print(self.inGame)
                    }) { (error) in
                        print(error.localizedDescription)
                    }

                    
                    let inGame = self.ref.child("users").child((user?.uid)!).child("inGame")

                    if(inGame.isEqual("true")){
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let GVC = storyboard.instantiateViewController(withIdentifier: "GVC")
                        self.present(GVC, animated: true, completion: nil)
                    }
                    else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let MTVC = storyboard.instantiateViewController(withIdentifier: "MTVC")
                        self.present(MTVC, animated: true, completion: nil)
                    }
                    }
                else {
                    let invalidAlert = UIAlertController(title: "Invalid Entry", message: "Sign Up Failed. Email/Password Incorrect.", preferredStyle: UIAlertControllerStyle.alert)
                    invalidAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(invalidAlert, animated: true, completion: nil)
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
