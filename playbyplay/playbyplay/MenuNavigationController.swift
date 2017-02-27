//
//  MenuNavigationController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 2/27/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit

class MenuNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.yellow]
        
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
