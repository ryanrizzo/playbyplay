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
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //initiates all user values at necessary values
    @IBAction func signup(_ sender: UIButton) {
        if(password.text==passwordCheck.text && email.text != "" && username.text != ""){
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!) { (user,error) in

                if FIRAuth.auth()?.currentUser != nil {
                    // User is signed in.
                    print(FIRAuth.auth()?.currentUser?.email)
                    let user = FIRAuth.auth()?.currentUser
                    
                    self.ref.child("users").child((user?.uid)!).child("username").setValue(self.username.text)
                    self.ref.child("users").child((user?.uid)!).child("inGame").setValue("false")
                    
                    self.ref.child("users").child((user?.uid)!).child("hits").setValue(0)
                    self.ref.child("users").child((user?.uid)!).child("atbats").setValue(0)
                    self.ref.child("users").child((user?.uid)!).child("doubles").setValue(0)
                    self.ref.child("users").child((user?.uid)!).child("homers").setValue(0)
                    self.ref.child("users").child((user?.uid)!).child("money").setValue(0)
                    self.ref.child("users").child((user?.uid)!).child("hiscore").setValue(0)
                    
                    self.ref.child("users").child((user?.uid)!).child("runner").setValue("false")
                    self.ref.child("users").child((user?.uid)!).child("newUser").setValue("true")

                    self.defaults.set("", forKey: "1")
                    self.defaults.set(self.defaults.value(forKey: "1") , forKey: "10")
                    self.defaults.set(self.defaults.value(forKey: "1") , forKey: "9")
                    self.defaults.set(self.defaults.value(forKey: "1") , forKey: "8")
                    self.defaults.set(self.defaults.value(forKey: "1") , forKey: "7")
                    self.defaults.set(self.defaults.value(forKey: "1") , forKey: "6")
                    self.defaults.set(self.defaults.value(forKey: "1") , forKey: "5")
                    self.defaults.set(self.defaults.value(forKey: "1") , forKey: "4")
                    self.defaults.set(self.defaults.value(forKey: "1") , forKey: "3")
                    self.defaults.set(self.defaults.value(forKey: "1") , forKey: "2")
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let MTVC = storyboard.instantiateViewController(withIdentifier: "MTVC")
                    let MNC = UINavigationController(rootViewController: MTVC)
                    self.present(MNC, animated: true, completion: nil)
                    
                } else {
                    let invalidAlert = UIAlertController(title: "Invalid Entry", message: "Sign Up Failed. Password must be 6 characters. Also make sure your email is a valid address.", preferredStyle: UIAlertControllerStyle.alert)
                    invalidAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(invalidAlert, animated: true, completion: nil)
                }
                
                
            }
        }
        else if(password.text != passwordCheck.text){
            let invalidAlert = UIAlertController(title: "Invalid Entry", message: "Your two password entries do not match", preferredStyle: UIAlertControllerStyle.alert)
            invalidAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(invalidAlert, animated: true, completion: nil)
        }else{
            let invalidAlert = UIAlertController(title: "Invalid Entry", message: "You either entered an incorrect email, or that email already has an account.", preferredStyle: UIAlertControllerStyle.alert)
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
