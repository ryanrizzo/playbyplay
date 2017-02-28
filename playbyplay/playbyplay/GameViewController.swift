//
//  GameViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 2/20/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

class GameViewController: ViewController {
    @IBOutlet weak var leaderboard: UITextView!
    @IBOutlet weak var last10: UITextView!
    @IBOutlet weak var diamond: UIImageView!
    @IBOutlet weak var powerups: UIImageView!

    @IBOutlet weak var groundoutButton: UIButton!
    @IBOutlet weak var airoutKButton: UIButton!
    @IBOutlet weak var onBaseButton: UIButton!
    
    @IBOutlet weak var menuButton: UIButton!
    
    var ref: FIRDatabaseReference!
    
    var playCount : Int = 1
    
    var lastPick: String = ""
    
    var currentGame: String = ""
    
    var lastPlay : String = ""
    
    var resultHistory = [String]()
    
    var d0 = UIImage(named: "0.png")
    var allpups = UIImage(named: "allpups.png")
    var loadDiamondArray: [UIImage] = [ UIImage(named: "1.png")!, UIImage(named: "2.png")!,UIImage(named: "3.png")!, UIImage(named: "4.png")!,]
    
    var loadPupArray: [UIImage] = [ UIImage(named: "nopups.png")!, UIImage(named: "1pups.png")!,UIImage(named: "12pups.png")!, UIImage(named: "allpups.png")!,]
    
    let singleButton = UIButton()
    let nonSingleButton = UIButton()
    
    let airoutButton = UIButton()
    let kButton = UIButton()
    
    let kLookingButton = UIButton()
    let kSwingingButton = UIButton()
    
    let groundSingleButton = UIButton()
    let airSingleButton = UIButton()
    
    let doubleButton = UIButton()
    let tripleHomerButton = UIButton()
    
    let overLButton = UIButton()
    let underLButton = UIButton()
    
    let overRButton = UIButton()
    let underRButton = UIButton()
    
    let rightSideButton = UIButton()
    let leftSideButton = UIButton()
    
    let lfrfButton = UIButton()
    let cfButton = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        
            //set currentGame
            self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let currUserDict = snapshot.value as? NSDictionary
            
            self.currentGame = currUserDict?.value(forKey: "currentGame") as! String
            
                //listen for new plays
                self.ref.child("games").child(self.currentGame).observe(.value, with: { (snapshot) in
                    let gameDict = snapshot.value as? NSDictionary
                    
                    self.lastPlay = gameDict?.value(forKey: "lastPlay") as! String
                    self.gradePlay()
                    self.lastPick = ""
                    self.last10.text = "Your last 10:\n"+self.resultHistory.joined(separator: "\n")
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            
            }) { (error) in
            print(error.localizedDescription)
            }
        

        

        

        
        
        
        
        // Do any additional setup after loading the view.
        diamond.animationImages = loadDiamondArray;
        diamond.animationDuration = 0.65
        diamond.animationRepeatCount = 1
        
        
        
