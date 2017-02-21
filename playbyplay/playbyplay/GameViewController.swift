//
//  GameViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 2/20/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit

class GameViewController: ViewController {
    @IBOutlet weak var leaderboard: UITextView!
    @IBOutlet weak var last10: UITextView!
    @IBOutlet weak var diamond: UIImageView!

    var d0 = UIImage(named: "0.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        diamond.startAnimating()
        diamond.image=d0
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
