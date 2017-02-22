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
    
    
    var d0 = UIImage(named: "0.png")
    var allpups = UIImage(named: "allpups.png")
    var loadDiamondArray: [UIImage] = [ UIImage(named: "1.png")!, UIImage(named: "2.png")!,UIImage(named: "3.png")!, UIImage(named: "4.png")!,]
    
    let singleButton = UIButton()
    let nonSingleButton = UIButton()
    let airoutButton = UIButton()
    let groundoutKButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        diamond.animationImages = loadDiamondArray;
        diamond.animationDuration = 0.65
        diamond.animationRepeatCount = 1
        
        
        
        powerups.image=allpups

    }

    @IBAction func outSelected(_ sender: Any) {
        if(!outButton.isSelected){
            outButton.isSelected = true
            outButton.backgroundColor=UIColor.yellow
            showSecondQsForOut()
        }else{
            outButton.isSelected = false
            outButton.backgroundColor=UIColor.darkGray
            hideSecondQsForOut()
        }
        if(onBaseButton.isSelected){
            onBaseButton.isSelected = false
            onBaseButton.backgroundColor=UIColor.darkGray
            hideSecondQsForOnBase()
        }
    }
    @IBAction func onBaseSelected(_ sender: Any) {
            if(!onBaseButton.isSelected){
                onBaseButton.isSelected = true
                onBaseButton.backgroundColor=UIColor.yellow
                showSecondQsForOnBase()
            }else{
                onBaseButton.isSelected = false
                onBaseButton.backgroundColor=UIColor.darkGray
                hideSecondQsForOnBase()
            }
        if(outButton.isSelected){
            outButton.isSelected = false
            outButton.backgroundColor=UIColor.darkGray
            hideSecondQsForOut()
        }
        
    }
    
    func showSecondQsForOnBase(){
        if(singleButton.isHidden || nonSingleButton.isHidden){
            singleButton.isHidden = false
            nonSingleButton.isHidden = false
        }else{
            initiateSingleButton()
            initiateNonSingleButton()
        }
    }
    func hideSecondQsForOnBase(){
        singleButton.isHidden=true
        nonSingleButton.isHidden=true
    }
    
    func initiateSingleButton(){
        singleButton.setTitle("SINGLE", for: .normal)
        singleButton.setTitle("SINGLE", for: .highlighted)
        singleButton.setTitle("SINGLE", for: .selected)
        singleButton.titleLabel?.font = UIFont.init(name: "AvenirNext-Bold", size: 17)
        singleButton.setTitleColor(UIColor.white, for: .normal)
        singleButton.setTitleColor(UIColor.black, for: .highlighted)
        singleButton.setTitleColor(UIColor.black, for: .selected)
        singleButton.backgroundColor = UIColor.darkGray
        singleButton.frame = CGRect(x: 16, y: 507, width: 164, height:40)
        singleButton.addTarget(self, action: #selector(GameViewController.singleSelected(_:)), for: .touchUpInside)
        self.view.addSubview(singleButton)
        
    }
    
    func singleSelected(_ sender: UIButton){
        if(!singleButton.isSelected){
            singleButton.isSelected = true
            singleButton.backgroundColor=UIColor.yellow
            //showThirdQsForSingle()
        }else{
            singleButton.isSelected = false
            singleButton.backgroundColor=UIColor.darkGray
        }
        if(nonSingleButton.isSelected){
            nonSingleButton.isSelected = false
            nonSingleButton.backgroundColor=UIColor.darkGray
        }
    }
    
    func initiateNonSingleButton(){
        nonSingleButton.setTitle("NON-SINGLE", for: .normal)
        nonSingleButton.setTitle("NON-SINGLE", for: .highlighted)
        nonSingleButton.setTitle("NON-SINGLE", for: .selected)
        nonSingleButton.titleLabel?.font = UIFont.init(name: "AvenirNext-Bold", size: 17)
        nonSingleButton.setTitleColor(UIColor.white, for: .normal)
        nonSingleButton.setTitleColor(UIColor.black, for: .highlighted)
        nonSingleButton.setTitleColor(UIColor.black, for: .selected)
        nonSingleButton.backgroundColor = UIColor.darkGray
        nonSingleButton.frame = CGRect(x: 198, y: 507, width: 164, height:40)
        nonSingleButton.addTarget(self, action: #selector(GameViewController.nonSingleSelected(_:)), for: .touchUpInside)
        self.view.addSubview(nonSingleButton)
    }
    
    func nonSingleSelected(_ sender: UIButton){
        if(!nonSingleButton.isSelected){
            nonSingleButton.isSelected = true
            nonSingleButton.backgroundColor=UIColor.yellow
            //showThirdQsForNonSingle()
        }else{
            nonSingleButton.isSelected = false
            nonSingleButton.backgroundColor=UIColor.darkGray
        }
        if(singleButton.isSelected){
            singleButton.isSelected = false
            singleButton.backgroundColor=UIColor.darkGray
        }
    }
    
    func showSecondQsForOut(){
        if(airoutButton.isHidden || groundoutKButton.isHidden){
            airoutButton.isHidden = false
            groundoutKButton.isHidden = false
        }else{
            initiateAiroutButton()
            initiateGroundoutKButton()
        }

    }
    
    func initiateAiroutButton(){
        airoutButton.setTitle("AIR OUT", for: .normal)
        airoutButton.setTitle("AIR OUT", for: .highlighted)
        airoutButton.setTitle("AIR OUT", for: .selected)
        airoutButton.titleLabel?.font = UIFont.init(name: "AvenirNext-Bold", size: 17)
        airoutButton.setTitleColor(UIColor.white, for: .normal)
        airoutButton.setTitleColor(UIColor.black, for: .highlighted)
        airoutButton.setTitleColor(UIColor.black, for: .selected)
        airoutButton.backgroundColor = UIColor.darkGray
        airoutButton.frame = CGRect(x: 16, y: 507, width: 164, height:40)
        airoutButton.addTarget(self, action: #selector(GameViewController.airoutSelected(_:)), for: .touchUpInside)
        self.view.addSubview(airoutButton)
    }
    
    func initiateGroundoutKButton(){
        groundoutKButton.setTitle("K or GROUNDOUT", for: .normal)
        groundoutKButton.setTitle("K or GROUNDOUT", for: .highlighted)
        groundoutKButton.setTitle("K or GROUNDOUT", for: .selected)
        groundoutKButton.titleLabel?.font = UIFont.init(name: "AvenirNext-Bold", size: 17)
        groundoutKButton.setTitleColor(UIColor.white, for: .normal)
        groundoutKButton.setTitleColor(UIColor.black, for: .highlighted)
        groundoutKButton.setTitleColor(UIColor.black, for: .selected)
        groundoutKButton.backgroundColor = UIColor.darkGray
        groundoutKButton.frame = CGRect(x: 198, y: 507, width: 164, height:40)
        groundoutKButton.addTarget(self, action: #selector(GameViewController.groundoutKSelected(_:)), for: .touchUpInside)
        self.view.addSubview(groundoutKButton)

    }
    
    func hideSecondQsForOut(){
        airoutButton.isHidden = true
        groundoutKButton.isHidden = true
    }

    func airoutSelected(_ sender: UIButton){
        if(!airoutButton.isSelected){
            airoutButton.isSelected = true
            airoutButton.backgroundColor=UIColor.yellow
            //showThirdQsForAirout()
        }else{
            airoutButton.isSelected = false
            airoutButton.backgroundColor=UIColor.darkGray
        }
        if(groundoutKButton.isSelected){
            groundoutKButton.isSelected = false
            groundoutKButton.backgroundColor=UIColor.darkGray
        }
    }
    
    func groundoutKSelected(_ sender: UIButton){
        if(!groundoutKButton.isSelected){
            groundoutKButton.isSelected = true
            groundoutKButton.backgroundColor=UIColor.yellow
            //showThirdQsForGroundoutK()
        }else{
            groundoutKButton.isSelected = false
            groundoutKButton.backgroundColor=UIColor.darkGray
        }
        if(airoutButton.isSelected){
            airoutButton.isSelected = false
            airoutButton.backgroundColor=UIColor.darkGray
        }
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