        powerups.animationImages = loadPupArray
        powerups.animationDuration = 0.65
        powerups.animationRepeatCount = 1

    }
    
    func gradePlay(){
        let allButtons: [UIButton] = [groundoutButton, airoutKButton, onBaseButton, leftSideButton,rightSideButton,airoutButton,kButton, singleButton,nonSingleButton,overLButton,underLButton,overRButton,underRButton, lfrfButton, cfButton, kSwingingButton, kLookingButton, groundSingleButton, airSingleButton, doubleButton,tripleHomerButton]
        
        if(lastPick == self.lastPlay){
            for button in allButtons{
                if(!button.isHidden){
                    button.backgroundColor = UIColor.green
                }
                //add to stats
            }
            
            self.resultHistory.append("Hit")
            self.playCount += 1
            
        }else if(lastPick == "none yet" || last10.text == "Your last 10:"){
            
        }
        else{
            for button in allButtons{
                if(!button.isHidden){
                    button.backgroundColor = UIColor.red
                }
            }
            self.resultHistory.append("Out")
            self.playCount += 1
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
        powerups.stopAnimating()
        diamond.image = d0;
        powerups.image = allpups;
    }
    @IBAction func menuSelected(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MTVC = storyboard.instantiateViewController(withIdentifier: "MTVC")
        let MNC = UINavigationController(rootViewController: MTVC)
        self.present(MNC, animated: true, completion: nil)
    }

    @IBAction func groundoutSelected(_ sender: Any) {
    
        if(!groundoutButton.isSelected){
            groundoutButton.isSelected = true
            groundoutButton.backgroundColor=UIColor.yellow
            showSecondQsForGroundout()
        }else{
            groundoutButton.isSelected = false
            groundoutButton.backgroundColor=UIColor.darkGray
            hideSecondQsForGroundout()
        }
        if(onBaseButton.isSelected){
            onBaseButton.isSelected = false
            onBaseButton.backgroundColor=UIColor.darkGray
            hideSecondQsForOnBase()
            
        }else if(airoutKButton.isSelected){
            airoutKButton.isSelected = false
            airoutKButton.backgroundColor=UIColor.darkGray
            hideSecondQsForAiroutK()
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
        if(groundoutButton.isSelected){
            groundoutButton.isSelected = false
            groundoutButton.backgroundColor=UIColor.darkGray
            hideSecondQsForGroundout()
        }else if(airoutKButton.isSelected){
            airoutKButton.isSelected = false
            airoutKButton.backgroundColor=UIColor.darkGray
            hideSecondQsForAiroutK()
        }
        
    }
    
    @IBAction func airoutKSelected(_ sender: Any) {
        if(!airoutKButton.isSelected){
            airoutKButton.isSelected = true
            airoutKButton.backgroundColor=UIColor.yellow
            showSecondQsForAiroutK()
        }else{
            airoutKButton.isSelected = false
            airoutKButton.backgroundColor=UIColor.darkGray
            hideSecondQsForAiroutK()
        }
        if(groundoutButton.isSelected){
            groundoutButton.isSelected = false
            groundoutButton.backgroundColor=UIColor.darkGray
            hideSecondQsForGroundout()
        }else if(onBaseButton.isSelected){
            onBaseButton.isSelected = false
            onBaseButton.backgroundColor=UIColor.darkGray
            hideSecondQsForOnBase()
        }

    }
    
    
    func initiateButton(event: String, button: UIButton, action:Selector, spot: Int){
        button.setTitle(event, for: .normal)
        button.setTitle(event, for: .highlighted)
        button.setTitle(event, for: .selected)
        button.titleLabel?.font = UIFont.init(name: "AvenirNext-Bold", size: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.black, for: .highlighted)
        button.setTitleColor(UIColor.black, for: .selected)
        button.backgroundColor = UIColor.darkGray
        if(spot == 1){
            button.frame = CGRect(x: 25, y: 526, width: 150, height:57)
        }else if(spot == 2){
            button.frame = CGRect(x: 205, y: 526, width: 150, height:57)
        }
        
        button.addTarget(self, action: action, for: .touchUpInside)
        button.isSelected = false;
        self.view.addSubview(button)
    }
    
    func initiateButtonRow3(event: String, button: UIButton, action:Selector, spot: Int){
        button.setTitle(event, for: .normal)
        button.setTitle(event, for: .highlighted)
        button.setTitle(event, for: .selected)
        button.titleLabel?.font = UIFont.init(name: "AvenirNext-Bold", size: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.black, for: .highlighted)
        button.setTitleColor(UIColor.black, for: .selected)
        button.backgroundColor = UIColor.darkGray
        if(spot == 1){
            button.frame = CGRect(x: 25, y: 604, width: 150, height:57)
        }else if(spot == 2){
            button.frame = CGRect(x: 205, y: 604, width: 150, height:57)
        }
        
        button.addTarget(self, action: action, for: .touchUpInside)
        button.isSelected = false;
        self.view.addSubview(button)
    }

    
        // On Base ************************************************************
    
    func showSecondQsForOnBase(){
        if(singleButton.isHidden || nonSingleButton.isHidden){
            singleButton.isHidden = false
            nonSingleButton.isHidden = false
            if(singleButton.isSelected){
                showThirdQsForSingle()
            }
            if(nonSingleButton.isSelected){
                showThirdQsForNonSingle()
            }
        }else{
            initiateButton(event: "Single",button: singleButton, action: #selector(GameViewController.singleSelected(_:)), spot: 1)
            initiateButton(event: "Non-Single",button: nonSingleButton, action: #selector(GameViewController.nonSingleSelected(_:)), spot: 2)
        }
    }
    
    func hideSecondQsForOnBase(){
        singleButton.isHidden=true
        nonSingleButton.isHidden=true
        
        //hides only the buttons that have been created
        if(singleButton.isSelected){
            hideThirdQsForSingle()
        }
        if(nonSingleButton.isSelected){
            hideThirdQsForNonSingle()
        }
    }
    
    func singleSelected(_ sender: UIButton){
        if(!singleButton.isSelected){
            singleButton.isSelected = true
            singleButton.backgroundColor=UIColor.yellow
            showThirdQsForSingle()
        }else{
            singleButton.isSelected = false
            singleButton.backgroundColor=UIColor.darkGray
            hideThirdQsForSingle()
        }
        if(nonSingleButton.isSelected){
            nonSingleButton.isSelected = false
            nonSingleButton.backgroundColor=UIColor.darkGray
            hideThirdQsForNonSingle()
        }
    }
    
    func nonSingleSelected(_ sender: UIButton){
        if(!nonSingleButton.isSelected){
            nonSingleButton.isSelected = true
            nonSingleButton.backgroundColor=UIColor.yellow
            showThirdQsForNonSingle()
        }else{
            nonSingleButton.isSelected = false
            nonSingleButton.backgroundColor=UIColor.darkGray
            hideThirdQsForNonSingle()
        }
        if(singleButton.isSelected){
            singleButton.isSelected = false
            singleButton.backgroundColor=UIColor.darkGray
            hideThirdQsForSingle()
        }
    }
    
        // THIRD ROW ON BASE ***************************
    
    func showThirdQsForSingle(){
        if(groundSingleButton.isHidden || airSingleButton.isHidden){
            groundSingleButton.isHidden = false
            airSingleButton.isHidden = false
        }else{
            
            initiateButtonRow3(event: "Ground Single",button: groundSingleButton, action: #selector(GameViewController.groundSingleSelected(_:)), spot: 1)
            initiateButtonRow3(event: "Air Single",button: airSingleButton, action: #selector(GameViewController.airSingleSelected(_:)), spot: 2)
        }
    }
    
    func hideThirdQsForSingle(){
        groundSingleButton.isHidden=true
        airSingleButton.isHidden=true
    }
    
    func showThirdQsForNonSingle(){
        if(doubleButton.isHidden || tripleHomerButton.isHidden){
            doubleButton.isHidden = false
            tripleHomerButton.isHidden = false
        }else{
            
            initiateButtonRow3(event: "Double",button: doubleButton, action: #selector(GameViewController.doubleSelected(_:)), spot: 1)
            initiateButtonRow3(event: "Home Run/3B/BB",button: tripleHomerButton, action: #selector(GameViewController.tripleHomerSelected(_:)), spot: 2)
        }
    }
    
    func hideThirdQsForNonSingle(){
        doubleButton.isHidden=true
        tripleHomerButton.isHidden=true
    }
    
    func updateButtons(mainButton: UIButton, otherButton: UIButton){
        if(!mainButton.isSelected){
            mainButton.isSelected = true
            mainButton.backgroundColor=UIColor.yellow
        }else{
            mainButton.isSelected = false
            mainButton.backgroundColor=UIColor.darkGray
        }
        if(otherButton.isSelected){
            otherButton.isSelected = false
            otherButton.backgroundColor=UIColor.darkGray
        }
    }
    
    func doubleSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: doubleButton, otherButton: tripleHomerButton)
        hideNonSelected()
        lastPick = "double"
    }
    func tripleHomerSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: tripleHomerButton, otherButton: doubleButton)
        hideNonSelected()
        lastPick = "triplehomer"
    }
    func airSingleSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: airSingleButton, otherButton: groundSingleButton)
        hideNonSelected()
        lastPick = "airsingle"
    }
    func groundSingleSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: groundSingleButton, otherButton: airSingleButton)
        hideNonSelected()
        lastPick = "groundsingle"
    }
    
    // Airout/K ************************************************************
    
    func showSecondQsForAiroutK(){
        if(airoutButton.isHidden || kButton.isHidden){
            airoutButton.isHidden = false
            kButton.isHidden = false
            if(airoutButton.isSelected){
                showThirdQsForAirout()
            }
            if(kButton.isSelected){
                showThirdQsForK()
            }
        }else{
            initiateButton(event: "Air Out", button: airoutButton, action: #selector(GameViewController.airoutSelected(_:)), spot: 1)
            initiateButton(event: "Strikeout", button: kButton, action: #selector(GameViewController.kSelected(_:)), spot: 2)
        }

    }
    
    func hideSecondQsForAiroutK(){
        airoutButton.isHidden = true
        kButton.isHidden = true
        //hides only the buttons that have been created
        if(airoutButton.isSelected){
            hideThirdQsForAirout()
        }
        if(kButton.isSelected){
            hideThirdQsForK()
        }
    }

    func airoutSelected(_ sender: UIButton){
        if(!airoutButton.isSelected){
            airoutButton.isSelected = true
            airoutButton.backgroundColor=UIColor.yellow
            showThirdQsForAirout()
        }else{
            airoutButton.isSelected = false
            airoutButton.backgroundColor=UIColor.darkGray
            hideThirdQsForAirout()
        }
        if(kButton.isSelected){
            kButton.isSelected = false
            kButton.backgroundColor=UIColor.darkGray
            hideThirdQsForK()
        }
    }
    
    func kSelected(_ sender: UIButton){
        if(!kButton.isSelected){
            kButton.isSelected = true
            kButton.backgroundColor=UIColor.yellow
            showThirdQsForK()
        }else{
            kButton.isSelected = false
            kButton.backgroundColor=UIColor.darkGray
            hideThirdQsForK()
        }
        if(airoutButton.isSelected){
            airoutButton.isSelected = false
            airoutButton.backgroundColor=UIColor.darkGray
            hideThirdQsForAirout()
        }
    }
    // THIRD ROW Airout K ***************************
    
    func showThirdQsForAirout(){
        if(lfrfButton.isHidden || cfButton.isHidden){
            lfrfButton.isHidden = false
            cfButton.isHidden = false
        }else{
            initiateButtonRow3(event: "LF or RF",button: lfrfButton, action: #selector(GameViewController.lfrfSelected(_:)), spot: 1)
            initiateButtonRow3(event: "CF/Other",button: cfButton, action: #selector(GameViewController.cfSelected(_:)), spot: 2)
        }
    }
    
    func hideThirdQsForAirout(){
        lfrfButton.isHidden=true
        cfButton.isHidden=true
    }
    
    func showThirdQsForK(){
        if(kSwingingButton.isHidden || kLookingButton.isHidden){
            kSwingingButton.isHidden = false
            kLookingButton.isHidden = false
        }else{
            
            initiateButtonRow3(event: "K Swinging",button: kSwingingButton, action: #selector(GameViewController.kSwingingSelected(_:)), spot: 1)
            initiateButtonRow3(event: "K Looking",button: kLookingButton, action: #selector(GameViewController.kLookingSelected(_:)), spot: 2)
        }
    }
    
    func hideThirdQsForK(){
        kSwingingButton.isHidden=true
        kLookingButton.isHidden=true
    }
    
    func lfrfSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: lfrfButton, otherButton: cfButton)
        hideNonSelected()
        lastPick = "lfrf"
    }
    func cfSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: cfButton, otherButton: lfrfButton)
        hideNonSelected()
        lastPick = "cf"
    }
    func kSwingingSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: kSwingingButton, otherButton: kLookingButton)
        hideNonSelected()
        lastPick = "kSwinging"
    }
    func kLookingSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: kLookingButton, otherButton: kSwingingButton)
        hideNonSelected()
        lastPick = "kLooking"
    }

    
    // Groundout ************************************************************
    
    func showSecondQsForGroundout(){
        if(leftSideButton.isHidden || rightSideButton.isHidden){
            leftSideButton.isHidden = false
            rightSideButton.isHidden = false
            
            if(leftSideButton.isSelected){
                showThirdQsForLeftSide()
            }
            if(rightSideButton.isSelected){
                showThirdQsForRighttSide()
            }
        
        }else{
            initiateButton(event: "Left Side", button: leftSideButton, action: #selector(GameViewController.leftSideSelected(_:)), spot: 1)
            initiateButton(event: "Right Side", button: rightSideButton, action: #selector(GameViewController.rightSideSelected(_:)), spot: 2)
        }
    }
    
    
    func hideSecondQsForGroundout(){
        leftSideButton.isHidden=true
        rightSideButton.isHidden=true
        
        //hides only the buttons that have been created
        if(leftSideButton.isSelected){
            hideThirdQsForLeftSide()
        }
        if(rightSideButton.isSelected){
            hideThirdQsForRightSide()
        }
        
    }
    
    func leftSideSelected(_ sender: UIButton){
        if(!leftSideButton.isSelected){
            leftSideButton.isSelected = true
            leftSideButton.backgroundColor=UIColor.yellow
            showThirdQsForLeftSide()
        }else{
            leftSideButton.isSelected = false
            leftSideButton.backgroundColor=UIColor.darkGray
            hideThirdQsForLeftSide()
        }
        if(rightSideButton.isSelected){
            rightSideButton.isSelected = false
            rightSideButton.backgroundColor=UIColor.darkGray
            hideThirdQsForRightSide()
        }
    }
    
    func rightSideSelected(_ sender: UIButton){
        if(!rightSideButton.isSelected){
            rightSideButton.isSelected = true
            rightSideButton.backgroundColor=UIColor.yellow
            showThirdQsForRighttSide()
        }else{
            rightSideButton.isSelected = false
            rightSideButton.backgroundColor=UIColor.darkGray
            hideThirdQsForRightSide()
        }
        if(leftSideButton.isSelected){
            leftSideButton.isSelected = false
            leftSideButton.backgroundColor=UIColor.darkGray
            hideThirdQsForLeftSide()
        }
    }
    
    // THIRD ROW Groundout ***************************
    
    func showThirdQsForLeftSide(){
        if(underLButton.isHidden || overLButton.isHidden){
            underLButton.isHidden = false
            overLButton.isHidden = false
        }else{
            initiateButtonRow3(event: "Under 3.5 pitches",button: underLButton, action: #selector(GameViewController.underLSelected(_:)), spot: 1)
            initiateButtonRow3(event: "Over 3.5 pitches",button: overLButton, action: #selector(GameViewController.overLSelected(_:)), spot: 2)
        }
    }
    
    func hideThirdQsForLeftSide(){
        underLButton.isHidden=true
        overLButton.isHidden=true
    }
    
    func showThirdQsForRighttSide(){
        if(underRButton.isHidden || overRButton.isHidden){
            underRButton.isHidden = false
            overRButton.isHidden = false
        }else{
            initiateButtonRow3(event: "Under 3.5 pitches",button: underRButton, action: #selector(GameViewController.underRSelected(_:)), spot: 1)
            initiateButtonRow3(event: "Over 3.5 pitches",button: overRButton, action: #selector(GameViewController.overRSelected(_:)), spot: 2)
        }
    }
    
    func hideThirdQsForRightSide(){
        underRButton.isHidden=true
        overRButton.isHidden=true
    }
    
    func underLSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: underLButton, otherButton: overLButton)
        hideNonSelected()
        lastPick = "underL"
        
    }
    func overLSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: overLButton, otherButton: underLButton)
        hideNonSelected()
        lastPick = "overL"
    }
    func underRSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: underRButton, otherButton: overRButton)
        hideNonSelected()
        lastPick = "underR"
    }
    func overRSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: overRButton, otherButton: underRButton)
        hideNonSelected()
        lastPick = "overL"
    }
    
    
    //********************************************************
    
    func hideNonSelected(){
        let allButtons: [UIButton] = [groundoutButton, airoutKButton, onBaseButton, leftSideButton,rightSideButton,airoutButton,kButton, singleButton,nonSingleButton,overLButton,underLButton,overRButton,underRButton, lfrfButton, cfButton, kSwingingButton, kLookingButton, groundSingleButton, airSingleButton, doubleButton,tripleHomerButton]
        
        for button in allButtons {
            if(!button.isSelected){
                button.isHidden=true
                button.isEnabled=false
            }else{
                
                button.backgroundColor = UIColor.darkGray
                button.setTitleColor(UIColor.yellow, for: .disabled)
                button.setTitleColor(UIColor.yellow, for: .selected)
                button.setTitleColor(UIColor.yellow, for: .highlighted)
                button.setTitleColor(UIColor.yellow, for: .normal)
                
                button.isEnabled=false
            }
        }
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
