//
//  FirstTutorialViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 6/6/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

class FirstTutorialViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    var inGame : String = ""

    @IBOutlet weak var page: UILabel!
    var ref: FIRDatabaseReference!
    
    var user = FIRAuth.auth()?.currentUser

    
    var index : Int = 0
    
    let imageArray : [UIImage] = [ UIImage(named: "1tut.png")!, UIImage(named: "2tut.png")!, UIImage(named: "3tut.png")!, UIImage(named: "4tut.png")!,UIImage(named: "5tut.png")!, UIImage(named: "6tut.png")!, UIImage(named: "7tut.png")!, UIImage(named: "8tut.png")!, UIImage(named: "9tut.png")!, UIImage(named: "10tut.png")!,]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ref = FIRDatabase.database().reference()
        self.user = FIRAuth.auth()?.currentUser
        
        self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.inGame = (value?["inGame"] as? String)!

            
        }) { (error) in
            print(error.localizedDescription)
        }

        
        image.image = imageArray[index]
        
        updatePage()
        
        
        // Do any additional setup after loading the view.
    }
    
    func updatePage(){
        self.page.text = String(self.index + 1) + " of 10"
    }
    
    @IBAction func skipTutorial(_ sender: UIButton) {

        self.ref.child("users").child((user?.uid)!).child("newUser").setValue("false")
        if(self.inGame == "true"){
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let GVC = storyboard.instantiateViewController(withIdentifier: "GVC")
            self.present(GVC, animated: true, completion: nil)
        }else if(self.inGame == "false"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let MTVC = storyboard.instantiateViewController(withIdentifier: "MTVC")
            let MNC = UINavigationController(rootViewController: MTVC)
            self.present(MNC, animated: true, completion: nil)
        }
        
    }

    @IBAction func nextTut(_ sender: UIButton) {
        if(image.image == imageArray[9]){
            self.ref.child("users").child((user?.uid)!).child("newUser").setValue("false")
            if(self.inGame == "true"){
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let GVC = storyboard.instantiateViewController(withIdentifier: "GVC")
                self.present(GVC, animated: true, completion: nil)
            }else if(self.inGame == "false"){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let MTVC = storyboard.instantiateViewController(withIdentifier: "MTVC")
                let MNC = UINavigationController(rootViewController: MTVC)
                self.present(MNC, animated: true, completion: nil)
            }
        }else{
            self.index += 1
            image.image = imageArray[self.index]
            updatePage()
        }
    }
    @IBAction func prevTut(_ sender: UIButton) {
        if(index>0){
            self.index -= 1
            image.image = imageArray[self.index]
            updatePage()
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
