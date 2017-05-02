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
    
    @IBOutlet weak var outsText: UITextView!
    @IBOutlet weak var runsText: UITextView!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var statsText: UITextView!
    
    
    var ref: FIRDatabaseReference!
    
    let user = FIRAuth.auth()?.currentUser
    
    var playCount : Int = 1
    
    var lastPick: String = ""
    
    var currentGame: String = ""
    
    var lastPlay : String = "init"
    
    var resultHistory = [String]()
    
    var d0 = UIImage(named: "0.png")
    var allpups = UIImage(named: "allpups.png")
    var loadDiamondArray: [UIImage] = [ UIImage(named: "1.png")!, UIImage(named: "2.png")!,UIImage(named: "3.png")!, UIImage(named: "4.png")!,]
    
    var loadPupArray: [UIImage] = [ UIImage(named: "nopups.png")!, UIImage(named: "1pups.png")!,UIImage(named: "12pups.png")!, UIImage(named: "allpups.png")!,]
    
    var homerDiamondArray: [UIImage] = [ UIImage(named: "hit1.png")!, UIImage(named: "hit2.png")!,UIImage(named: "hit1st.png")!, UIImage(named: "hit12.png")!,UIImage(named: "hit2nd.png")!, UIImage(named: "hit23.png")!,UIImage(named: "hit3rd.png")!, UIImage(named: "hit 34.png")!,UIImage(named: "hit1.png")!,]
    
    var singleDiamondArray: [UIImage] = [ UIImage(named: "hit1.png")!, UIImage(named: "hit2.png")!,UIImage(named: "hit1st.png")!,]
    
    var doubleDiamondArray: [UIImage] = [ UIImage(named: "hit1.png")!, UIImage(named: "hit2.png")!,UIImage(named: "hit1st.png")!, UIImage(named: "hit12.png")!,UIImage(named: "hit2nd.png")!,]
    
    var outDiamondArray: [UIImage] = [ UIImage(named: "out.png")!,]
    
    var endDiamondArray: [UIImage] = [ UIImage(named: "endinning.png")!,]
    
    var stateArray: [UIImage] = [ UIImage(named: "0.png")!, UIImage(named: "1.png")!, UIImage(named: "1+2.png")!,UIImage(named: "13.png")!, UIImage(named: "loaded.png")!, UIImage(named: "2.png")!, UIImage(named: "23.png")!,UIImage(named: "3.png")!,]
    
    var states: [[Int]] = [[0,0,0],[1,0,0],[1,1,0],[1,0,1],[1,1,1],[0,1,0],[0,1,1],[0,0,1],]
    
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
    
    let groundoutLOutcomes: [String] = ["underL", "overL"]
    let groundoutROutcomes: [String] = ["underR", "overR"]
    let airoutKAiroutOutcomes: [String] = ["lfrf", "cf"]
    let airoutKKOutcomes: [String] = ["kSwinging", "kLooking"]
    let onBaseSingleOutcomes: [String] = ["airsingle", "groundsingle"]
    let onBaseNonSingleOutcomes: [String] = ["double", "triplehomer"]
    
    var pickSubmitted = false
    
    var diamondState : [Int] = [0,0,0]
    var diamondIndex : Int = 0
    
    var outs : Int = 0
    var runs : Int = 0
    
    var atbats : Int = 0
    var hits : Int = 0
    var doubles : Int = 0
    var homers : Int = 0
    
    var avg : Double = 0
    var slg : Double = 0
    
    let defaults = UserDefaults.standard
    
    struct User { //starting with a structure to hold user data
        //var firebaseKey : String?
        var runs: Int?
        var username: String?
    }
    
    var userArray = [User]()
    
    //var newPlay : Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        
            //set currentGame
            self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let currUserDict = snapshot.value as? NSDictionary
            
            self.currentGame = currUserDict?.value(forKey: "currentGame") as! String
                self.atbats = currUserDict?.value(forKey: "atbats") as! Int
                self.hits = currUserDict?.value(forKey: "hits") as! Int
                self.doubles = currUserDict?.value(forKey: "doubles") as! Int
                self.homers = currUserDict?.value(forKey: "homers") as! Int
                
                //listen for new plays
                self.ref.child("games").child(self.currentGame).observe(.value, with: { (snapshot) in
                    let gameDict = snapshot.value as? NSDictionary
                    //prevPlay is to see whether the actual value changed in the database
                    let prevPlay = self.lastPlay
                    self.lastPlay = gameDict?.value(forKey: "lastPlay") as! String
                    self.outs = gameDict?.value(forKeyPath: "leaderboard."+(user?.uid)!+".outs") as! Int
                    self.runs = gameDict?.value(forKeyPath: "leaderboard."+(user?.uid)!+".runs") as! Int
                    self.diamondIndex = gameDict?.value(forKeyPath: "leaderboard."+(user?.uid)!+".diamond") as! Int
                    
                    
                    
                    
                    self.runsText.text = "Runs: " + String(self.runs)
                    self.outsText.text = "Outs: " + String(self.outs)
                    self.diamondState = self.states[self.diamondIndex]
                    self.diamond.image = self.stateArray[self.diamondIndex]
                    
                    self.updateStats()
                    
                    
                    
                    
                    //picks must be in by this point
                    if(self.lastPlay == "closed"){
                        self.closeBallot()
                    }
                    
                    else if(self.lastPlay != prevPlay && prevPlay != "init"){
                        self.gradePlay()
                        self.lastPick = ""
                        //let reversedResults = self.resultHistory.reversed()
                        self.last10.text = "Your last 10:\n"+self.resultHistory.joined(separator: "\n")
                    }
                    
                    
                    
                    //for leaderboard
                    let query = self.ref.child("games").child(self.currentGame).child("leaderboard").queryOrdered(byChild: "runs")
                    
                    query.observe(.value, with: { (snapshot) in
                        var uArray : [User] = []
                        for child in snapshot.value as! [String:AnyObject]{
                            let runs = child.value["runs"] as! Int
                            let username = child.value["username"] as! String
                            let u = User(runs: runs, username: username)
                            
                            uArray.append(u)
                            
                            
                        }
                        self.userArray = uArray
                        self.updateLeaderboard()
                    })
                    
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            
            }) { (error) in
            print(error.localizedDescription)
            }
        

        

    

    
    
    
    
        // Do any additional setup after loading the view.
        
        let outsTap = UITapGestureRecognizer(target: self, action: (#selector(GameViewController.outsTapDetected)))
        let runsTap = UITapGestureRecognizer(target: self, action: (#selector(GameViewController.runsTapDetected)))
        let diamondTap = UITapGestureRecognizer(target: self, action: (#selector(GameViewController.diamondTapDetected)))
        let pupTap = UITapGestureRecognizer(target: self, action: (#selector(GameViewController.pupTapDetected)))
        let last10Tap = UITapGestureRecognizer(target: self, action: (#selector(GameViewController.last10TapDetected)))
        
        last10Tap.numberOfTapsRequired = 1
        pupTap.numberOfTapsRequired = 1
        runsTap.numberOfTapsRequired = 1
        outsTap.numberOfTapsRequired = 1
        diamondTap.numberOfTapsRequired = 1
        last10.addGestureRecognizer(last10Tap)
        powerups.addGestureRecognizer(pupTap)
        diamond.addGestureRecognizer(diamondTap)
        runsText.addGestureRecognizer(runsTap)
        outsText.addGestureRecognizer(outsTap)
        
        
        self.resultHistory = [defaults.value(forKey: "1") as! String, defaults.value(forKey: "2") as! String,defaults.value(forKey: "3") as! String,defaults.value(forKey: "4") as! String,defaults.value(forKey:"5") as! String,defaults.value(forKey: "6") as! String,defaults.value(forKey: "7") as! String,defaults.value(forKey: "8") as! String,defaults.value(forKey: "9") as! String,defaults.value(forKey: "10") as! String,]
        
        //let reversedResults = self.resultHistory.reversed()
        self.last10.text = "Your last 10:\n"+self.resultHistory.joined(separator: "\n")
        
        //diamond.animationImages = loadDiamondArray;
        //diamond.animationDuration = 0.65
        //diamond.animationRepeatCount = 1
        
        
        
        //powerups.animationImages = loadPupArray
        //powerups.animationDuration = 0.65
        //powerups.animationRepeatCount = 1
        powerups.image = allpups;
        
        showThirdQsForK()
        showThirdQsForAirout()
        showThirdQsForSingle()
        showThirdQsForLeftSide()
        showThirdQsForNonSingle()
        showThirdQsForRighttSide()
        showSecondQsForGroundout()
        showSecondQsForAiroutK()
        showSecondQsForOnBase()
        
        hideThirdQsForK()
        hideThirdQsForAirout()
        hideThirdQsForSingle()
        hideThirdQsForLeftSide()
        hideThirdQsForRightSide()
        hideThirdQsForNonSingle()
        hideSecondQsForOnBase()
        hideSecondQsForAiroutK()
        hideSecondQsForGroundout()

    }
    
    func updateLeaderboard(){
        
        let rankings = Array(self.userArray.reversed())
        var runString : [String] = ["","","","","",""]
        var usernameString : [String] = ["n/a","n/a","n/a","n/a","n/a","n/a"]
        var i : Int = 0
        
        for user in rankings {
            let x : Int = user.runs!
            runString[i] = String(x)
            usernameString[i] = user.username!
            i += 1
        }
        
        self.leaderboard.text = "1. " + usernameString[0] + "  Runs: " + runString[0] + "    $10\n" + "2. " + usernameString[1] + "  Runs: " + runString[1] + "    $5\n" + "3. " + usernameString[2] + "  Runs: " + runString[2] + "    $0\n" + "4. " + usernameString[3] + "  Runs: " + runString[3] + "    $0\n" + "5. " + usernameString[4] + "  Runs: " + runString[4] + "    $0\n" + "6. " + usernameString[5] + "  Runs: " + runString[5] + "    $0\n"
        
    }
    
    func last10TapDetected(){
        
    }
    
    func pupTapDetected() {
        let pupAlert = UIAlertController(title: "Power Innings", message: "There are 3 Power Inning types:\n\nSpeed Demon: Your runners advance an extra base on a hit\n\nAll Triples: Any hit counts as a triple in the game (but not for your Career Stats\n\nDouble Points: All runs count as 2 runs\n\nPower Innings are randomly awarded, and they last until you guess 3 at bats wrong.", preferredStyle: .alert)
        let okAction = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default) { (action) in
            
        }
        pupAlert.addAction(okAction)
        self.present(pupAlert, animated:true)
    }
    func outsTapDetected() {
        print("outs Clicked")
        let outAlert = UIAlertController(title: "Outs", message: "There are 3 tiers of questions regarding each at bat.  If you select them all wrong, you get an out.  If you get 3 outs, the bases clear.", preferredStyle: .alert)
        let okAction = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default) { (action) in
            
        }
        outAlert.addAction(okAction)
        self.present(outAlert, animated:true)
    }
    func runsTapDetected() {
        let runsAlert = UIAlertController(title: "Runs", message: "The goal is to score as many runs as possible before the game ends.  You do that by guessing at bat outcomes correctly.  The more runs you score, the better your chances of winning money!", preferredStyle: .alert)
        let okAction = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default) { (action) in
            
        }
        runsAlert.addAction(okAction)
        self.present(runsAlert, animated:true)    }
    func diamondTapDetected() {
        let diamondAlert = UIAlertController(title: "Diamond", message: "The diamond shows your runners on base.  Runners on base clear once you get 3 outs.  You try to knock runners in by guessing at bat outcomes correctly.  For example, if there is a man on second and you hit a double, you score a run!", preferredStyle: .alert)
        let okAction = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default) { (action) in
            
        }
        diamondAlert.addAction(okAction)
        self.present(diamondAlert, animated:true)
    }
    
    
    func updateStats(){
        print("self.atbats: ",self.atbats)
        if(self.hits > 0){
            self.avg = Double(self.hits)/Double(self.atbats)
            self.slg = ( Double(self.hits-self.doubles-self.homers) + Double(2*self.doubles) + Double(4*self.homers) )/Double(self.atbats)
            
            self.avg = (self.avg * 1000).rounded() / 1000
            self.slg = (self.slg * 1000).rounded() / 1000
            
            self.statsText.text = "Career Stats:\nAVG: "+String(self.avg)+"\nSLG: "+String(self.slg)
        }else{
            self.statsText.text = "Career Stats:\nAVG:\nSLG:"
        }
    }
    
    func closeBallot(){
        let allButtons: [UIButton] = [groundoutButton, airoutKButton, onBaseButton, leftSideButton,rightSideButton,airoutButton,kButton, singleButton,nonSingleButton,overLButton,underLButton,overRButton,underRButton, lfrfButton, cfButton, kSwingingButton, kLookingButton, groundSingleButton, airSingleButton, doubleButton,tripleHomerButton]

        hideNonSelected()
        
        for button in allButtons{
            button.isEnabled = false
        }
        
        
    }
    
    func diamondChange(outcome: String){
        if(outcome == "Home Run"){
            diamond.animationImages = homerDiamondArray;
            runs += 1 + self.diamondState.reduce(0,+)
            self.runsText.text = "Runs: " + String(self.runs)
            
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("runs").setValue(self.runs)
            self.ref.child("users").child((user?.uid)!).child("homers").setValue(self.homers+1)
            self.ref.child("users").child((user?.uid)!).child("hits").setValue(self.hits+1)
            self.ref.child("users").child((user?.uid)!).child("atbats").setValue(self.atbats+1)
            self.homers += 1
            self.atbats += 1
            self.hits += 1
            
            self.diamondState = [0,0,0]
            diamond.startAnimating()
            self.perform(#selector(GameViewController.updateDiamond), with: nil, afterDelay: diamond.animationDuration)
            
        }else if(outcome == "Out"){
            diamond.animationImages = outDiamondArray;
            
            if(self.outs < 2){
                self.outs += 1
            }else{
                diamond.animationImages = endDiamondArray;
                self.outs = 0
            }
            self.outsText.text = "Outs: " + String(self.outs)
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("outs").setValue(self.outs)
            
            self.atbats += 1
            self.ref.child("users").child((user?.uid)!).child("atbats").setValue(self.atbats)
            
            
            
            
            diamond.startAnimating()
            self.perform(#selector(GameViewController.updateDiamond), with: nil, afterDelay: diamond.animationDuration)
            
        }else if(outcome == "Single"){
            diamond.animationImages = singleDiamondArray;
            
            if(diamondState[2] == 1){
                self.runs += 1
            }
            self.runsText.text = "Runs: " + String(self.runs)
            
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("runs").setValue(self.runs)

            self.ref.child("users").child((user?.uid)!).child("hits").setValue(self.hits+1)
            self.ref.child("users").child((user?.uid)!).child("atbats").setValue(self.atbats+1)

            self.atbats += 1
            self.hits += 1
            
            if (diamondState == [0,0,0] || diamondState == [0,0,1]){
                self.diamondState = [1,0,0]
                
            }else if( diamondState == [1,0,0] || diamondState == [1,0,1]){
                self.diamondState = [1,1,0]

            }else if( diamondState == [0,1,0] || diamondState == [0,1,1]){
                self.diamondState = [1,0,1]
                
            }else if( diamondState == [1,1,1] || diamondState == [1,1,0]){
                self.diamondState = [1,0,0]
                
            }
            
            
        }else if(outcome == "Double"){
            diamond.animationImages = doubleDiamondArray;
            
            if(diamondState[2] == 1){
                self.runs += 1
            }
            if(diamondState[1] == 1){
                self.runs += 1
            }
            self.runsText.text = "Runs: " + String(self.runs)
            
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("runs").setValue(self.runs)
            self.ref.child("users").child((user?.uid)!).child("doubles").setValue(self.doubles+1)
            self.ref.child("users").child((user?.uid)!).child("hits").setValue(self.hits+1)
            self.ref.child("users").child((user?.uid)!).child("atbats").setValue(self.atbats+1)
            self.doubles += 1
            self.atbats += 1
            self.hits += 1
            
            if (diamondState == [0,0,0] || diamondState == [0,0,1] || diamondState == [0,1,1] || diamondState == [0,1,0]){
                self.diamondState = [0,1,0]
                
            }else if( diamondState == [1,0,0] || diamondState == [1,0,1] || diamondState == [1,1,0] || diamondState == [1,1,1]){
                self.diamondState = [0,1,1]
            }
        }

        updateStats()
        
        diamond.startAnimating()
        self.perform(#selector(GameViewController.updateDiamond), with: nil, afterDelay: diamond.animationDuration)
        
    }
    
    func updateDiamond(){
        
        diamond.stopAnimating()
        
        
        
        if(self.diamondState == [0,0,0]){
            diamond.image = stateArray[0]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(0)
            
        }else if(self.diamondState == [1,0,0]){
            diamond.image = stateArray[1]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(1)
            
        }else if(self.diamondState == [1,1,0]){
            diamond.image = stateArray[2]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(2)
            
        }else if(self.diamondState == [1,0,1]){
            diamond.image = stateArray[3]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(3)
            
        }else if(self.diamondState == [1,1,1]){
            diamond.image = stateArray[4]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(4)
            
        }else if(self.diamondState == [0,1,0]){
            diamond.image = stateArray[5]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(5)
            
        }else if(self.diamondState == [0,1,1]){
            diamond.image = stateArray[6]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(6)
            
        }else if(self.diamondState == [0,0,1]){
            diamond.image = stateArray[7]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(7)
        }
        
    }
    
    func updateDefaults(outcome: String){
        defaults.set(defaults.value(forKey: "9") , forKey: "10")
        defaults.set(defaults.value(forKey: "8") , forKey: "9")
        defaults.set(defaults.value(forKey: "7") , forKey: "8")
        defaults.set(defaults.value(forKey: "6") , forKey: "7")
        defaults.set(defaults.value(forKey: "5") , forKey: "6")
        defaults.set(defaults.value(forKey: "4") , forKey: "5")
        defaults.set(defaults.value(forKey: "3") , forKey: "4")
        defaults.set(defaults.value(forKey: "2") , forKey: "3")
        defaults.set(defaults.value(forKey: "1") , forKey: "2")
        defaults.set(outcome, forKey: "1")
        //print(defaults.value(forKey: "1"))
        
        self.resultHistory = [defaults.value(forKey: "1") as! String, defaults.value(forKey: "2") as! String,defaults.value(forKey: "3") as! String,defaults.value(forKey: "4") as! String,defaults.value(forKey:"5") as! String,defaults.value(forKey: "6") as! String,defaults.value(forKey: "7") as! String,defaults.value(forKey: "8") as! String,defaults.value(forKey: "9") as! String,defaults.value(forKey: "10") as! String,]
        
        //let reversedResults = self.resultHistory.reversed()
        self.last10.text = "Your last 10:\n"+self.resultHistory.joined(separator: "\n")
    }
    
    func gradePlay(){
        
        let allButtons: [UIButton] = [groundoutButton, airoutKButton, onBaseButton, leftSideButton,rightSideButton,airoutButton,kButton, singleButton,nonSingleButton,overLButton,underLButton,overRButton,underRButton, lfrfButton, cfButton, kSwingingButton, kLookingButton, groundSingleButton, airSingleButton, doubleButton,tripleHomerButton]

        if(self.lastPlay == "next"){
            for button in allButtons{

                
                button.isHidden = false

                button.isSelected = false
                button.isHighlighted = false
                button.backgroundColor = UIColor.darkGray
                button.isEnabled = true
               
                
                button.setTitleColor(UIColor.white, for: .disabled)
                button.setTitleColor(UIColor.black, for: .selected)
                button.setTitleColor(UIColor.black, for: .highlighted)
                button.setTitleColor(UIColor.white, for: .normal)
                
                
                
                hideThirdQsForK()
                hideThirdQsForAirout()
                hideThirdQsForSingle()
                hideThirdQsForLeftSide()
                hideThirdQsForRightSide()
                hideThirdQsForNonSingle()
                hideSecondQsForOnBase()
                hideSecondQsForAiroutK()
                hideSecondQsForGroundout()
                
                
            }
        }
        else if(lastPick == self.lastPlay){
            for button in allButtons{
                if(!button.isHidden){
                    button.backgroundColor = UIColor.green
                }
                //add to stats
                
            }
            
            self.resultHistory.append("Home Run")
            updateDefaults(outcome: "Home Run")
            
            self.playCount += 1
            
            diamondChange(outcome: "Home Run")
            
        }else if(lastPick == "none yet" || last10.text == "Your last 10:"){
            
        }
            
            //double for groundoutL selection
        else if(groundoutLOutcomes.contains(lastPick) && groundoutLOutcomes.contains(self.lastPlay)){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "underL"){
                        groundoutButton.backgroundColor = UIColor.green
                        leftSideButton.backgroundColor = UIColor.green
                        underLButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "overL"){
                        groundoutButton.backgroundColor = UIColor.green
                        leftSideButton.backgroundColor = UIColor.green
                        overLButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Double")
            updateDefaults(outcome: "Double")
            
            self.playCount += 1
            
            diamondChange(outcome: "Double")
        }
            //double for groundoutR selection
        else if(groundoutROutcomes.contains(lastPick) && groundoutROutcomes.contains(self.lastPlay)){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "underR"){
                        groundoutButton.backgroundColor = UIColor.green
                        rightSideButton.backgroundColor = UIColor.green
                        underRButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "overR"){
                        groundoutButton.backgroundColor = UIColor.green
                        rightSideButton.backgroundColor = UIColor.green
                        overRButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Double")
            updateDefaults(outcome: "Double")
            self.playCount += 1
            
            diamondChange(outcome: "Double")
        }
            //double for airoutK airout selection
        else if(airoutKAiroutOutcomes.contains(lastPick) && airoutKAiroutOutcomes.contains(self.lastPlay)){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "lfrf"){
                        airoutKButton.backgroundColor = UIColor.green
                        airoutButton.backgroundColor = UIColor.green
                        lfrfButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "cf"){
                        airoutKButton.backgroundColor = UIColor.green
                        airoutButton.backgroundColor = UIColor.green
                        cfButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Double")
            updateDefaults(outcome: "Double")
            
            self.playCount += 1
            
            diamondChange(outcome: "Double")
        }
            //double for airoutK K selection
        else if(airoutKKOutcomes.contains(lastPick) && airoutKKOutcomes.contains(self.lastPlay)){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "kSwinging"){
                        airoutKButton.backgroundColor = UIColor.green
                        kButton.backgroundColor = UIColor.green
                        kSwingingButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "kLooking"){
                        airoutKButton.backgroundColor = UIColor.green
                        kButton.backgroundColor = UIColor.green
                        kLookingButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Double")
            updateDefaults(outcome: "Double")
            
            self.playCount += 1
            
            diamondChange(outcome: "Double")
        }
            //double for onBase Single selection
        else if(onBaseSingleOutcomes.contains(lastPick) && onBaseSingleOutcomes.contains(self.lastPlay)){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "airsingle"){
                        onBaseButton.backgroundColor = UIColor.green
                        singleButton.backgroundColor = UIColor.green
                        airSingleButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "groundsingle"){
                        onBaseButton.backgroundColor = UIColor.green
                        singleButton.backgroundColor = UIColor.green
                        groundSingleButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Double")
            updateDefaults(outcome: "Double")
            
            self.playCount += 1
            
            diamondChange(outcome: "Double")
        }
            //double for onBase NonSingle selction
        else if(onBaseNonSingleOutcomes.contains(lastPick) && onBaseNonSingleOutcomes.contains(self.lastPlay)){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "double"){
                        onBaseButton.backgroundColor = UIColor.green
                        nonSingleButton.backgroundColor = UIColor.green
                        doubleButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "triplehomer"){
                        onBaseButton.backgroundColor = UIColor.green
                        nonSingleButton.backgroundColor = UIColor.green
                        tripleHomerButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Double")
            updateDefaults(outcome: "Double")
            
            self.playCount += 1
            
            diamondChange(outcome: "Double")
        }
            
            
            //************** SINGLE OUTCOMES BUD! ***********************************
            //single for groundoutL selection
        else if(groundoutLOutcomes.contains(lastPick) && (groundoutLOutcomes.contains(self.lastPlay) || groundoutROutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "underL"){
                        groundoutButton.backgroundColor = UIColor.green
                        leftSideButton.backgroundColor = UIColor.red
                        underLButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "overL"){
                        groundoutButton.backgroundColor = UIColor.green
                        leftSideButton.backgroundColor = UIColor.red
                        overLButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }
            //single for groundoutR selection
        else if(groundoutROutcomes.contains(lastPick) && (groundoutROutcomes.contains(self.lastPlay) || groundoutLOutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "underR"){
                        groundoutButton.backgroundColor = UIColor.green
                        rightSideButton.backgroundColor = UIColor.red
                        underRButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "overR"){
                        groundoutButton.backgroundColor = UIColor.green
                        rightSideButton.backgroundColor = UIColor.red
                        overRButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }
            //single for airoutK airout selection
        else if(airoutKAiroutOutcomes.contains(lastPick) && (airoutKAiroutOutcomes.contains(self.lastPlay) || airoutKKOutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "lfrf"){
                        airoutKButton.backgroundColor = UIColor.green
                        airoutButton.backgroundColor = UIColor.red
                        lfrfButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "cf"){
                        airoutKButton.backgroundColor = UIColor.green
                        airoutButton.backgroundColor = UIColor.red
                        cfButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }
            //single for airoutK K selection
        else if(airoutKKOutcomes.contains(lastPick) && (airoutKKOutcomes.contains(self.lastPlay) || airoutKAiroutOutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "kSwinging"){
                        airoutKButton.backgroundColor = UIColor.green
                        kButton.backgroundColor = UIColor.red
                        kSwingingButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "kLooking"){
                        airoutKButton.backgroundColor = UIColor.green
                        kButton.backgroundColor = UIColor.red
                        kLookingButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }
            //single for onBase Single selection
        else if(onBaseSingleOutcomes.contains(lastPick) && (onBaseSingleOutcomes.contains(self.lastPlay) || onBaseNonSingleOutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "airsingle"){
                        onBaseButton.backgroundColor = UIColor.green
                        singleButton.backgroundColor = UIColor.red
                        airSingleButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "groundsingle"){
                        onBaseButton.backgroundColor = UIColor.green
                        singleButton.backgroundColor = UIColor.red
                        groundSingleButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }
            //single for onBase NonSingle selction
        else if(onBaseNonSingleOutcomes.contains(lastPick) && (onBaseNonSingleOutcomes.contains(self.lastPlay) || onBaseSingleOutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if(self.lastPlay != "double"){
                        onBaseButton.backgroundColor = UIColor.green
                        nonSingleButton.backgroundColor = UIColor.red
                        doubleButton.backgroundColor = UIColor.red
                    }
                    else if(self.lastPlay != "triplehomer"){
                        onBaseButton.backgroundColor = UIColor.green
                        nonSingleButton.backgroundColor = UIColor.red
                        tripleHomerButton.backgroundColor = UIColor.red
                    }
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }

            
        else{
            for button in allButtons{
                if(!button.isHidden){
                    button.backgroundColor = UIColor.red
                }
            }
            self.resultHistory.append("Out")
            updateDefaults(outcome: "Out")
            
            self.playCount += 1
            
            diamondChange(outcome: "Out")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //diamond.startAnimating()
        self.perform(#selector(GameViewController.afterAnimation), with: nil, afterDelay: diamond.animationDuration)
        //powerups.startAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func afterAnimation() {
        //diamond.stopAnimating()
        //powerups.stopAnimating()
        updateDiamond()
        
        
        diamond.animationDuration = 1.25
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
        pickSubmitted = true
    }
    func tripleHomerSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: tripleHomerButton, otherButton: doubleButton)
        hideNonSelected()
        lastPick = "triplehomer"
        pickSubmitted = true
    }
    func airSingleSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: airSingleButton, otherButton: groundSingleButton)
        hideNonSelected()
        lastPick = "airsingle"
        pickSubmitted = true
    }
    func groundSingleSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: groundSingleButton, otherButton: airSingleButton)
        hideNonSelected()
        lastPick = "groundsingle"
        pickSubmitted = true
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
        pickSubmitted = true
    }
    func cfSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: cfButton, otherButton: lfrfButton)
        hideNonSelected()
        lastPick = "cf"
        pickSubmitted = true
    }
    func kSwingingSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: kSwingingButton, otherButton: kLookingButton)
        hideNonSelected()
        lastPick = "kSwinging"
        pickSubmitted = true
    }
    func kLookingSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: kLookingButton, otherButton: kSwingingButton)
        hideNonSelected()
        lastPick = "kLooking"
        pickSubmitted = true
    }

    
    // Groundout ************************************************************
    
    func showSecondQsForGroundout(){
        if(leftSideButton.isHidden || rightSideButton.isHidden){
            leftSideButton.isHidden = false
            rightSideButton.isHidden = false
            //print("title label: ", leftSideButton.titleLabel)
            
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
        pickSubmitted = true
    }
    func overLSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: overLButton, otherButton: underLButton)
        hideNonSelected()
        lastPick = "overL"
        pickSubmitted = true
    }
    func underRSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: underRButton, otherButton: overRButton)
        hideNonSelected()
        lastPick = "underR"
        pickSubmitted = true
    }
    func overRSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: overRButton, otherButton: underRButton)
        hideNonSelected()
        lastPick = "overR"
        pickSubmitted = true
    }
    
    
    //********************************************************
    
    func hideNonSelected(){
        let allButtons: [UIButton] = [groundoutButton, airoutKButton, onBaseButton, leftSideButton,rightSideButton,airoutButton,kButton, singleButton,nonSingleButton,overLButton,underLButton,overRButton,underRButton, lfrfButton, cfButton, kSwingingButton, kLookingButton, groundSingleButton, airSingleButton, doubleButton,tripleHomerButton]
        
        
        for button in allButtons {
            if(!button.isSelected){
                button.isHidden = true
                button.isEnabled = false
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
