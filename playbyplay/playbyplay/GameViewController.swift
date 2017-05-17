//
//  GameViewController.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 2/20/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

class GameViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var leaderboard: UITextView!
    @IBOutlet weak var last10: UITextView!
    @IBOutlet weak var diamond: UIImageView!
    @IBOutlet weak var powerups: UIImageView!
    
    @IBOutlet weak var inningsText: UITextView!
    @IBOutlet weak var hiscoreText: UITextView!

    @IBOutlet weak var groundoutButton: UIButton!
    @IBOutlet weak var airoutKButton: UIButton!
    @IBOutlet weak var onBaseButton: UIButton!
    
    @IBOutlet weak var leaderboardTV: UITableView!
    
    @IBOutlet weak var outsText: UITextView!
    @IBOutlet weak var runsText: UITextView!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var statsText: UITextView!
    
    @IBOutlet weak var rulingStatus: UILabel!
    @IBOutlet weak var gameStatus: UILabel!
    
    var ref: FIRDatabaseReference!
    
    let user = FIRAuth.auth()?.currentUser
    
    var playCount : Int = 1
    
    var lastPick: String = ""
    
    var currentGame: String = ""
    
    var lastPlay : String = "init"
    
    var resultHistory = [String]()
    
    
    var d0 = UIImage(named: "0.png")
    var pupArray : [UIImage] = [ UIImage(named: "nopups.png")!, UIImage(named: "1pups.png")!, UIImage(named: "2pups.png")!, UIImage(named: "3pups.png")!, UIImage(named: "nopups.png")!, UIImage(named: "nopups.png")!, UIImage(named: "nopups.png")!, UIImage(named: "nopups.png")!, UIImage(named: "nopups.png")!,]
    var loadDiamondArray: [UIImage] = [ UIImage(named: "1.png")!, UIImage(named: "2.png")!,UIImage(named: "3.png")!, UIImage(named: "4.png")!,]
    
    var loadPupArray: [UIImage] = [ UIImage(named: "nopups.png")!, UIImage(named: "1pups.png")!,UIImage(named: "12pups.png")!, UIImage(named: "allpups.png")!,]
    
    var homerDiamondArray: [UIImage] = [ UIImage(named: "hit1.png")!, UIImage(named: "hit2.png")!,UIImage(named: "hit1st.png")!, UIImage(named: "hit12.png")!,UIImage(named: "hit2nd.png")!, UIImage(named: "hit23.png")!,UIImage(named: "hit3rd.png")!, UIImage(named: "hit 34.png")!,UIImage(named: "hit1.png")!,]
    
    var singleDiamondArray: [UIImage] = [ UIImage(named: "hit1.png")!, UIImage(named: "hit2.png")!,UIImage(named: "hit1st.png")!,]
    
    var doubleDiamondArray: [UIImage] = [ UIImage(named: "hit1.png")!, UIImage(named: "hit2.png")!,UIImage(named: "hit1st.png")!, UIImage(named: "hit12.png")!,UIImage(named: "hit2nd.png")!,]
    
    var tripleDiamondArray: [UIImage] = [ UIImage(named: "hit1.png")!, UIImage(named: "hit2.png")!,UIImage(named: "hit1st.png")!, UIImage(named: "hit12.png")!,UIImage(named: "hit2nd.png")!, UIImage(named: "hit23.png")!,UIImage(named: "hit3rd.png")!,]
    
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
    var inning : Int = 1
    var hiscore : Int = 0
    
    var atbats : Int = 0
    var hits : Int = 0
    var doubles : Int = 0
    var homers : Int = 0
    
    var allTimeHi : Int = 0
    
    var avg : Double = 0
    var slg : Double = 0
    
    let defaults = UserDefaults.standard
    
    var runnersMoved = false
    
    var currPup : Int?
    
    //var pupArray = ["speeddemon", "triples", "doublepoints"]
    
    
    
    struct User { //starting with a structure to hold user data
        //var firebaseKey : String?
        var runs: Int?
        var username: String?
    }
    
    var userArray = [User]()
    
    var array : [NSDictionary] = []
    
    //var newPlay : Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leaderboardTV.backgroundColor = UIColor.darkGray
        self.leaderboardTV.rowHeight = 34
        
        self.runnersMoved = false
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
                self.allTimeHi = currUserDict?.value(forKey: "hiscore") as! Int
                
                //listen for new plays
                self.ref.child("games").child(self.currentGame).observe(.value, with: { (snapshot) in
                    let gameDict = snapshot.value as? NSDictionary
                    //prevPlay is to see whether the actual value changed in the database
                    let prevPlay = self.lastPlay
                    self.lastPlay = gameDict?.value(forKey: "lastPlay") as! String
                    self.outs = gameDict?.value(forKeyPath: "leaderboard."+(user?.uid)!+".outs") as! Int
                    self.runs = gameDict?.value(forKeyPath: "leaderboard."+(user?.uid)!+".runs") as! Int
                    self.hiscore = gameDict?.value(forKeyPath: "leaderboard."+(user?.uid)!+".hiscore") as! Int
                    self.lastPick = gameDict?.value(forKeyPath: "leaderboard."+(user?.uid)!+".lastPick") as! String
                    self.inning = gameDict?.value(forKeyPath: "leaderboard."+(user?.uid)!+".inning") as! Int
                    self.currPup = gameDict?.value(forKeyPath: "leaderboard."+(user?.uid)!+".pup") as? Int
                    
                    var lpText : String?
                    if(self.lastPlay == "underL"){
                        lpText = "Groundout L Under"
                    }else if(self.lastPlay == "overL"){
                        lpText = "Groundout L Over"
                    }else if(self.lastPlay == "underR"){
                        lpText = "Groundout R Under"
                    }else if(self.lastPlay == "overR"){
                        lpText = "Groundout R Over"
                    }else if(self.lastPlay == "lfrf"){
                        lpText = "Air Out LF/RF"
                    }else if(self.lastPlay == "cf"){
                        lpText = "Air Out CF/Other"
                    }else if(self.lastPlay == "kSwinging"){
                        lpText = "K Swinging"
                    }else if(self.lastPlay == "kLooking"){
                        lpText = "K Looking"
                    }else if(self.lastPlay == "groundsingle"){
                        lpText = "Ground Single"
                    }else if(self.lastPlay == "airsingle"){
                        lpText = "Air Single"
                    }else if(self.lastPlay == "double"){
                        lpText = "Double"
                    }else if(self.lastPlay == "triplehomer"){
                        lpText = "HR/3B/BB"
                    }else{
                        lpText = ""
                    }
                    
                    self.powerups.image = self.pupArray[self.currPup!];
                    if(self.currPup == 1){
                        self.inningsText.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
                        self.outsText.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
                        self.runsText.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
                        self.hiscoreText.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
                    }else if(self.currPup == 2){
                        self.inningsText.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
                        self.outsText.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
                        self.runsText.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
                        self.hiscoreText.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
                    }else if(self.currPup == 3){
                        self.inningsText.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
                        self.outsText.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
                        self.runsText.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
                        self.hiscoreText.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
                    }else{
                        self.inningsText.textColor = UIColor.yellow
                        self.outsText.textColor = UIColor.yellow
                        self.runsText.textColor = UIColor.yellow
                        self.hiscoreText.textColor = UIColor.yellow
                    }
                   
                    
                    if(self.runnersMoved == false){
                        self.diamondIndex = gameDict?.value(forKeyPath: "leaderboard."+(user?.uid)!+".diamond") as! Int
                        self.diamondState = self.states[self.diamondIndex]
                        self.diamond.image = self.stateArray[self.diamondIndex]
                    }
                    
                    
                    
                    self.runsText.text = "Runs: " + String(self.runs)
                    self.outsText.text = "Outs: " + String(self.outs)
                    self.inningsText.text = "Inning: " + String(self.inning)
                    
                    
                    if(self.runs > self.hiscore){
                        self.hiscore = self.runs
                    }
                    self.hiscoreText.text = "Hi-Score: " + String(self.hiscore)
                    
                    self.updateStats()
                    
                    
                    
                    
                    //picks must be in by this point
                    if(self.lastPlay == "closed"){
                        self.gameStatus.text = "AB in Progress.."
                        self.gameStatus.textColor = UIColor.white
                        self.closeBallot()
                    }
                    
                    else if(self.lastPlay != prevPlay){
                        
                        
                        self.gradePlay()
                        if(self.lastPlay != "next"){
                            self.rulingStatus.text = "Last Play: " + lpText!
                        }
                        self.menuButton.isEnabled = true
                        self.lastPick = ""
                        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(self.lastPick)
                        self.pickSubmitted = false
                        //let reversedResults = self.resultHistory.reversed()
                        self.last10.text = "Your last 10:\n"+self.resultHistory.joined(separator: "\n")
                    }else if( self.lastPlay == "init" ){
                        self.gameStatus.text = "Game has not started"
                        self.gameStatus.textColor = UIColor.white
                    }
                    
                    
                    let query = self.ref.child("games").child(self.currentGame).child("leaderboard").queryOrdered(byChild: "hiscore")
                    
                    query.observe(.value, with: { (snapshot) in
                        
                        let enumerator = snapshot.children
                        self.array = []
                        while let rest = enumerator.nextObject() as? FIRDataSnapshot{
                            
                            self.array.append(rest.value as! NSDictionary)
                            
                        }
                        self.updateLeaderboard()
                        self.leaderboardTV.reloadData()
                    })
                    
        

                    
                    
//                    //for leaderboard
//                    let query = self.ref.child("games").child(self.currentGame).child("leaderboard").queryOrdered(byChild: "runs")
//                    
//                    query.observe(.value, with: { (snapshot) in
//                        var uArray : [User] = []
//                        for child in snapshot.value as! [String:AnyObject]{
//                            let runs = child.value["runs"] as! Int
//                            let username = child.value["username"] as! String
//                            let u = User(runs: runs, username: username)
//                            
//                            uArray.append(u)
//                            
//                            
//                        }
//                        self.userArray = uArray
//                        self.updateLeaderboard()
//                    })
                    
                    
                    
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
        let inningsTap = UITapGestureRecognizer(target: self, action: (#selector(GameViewController.inningsTapDetected)))
        let hiTap = UITapGestureRecognizer(target: self, action: (#selector(GameViewController.hiTapDetected)))
        
        hiTap.numberOfTapsRequired = 1
        last10Tap.numberOfTapsRequired = 1
        pupTap.numberOfTapsRequired = 1
        runsTap.numberOfTapsRequired = 1
        outsTap.numberOfTapsRequired = 1
        diamondTap.numberOfTapsRequired = 1
        inningsTap.numberOfTapsRequired = 1
        hiscoreText.addGestureRecognizer(hiTap)
        last10.addGestureRecognizer(last10Tap)
        powerups.addGestureRecognizer(pupTap)
        diamond.addGestureRecognizer(diamondTap)
        runsText.addGestureRecognizer(runsTap)
        outsText.addGestureRecognizer(outsTap)
        inningsText.addGestureRecognizer(inningsTap)
        
        
        self.resultHistory = [defaults.value(forKey: "1") as! String, defaults.value(forKey: "2") as! String,defaults.value(forKey: "3") as! String,defaults.value(forKey: "4") as! String,defaults.value(forKey:"5") as! String,defaults.value(forKey: "6") as! String,defaults.value(forKey: "7") as! String,defaults.value(forKey: "8") as! String,defaults.value(forKey: "9") as! String,defaults.value(forKey: "10") as! String,]
        
        //let reversedResults = self.resultHistory.reversed()
        self.last10.text = "Your last 10:\n"+self.resultHistory.joined(separator: "\n")
        
        //diamond.animationImages = loadDiamondArray;
        //diamond.animationDuration = 0.65
        //diamond.animationRepeatCount = 1
        
        
        
        //powerups.animationImages = loadPupArray
        //powerups.animationDuration = 0.65
        //powerups.animationRepeatCount = 1
        
        
        
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
        
        hideNonSelected()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LCell", for: indexPath) as! LeaderboardTableViewCell
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        
        let rankings = Array(self.array.reversed())
        
        if (rankings[indexPath.row].value(forKey:"pup") as! Int == 1){
            cell.usernameLabel.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
            cell.runsLabel.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
            cell.inningLabel.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
            cell.moneyLabel.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
            cell.innSignifier.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
            cell.rSignifier.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
            cell.hiSignifier.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
            cell.hiLabel.textColor = UIColor.init(red: 0.988, green: 0.467, blue: 0.031, alpha: 1)
        }else if (rankings[indexPath.row].value(forKey:"pup") as! Int == 2){
            cell.usernameLabel.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
            cell.runsLabel.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
            cell.inningLabel.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
            cell.moneyLabel.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
            cell.innSignifier.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
            cell.rSignifier.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
            cell.hiSignifier.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
            cell.hiLabel.textColor = UIColor.init(red: 0.322, green: 0.788, blue: 1, alpha: 1)
        }else if (rankings[indexPath.row].value(forKey:"pup") as! Int == 3){
            cell.usernameLabel.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
            cell.runsLabel.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
            cell.inningLabel.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
            cell.moneyLabel.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
            cell.innSignifier.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
            cell.rSignifier.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
            cell.hiSignifier.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
            cell.hiLabel.textColor = UIColor.init(red: 0.133, green: 1, blue: 0.67, alpha: 1)
        }else{
            cell.usernameLabel.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
            cell.runsLabel.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
            cell.inningLabel.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
            cell.moneyLabel.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
            cell.innSignifier.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
            cell.rSignifier.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
            cell.hiLabel.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
            cell.hiSignifier.textColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        if(indexPath.row < rankings.count){
            let runs : Int = rankings[indexPath.row].value(forKey: "runs") as! Int
            let inn = rankings[indexPath.row].value(forKey: "inning") as! Int
            let hi = rankings[indexPath.row].value(forKey: "hiscore") as! Int
            
            let rank = indexPath.row + 1
            
            cell.usernameLabel.text = String(rank) + ". " + (rankings[indexPath.row].value(forKey:"username") as! String)
            
            cell.runsLabel.text = String(runs)
            
            cell.inningLabel.text = String(inn)
            
            cell.hiLabel.text = String(hi)
            
            let state = rankings[indexPath.row].value(forKey: "diamond") as! Int
            
            cell.diamond.image = stateArray[state]
            
            if(indexPath.row == 0){
                cell.moneyLabel.text = "$10"
            }else if(indexPath.row == 1){
                cell.moneyLabel.text = "$5"
            }else if(indexPath.row < rankings.count){
                cell.moneyLabel.text = "$0"
            }
        }
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func updateLeaderboard(){
        
        var rankings = Array(self.array.reversed())
        
        if(rankings.count < 10){
            var i = rankings.count
            while( i < 10){
                let blankUser : NSDictionary = ["username": "", "hiscore": 0]
                rankings.append(blankUser)
                i += 1
            }
        }
        var i = 0
        while( i < rankings.count){
            if(rankings[i].value(forKey: "username") == nil){
                rankings[i] = ["username": "", "hiscore": 0]
            }
            
            i += 1
        }

        
        
        let firstPlace = rankings[0]
        let firstUsername = firstPlace.value(forKey: "username") as! String
        let firstRuns = firstPlace.value(forKey: "hiscore") as! Int
        let secondPlace = rankings[1]
        let secondUsername = secondPlace.value(forKey: "username") as! String
        let secondRuns = secondPlace.value(forKey: "hiscore") as! Int
        let thirdPlace = rankings[2]
        let thirdUsername = thirdPlace.value(forKey: "username") as! String
        let thirdRuns = thirdPlace.value(forKey: "hiscore") as! Int
        let fourthPlace = rankings[3]
        let fourthUsername = fourthPlace.value(forKey: "username") as! String
        let fourthRuns = fourthPlace.value(forKey: "hiscore") as! Int
        let fifthPlace = rankings[4]
        let fifthUsername = fifthPlace.value(forKey: "username") as! String
        let fifthRuns = fifthPlace.value(forKey: "hiscore") as! Int
        let sixthPlace = rankings[5]
        let sixthUsername = sixthPlace.value(forKey: "username") as! String
        let sixthRuns = sixthPlace.value(forKey: "hiscore") as! Int
        let seventhPlace = rankings[6]
        let seventhUsername = seventhPlace.value(forKey: "username") as! String
        let seventhRuns = seventhPlace.value(forKey: "hiscore") as! Int
        let eighthPlace = rankings[7]
        let eighthUsername = eighthPlace.value(forKey: "username") as! String
        let eighthRuns = eighthPlace.value(forKey: "hiscore") as! Int
        let ninthPlace = rankings[8]
        let ninthUsername = ninthPlace.value(forKey: "username") as! String
        let ninthRuns = ninthPlace.value(forKey: "hiscore") as! Int
        let tenthPlace = rankings[9]
        let tenthUsername = tenthPlace.value(forKey: "username") as! String
        let tenthRuns = tenthPlace.value(forKey: "hiscore") as! Int
        
        self.leaderboard.text = "1. " + firstUsername + "  Runs: " + String(firstRuns) + "  $10\n" + "2. " + secondUsername + "  Runs: " + String(secondRuns) + "    $5\n" + "3. " + thirdUsername + "  Runs: " + String(thirdRuns) + "    $0\n" + "4. " + fourthUsername + "  Runs: " + String(fourthRuns) + "    $0\n" + "5. " + fifthUsername + "  Runs: " + String(fifthRuns) + "    $0\n" + "6. " + sixthUsername + "  Runs: " + String(sixthRuns) + "    $0\n" + "7. " + seventhUsername + "  Runs: " + String(seventhRuns) + "    $0\n" + "8. " + eighthUsername + "  Runs: " + String(eighthRuns) + "    $0\n" + "9. " + ninthUsername + "  Runs: " + String(ninthRuns) + "    $0\n" + "10. " + tenthUsername + "  Runs: " + String(tenthRuns) + "    $0\n"
        
    }
    
    func last10TapDetected(){
        
    }
    
    func pupTapDetected() {
        let pupAlert = UIAlertController(title: "Power Innings", message: "There are 3 Power Inning types:\n\nSpeed Demon: Your runners advance an extra base on a hit\n\nAll Triples: Any hit (except for a home run) counts as a triple in the game (but not for your Career Stats) \n\nDouble Points: All runs count as 2 runs\n\nPower Innings are randomly awarded, and they last until your inning ends.  You have a 1/3 chance of getting a Power Inning for any given inning.", preferredStyle: .alert)
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
    func inningsTapDetected() {
        print("inning Clicked")
        let inningsAlert = UIAlertController(title: "Innings", message: "You get 9 innings to post as high a score as possible.  Your highest 9-inning score is posted to the leaderboard, and if you score enough runs, you can win a cash prize!", preferredStyle: .alert)
        let okAction = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default) { (action) in
            
        }
        inningsAlert.addAction(okAction)
        self.present(inningsAlert, animated:true)
    }
    func hiTapDetected() {
        print("Hi-Score Clicked")
        let hiAlert = UIAlertController(title: "Hi-Score", message: "This is your Hi-Score from the current game.  This is the score that will appear on the leaderboard under your username.  Your goal is to get as high a score as possible before you get 27 outs (9 innings).  You win money the higher your score is.", preferredStyle: .alert)
        let okAction = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default) { (action) in
            
        }
        hiAlert.addAction(okAction)
        self.present(hiAlert, animated:true)
    }
    
    func updateStats(){
        print("self.atbats: ",self.atbats)
        if(self.atbats > 0){
            self.avg = Double(self.hits)/Double(self.atbats)
            self.slg = ( Double(self.hits-self.doubles-self.homers) + Double(2*self.doubles) + Double(4*self.homers) )/Double(self.atbats)
            
            self.avg = (self.avg * 1000).rounded() / 1000
            self.slg = (self.slg * 1000).rounded() / 1000
            
            self.statsText.text = "Career Stats\nAVG: "+String(self.avg)+" SLG: "+String(self.slg)
        }else{
            self.statsText.text = "Career Stats\nAVG:\nSLG:"
        }
    }
    
    func closeBallot(){
        let allButtons: [UIButton] = [groundoutButton, airoutKButton, onBaseButton, leftSideButton,rightSideButton,airoutButton,kButton, singleButton,nonSingleButton,overLButton,underLButton,overRButton,underRButton, lfrfButton, cfButton, kSwingingButton, kLookingButton, groundSingleButton, airSingleButton, doubleButton,tripleHomerButton]

        hideNonSelected()
        
        for button in allButtons{
            button.isEnabled = false
            if (pickSubmitted == false){
                button.isHidden = true
            }
        }
        
        
    }
    
    func diamondChange(outcome: String){
        if(outcome == "Home Run"){
            diamond.animationImages = homerDiamondArray;
            runs += 1 + self.diamondState.reduce(0,+)
            if(self.currPup == 3){
                runs += 1 + self.diamondState.reduce(0,+)
            }
            self.runsText.text = "Runs: " + String(self.runs)
            if(self.runs > self.hiscore){
                self.hiscore = self.runs
                self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("hiscore").setValue(self.hiscore)
                self.hiscoreText.text = "Hi-Score: " + String(self.hiscore)
            }
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("runs").setValue(self.runs)
            self.ref.child("users").child((user?.uid)!).child("homers").setValue(self.homers+1)
            self.ref.child("users").child((user?.uid)!).child("hits").setValue(self.hits+1)
            self.ref.child("users").child((user?.uid)!).child("atbats").setValue(self.atbats+1)
            self.homers += 1
            self.atbats += 1
            self.hits += 1
            
            self.diamondState = [0,0,0]
            self.runnersMoved = true
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(0)
            
            self.diamond.startAnimating()
            self.perform(#selector(GameViewController.updateDiamond), with: nil, afterDelay: diamond.animationDuration)
            
            
            
        }else if(outcome == "Out"){
            self.diamond.animationImages = outDiamondArray;
            
            if(self.outs < 2){
                self.outs += 1
            }else{
                self.diamond.animationImages = endDiamondArray;
                self.diamondState = [0,0,0]
                self.runnersMoved = true
                self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(0)
                self.outs = 0
                self.inning = self.inning + 1
                self.currPup = Int(arc4random_uniform(9))
                self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("pup").setValue(self.currPup)
                if(self.inning > 9){
                    self.runs = 0
                    self.inning = 1
                    self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("runs").setValue(self.runs)
                    self.gameStatus.text = "Game Over!"
                    if(self.hiscore > self.allTimeHi){
                        self.allTimeHi = self.hiscore
                        self.ref.child("users").child((user?.uid)!).child("hiscore").setValue(self.allTimeHi)
                    }
                }
            }
            self.outsText.text = "Outs: " + String(self.outs)
            self.inningsText.text = "Inning: " + String(self.inning)
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("outs").setValue(self.outs)
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("inning").setValue(self.inning)
            
            self.atbats += 1
            self.ref.child("users").child((user?.uid)!).child("atbats").setValue(self.atbats)
            
            
            
            
            self.diamond.startAnimating()
            self.perform(#selector(GameViewController.updateDiamond), with: nil, afterDelay: diamond.animationDuration)
            
            //triples
        }else if(self.currPup == 2){
            self.diamond.animationImages = tripleDiamondArray;
            runs += self.diamondState.reduce(0,+)
            
            self.runsText.text = "Runs: " + String(self.runs)
            if(self.runs > self.hiscore){
                self.hiscore = self.runs
                self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("hiscore").setValue(self.hiscore)
                self.hiscoreText.text = "Hi-Score: " + String(self.hiscore)
            }
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("runs").setValue(self.runs)
            self.ref.child("users").child((user?.uid)!).child("homers").setValue(self.homers+1)
            self.ref.child("users").child((user?.uid)!).child("hits").setValue(self.hits+1)
            self.ref.child("users").child((user?.uid)!).child("atbats").setValue(self.atbats+1)
            self.homers += 1
            self.atbats += 1
            self.hits += 1
            
            self.diamondState = [0,0,1]
            self.runnersMoved = true
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(7)
            
            self.diamond.startAnimating()
            self.perform(#selector(GameViewController.updateDiamond), with: nil, afterDelay: diamond.animationDuration)
            
            
        }else if(outcome == "Single"){
            self.diamond.animationImages = singleDiamondArray;
            if(self.currPup == 1){
                self.runs += self.diamondState[2] + self.diamondState[1]
            }
            else if(self.diamondState[2] == 1){
                self.runs += 1
                if(self.currPup == 3){
                    runs += 1
                }
            }
            self.runsText.text = "Runs: " + String(self.runs)
            if(self.runs > self.hiscore){
                self.hiscore = self.runs
                self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("hiscore").setValue(self.hiscore)
                self.hiscoreText.text = "Hi-Score: " + String(self.hiscore)
            }
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("runs").setValue(self.runs)

            self.ref.child("users").child((user?.uid)!).child("hits").setValue(self.hits+1)
            self.ref.child("users").child((user?.uid)!).child("atbats").setValue(self.atbats+1)

            self.atbats += 1
            self.hits += 1
            if(self.currPup != 1){
                
            
                if (self.diamondState == [0,0,0] || self.diamondState == [0,0,1]){
                    self.diamondState = [1,0,0]
                    self.runnersMoved = true
                    self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(1)
                
                }else if( self.diamondState == [1,0,0] || self.diamondState == [1,0,1]){
                    self.diamondState = [1,1,0]
                    self.runnersMoved = true
                    self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(2)

                }else if( self.diamondState == [0,1,0] || self.diamondState == [0,1,1]){
                    self.diamondState = [1,0,1]
                    self.runnersMoved = true
                    self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(3)
                
                }else if( self.diamondState == [1,1,1] || self.diamondState == [1,1,0]){
                    self.diamondState = [1,1,1]
                    self.runnersMoved = true
                    self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(4)
                
                }
            }else{
                if (self.diamondState == [0,0,0] || self.diamondState == [0,0,1] || self.diamondState == [0,1,0]){
                    self.diamondState = [1,0,0]
                    self.runnersMoved = true
                    self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(1)
                    
                }else if( self.diamondState == [1,1,1] || self.diamondState == [1,1,0] || self.diamondState == [0,1,1] || self.diamondState == [1,0,0] || self.diamondState == [1,0,1]){
                    self.diamondState = [1,0,1]
                    self.runnersMoved = true
                    self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(3)
                    
                }
            }
            self.diamond.startAnimating()
            self.perform(#selector(GameViewController.updateDiamond), with: nil, afterDelay: diamond.animationDuration)
            
            
        }else if(outcome == "Double"){
            self.diamond.animationImages = doubleDiamondArray;
            
            if(self.diamondState[2] == 1){
                self.runs += 1
                if(self.currPup == 3){
                    runs += 1
                }
            }
            if(self.diamondState[1] == 1){
                self.runs += 1
                if(self.currPup == 3){
                    runs += 1
                }
            }
            if(self.diamondState[0] == 1 && self.currPup == 1){
                self.runs += 1
                
            }
            
            self.runsText.text = "Runs: " + String(self.runs)
            if(self.runs > self.hiscore){
                self.hiscore = self.runs
                self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("hiscore").setValue(self.hiscore)
                self.hiscoreText.text = "Hi-Score: " + String(self.hiscore)
            }
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("runs").setValue(self.runs)
            self.ref.child("users").child((user?.uid)!).child("doubles").setValue(self.doubles+1)
            self.ref.child("users").child((user?.uid)!).child("hits").setValue(self.hits+1)
            self.ref.child("users").child((user?.uid)!).child("atbats").setValue(self.atbats+1)
            self.doubles += 1
            self.atbats += 1
            self.hits += 1
            
            if(self.currPup != 1){
            
                if (self.diamondState == [0,0,0] || self.diamondState == [0,0,1] || self.diamondState == [0,1,1] || self.diamondState == [0,1,0]){
                    self.diamondState = [0,1,0]
                    self.runnersMoved = true
                    self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(5)
                
                }else if( self.diamondState == [1,0,0] || self.diamondState == [1,0,1] || self.diamondState == [1,1,0] || self.diamondState == [1,1,1]){
                    self.diamondState = [0,1,1]
                    self.runnersMoved = true
                    self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(6)
                }
            }else{
                self.diamondState = [0,1,0]
                self.runnersMoved = true
                self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(5)
            }
            
            self.diamond.startAnimating()
            self.runnersMoved = true
            self.perform(#selector(GameViewController.updateDiamond), with: nil, afterDelay: diamond.animationDuration)
        }

        updateStats()
        
        
        
    }
    
    func updateDiamond(){
        
        self.diamond.stopAnimating()
        
        
        if(self.diamondState == [0,0,0]){
            self.diamond.image = stateArray[0]
            if(self.currentGame != ""){
                self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(0)
            }
        }else if(self.diamondState == [1,0,0]){
            self.diamond.image = stateArray[1]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(1)
            
        }else if(self.diamondState == [1,1,0]){
            self.diamond.image = stateArray[2]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(2)
            
        }else if(self.diamondState == [1,0,1]){
            self.diamond.image = stateArray[3]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(3)
            
        }else if(self.diamondState == [1,1,1]){
            self.diamond.image = stateArray[4]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(4)
            
        }else if(self.diamondState == [0,1,0]){
            self.diamond.image = stateArray[5]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(5)
            
        }else if(self.diamondState == [0,1,1]){
            self.diamond.image = stateArray[6]
            self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("diamond").setValue(6)
            
        }else if(self.diamondState == [0,0,1]){
            self.diamond.image = stateArray[7]
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
            self.gameStatus.text = "MAKE YOUR PICKS!"
            self.gameStatus.textColor = UIColor.orange
            
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
        }else if(self.pickSubmitted == false){
            self.gameStatus.text = "You skipped this AB"
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
            
            self.gameStatus.text = "You hit a Home Run!"
            self.gameStatus.textColor = UIColor.green
            
            self.playCount += 1
            
            diamondChange(outcome: "Home Run")
            
        }else if(lastPick == "none yet" || last10.text == "Your last 10:" || lastPick == ""){
            
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
            
            self.gameStatus.text = "You hit a Double!"
            self.gameStatus.textColor = UIColor.green
            
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
            
            self.gameStatus.text = "You hit a Double!"
            self.gameStatus.textColor = UIColor.green
            
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
            
            self.gameStatus.text = "You hit a Double!"
            self.gameStatus.textColor = UIColor.green
            
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
            
            self.gameStatus.text = "You hit a Double!"
            self.gameStatus.textColor = UIColor.green
            
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
            
            self.gameStatus.text = "You hit a Double!"
            self.gameStatus.textColor = UIColor.green
            
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
            
            self.gameStatus.text = "You hit a Double!"
            self.gameStatus.textColor = UIColor.green
            
            self.playCount += 1
            
            diamondChange(outcome: "Double")
        }
            
            
            //************** SINGLE OUTCOMES BUD! ***********************************
            //single for groundoutL selection
        else if(groundoutLOutcomes.contains(lastPick) && (groundoutLOutcomes.contains(self.lastPlay) || groundoutROutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if((self.lastPlay != "underL" || self.lastPlay != "overL")){
                        groundoutButton.backgroundColor = UIColor.green
                        leftSideButton.backgroundColor = UIColor.red
                        underLButton.backgroundColor = UIColor.red
                        overLButton.backgroundColor = UIColor.red
                    }
                    
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.gameStatus.text = "You hit a Single!"
            self.gameStatus.textColor = UIColor.green
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }
            //single for groundoutR selection
        else if(groundoutROutcomes.contains(lastPick) && (groundoutROutcomes.contains(self.lastPlay) || groundoutLOutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if((self.lastPlay != "underR" || self.lastPlay != "overR")){
                        groundoutButton.backgroundColor = UIColor.green
                        rightSideButton.backgroundColor = UIColor.red
                        underRButton.backgroundColor = UIColor.red
                        overRButton.backgroundColor = UIColor.red
                    }
                    
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.gameStatus.text = "You hit a Single!"
            self.gameStatus.textColor = UIColor.green
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }
            //single for airoutK airout selection
        else if(airoutKAiroutOutcomes.contains(lastPick) && (airoutKAiroutOutcomes.contains(self.lastPlay) || airoutKKOutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if((self.lastPlay != "lfrf" || self.lastPlay != "cf")){
                        airoutKButton.backgroundColor = UIColor.green
                        airoutButton.backgroundColor = UIColor.red
                        lfrfButton.backgroundColor = UIColor.red
                        cfButton.backgroundColor = UIColor.red
                    }
                    
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.gameStatus.text = "You hit a Single!"
            self.gameStatus.textColor = UIColor.green
            
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }
            //single for airoutK K selection
        else if(airoutKKOutcomes.contains(lastPick) && (airoutKKOutcomes.contains(self.lastPlay) || airoutKAiroutOutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if((self.lastPlay != "kSwinging" || self.lastPlay != "kLooking")){
                        airoutKButton.backgroundColor = UIColor.green
                        kButton.backgroundColor = UIColor.red
                        kSwingingButton.backgroundColor = UIColor.red
                        kLookingButton.backgroundColor = UIColor.red
                    }
                    
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.gameStatus.text = "You hit a Single!"
            self.gameStatus.textColor = UIColor.green
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }
            //single for onBase Single selection
        else if(onBaseSingleOutcomes.contains(lastPick) && (onBaseSingleOutcomes.contains(self.lastPlay) || onBaseNonSingleOutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if((self.lastPlay != "airsingle" || self.lastPlay != "groundsingle")){
                        onBaseButton.backgroundColor = UIColor.green
                        singleButton.backgroundColor = UIColor.red
                        airSingleButton.backgroundColor = UIColor.red
                        groundSingleButton.backgroundColor = UIColor.red
                    }
                    
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.gameStatus.text = "You hit a Single!"
            self.gameStatus.textColor = UIColor.green
            
            self.playCount += 1
            
            diamondChange(outcome: "Single")
        }
            //single for onBase NonSingle selction
        else if(onBaseNonSingleOutcomes.contains(lastPick) && (onBaseNonSingleOutcomes.contains(self.lastPlay) || onBaseSingleOutcomes.contains(self.lastPlay))){
            for button in allButtons{
                if(!button.isHidden){
                    if((self.lastPlay != "double" || self.lastPlay != "triplehomer")){
                        onBaseButton.backgroundColor = UIColor.green
                        nonSingleButton.backgroundColor = UIColor.red
                        doubleButton.backgroundColor = UIColor.red
                        tripleHomerButton.backgroundColor = UIColor.red
                    }
                    
                }
            }
            self.resultHistory.append("Single")
            updateDefaults(outcome: "Single")
            
            self.gameStatus.text = "You hit a Single!"
            self.gameStatus.textColor = UIColor.green
            
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
            
            self.gameStatus.text = "You got out!"
            self.gameStatus.textColor = UIColor.red
            
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
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
    }
    func tripleHomerSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: tripleHomerButton, otherButton: doubleButton)
        hideNonSelected()
        lastPick = "triplehomer"
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
    }
    func airSingleSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: airSingleButton, otherButton: groundSingleButton)
        hideNonSelected()
        lastPick = "airsingle"
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
    }
    func groundSingleSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: groundSingleButton, otherButton: airSingleButton)
        hideNonSelected()
        lastPick = "groundsingle"
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
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
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
    }
    func cfSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: cfButton, otherButton: lfrfButton)
        hideNonSelected()
        lastPick = "cf"
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
    }
    func kSwingingSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: kSwingingButton, otherButton: kLookingButton)
        hideNonSelected()
        lastPick = "kSwinging"
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
    }
    func kLookingSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: kLookingButton, otherButton: kSwingingButton)
        hideNonSelected()
        lastPick = "kLooking"
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
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
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
    }
    func overLSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: overLButton, otherButton: underLButton)
        hideNonSelected()
        lastPick = "overL"
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
    }
    func underRSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: underRButton, otherButton: overRButton)
        hideNonSelected()
        lastPick = "underR"
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
    }
    func overRSelected(_ sender: UIButton){
        //SUBMIT PICKS
        updateButtons(mainButton: overRButton, otherButton: underRButton)
        hideNonSelected()
        lastPick = "overR"
        self.ref.child("games").child(self.currentGame).child("leaderboard").child((user?.uid)!).child("lastPick").setValue(lastPick)
        pickSubmitted = true
        self.gameStatus.text = "Submitted!"
        self.gameStatus.textColor = UIColor.green
        self.menuButton.isEnabled = false
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
