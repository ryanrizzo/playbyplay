//
//  SignupViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 2/24/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: ViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordCheck: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    var ref: FIRDatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    @IBAction func signup(_ sender: UIButton) {
        if(password.text==passwordCheck.text && email.text != "" && username.text != ""){
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!) { (user,error) in

                if FIRAuth.auth()?.currentUser != nil {
                    // User is signed in.
                    print(FIRAuth.auth()?.currentUser?.email)
                    let user = FIRAuth.auth()?.currentUser
                    
                    self.ref.child("users").child((user?.uid)!).child("username").setValue(self.username.text)
                    self.ref.child("users").child((user?.uid)!).child("inGame").setValue("false")
                    
                    
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let MTVC = storyboard.instantiateViewController(withIdentifier: "MTVC")
                        self.present(MTVC, animated: true, completion: nil)
                    
                } else {
                    let invalidAlert = UIAlertController(title: "Invalid Entry", message: "Sign Up Failed. Check if you entered a valid email, otherwise you may have taken a username that already exists.", preferredStyle: UIAlertControllerStyle.alert)
                    invalidAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(invalidAlert, animated: true, completion: nil)
                }
                
                
            }
        }
        else{
            let invalidAlert = UIAlertController(title: "Invalid Entry", message: "One of the text fields is incorrect", preferredStyle: UIAlertControllerStyle.alert)
            invalidAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(invalidAlert, animated: true, completion: nil)
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
