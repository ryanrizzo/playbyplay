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
    @IBOutlet weak var powerups: UIImageView!
    @IBOutlet weak var outButton: UIButton!
    @IBOutlet weak var onBaseButton: UIButton!
    @IBOutlet var firstQuestion: [UIButton]!
    
    
    
    var d0 = UIImage(named: "0.png")
    var allpups = UIImage(named: "allpups.png")
    var loadDiamondArray: [UIImage] = [ UIImage(named: "1.png")!, UIImage(named: "2.png")!,UIImage(named: "3.png")!, UIImage(named: "4.png")!,]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        diamond.animationImages = loadDiamondArray;
        diamond.animationDuration = 0.65
        diamond.animationRepeatCount = 1
        
        
        
        powerups.image=allpups
        
        firstQuestion.append(outButton)
        firstQuestion.append(onBaseButton)
    }
    
    
    

    @IBAction func selectedOut(_ sender: UIButton) {
        outButton.backgroundColor = UIColor.yellow
        outButton.titleLabel?.textColor=UIColor.black
    }
    @IBAction func deselectOut(_ sender: UIButton) {
        outButton.backgroundColor = UIColor.darkGray
        outButton.titleLabel?.textColor=UIColor.white
    }

    @IBAction func selectedOnBase(_ sender: UIButton) {
        onBaseButton.backgroundColor = UIColor.yellow
        onBaseButton.titleLabel?.textColor=UIColor.black
    }
    @IBAction func deselectOnBase(_ sender: UIButton) {
        onBaseButton.backgroundColor = UIColor.darkGray
        onBaseButton.titleLabel?.textColor=UIColor.white
    }


    override func viewDidAppear(_ animated: Bool) {
        diamond.startAnimating()
        self.perform(#selector(GameViewController.afterAnimation), with: nil, afterDelay: diamond.animationDuration)
        powerups.startAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func afterAnimation() {
        diamond.stopAnimating()
        diamond.image = d0;
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
