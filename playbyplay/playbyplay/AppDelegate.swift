//
//  AppDelegate.swift
//  playbyplay
//
//  Created by Ryan Rizzo on 2/20/17.
//  Copyright © 2017 Ryan Rizzo. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var ref: FIRDatabaseReference!
    
    var user = FIRAuth.auth()?.currentUser
    
    override init() {
        FIRApp.configure()
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1201291908172803~5124384971")
        if FIRAuth.auth()?.currentUser != nil {

            self.ref = FIRDatabase.database().reference()
            self.user = FIRAuth.auth()?.currentUser
        }
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().barTintColor = UIColor.yellow
        UINavigationBar.appearance().tintColor = UIColor.black
        
//        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        
        return true
    }


//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        
//                let fetchViewController = GameViewController()
//        
//                fetchViewController.fetch()
//        
//                completionHandler(.newData)
//        
//        
//        
//    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if FIRAuth.auth()?.currentUser != nil {
        self.ref.child("users").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let currUserDict = snapshot.value as? NSDictionary
            
            let currentGame = currUserDict?.value(forKey: "currentGame") as! String
            
        if(self.ref.child("games").child(currentGame).child("leaderboard").child((self.user?.uid)!).value(forKey: "lastPick") as! String != ""){
            
            var outs = self.ref.child("games").child(currentGame).child("leaderboard").child((self.user?.uid)!).value(forKey: "outs") as! Int
            
            var inning = self.ref.child("games").child(currentGame).child("leaderboard").child((self.user?.uid)!).value(forKey: "inning") as! Int
            
            var diamond = self.ref.child("games").child(currentGame).child("leaderboard").child((self.user?.uid)!).value(forKey: "diamond") as! Int
            
            if(outs < 2){
                outs += 1
            }else{
                outs = 0
                diamond = 0
            }
            self.ref.child("games").child(currentGame).child("leaderboard").child((self.user?.uid)!).child("outs").setValue(outs)
            
            self.ref.child("games").child(currentGame).child("leaderboard").child((self.user?.uid)!).child("diamond").setValue(diamond)
            
            
            if(inning < 6){
                inning += 1
            }else{
                inning = 1
                self.ref.child("games").child(currentGame).child("leaderboard").child((self.user?.uid)!).child("runs").setValue(0)
                self.ref.child("games").child(currentGame).child("leaderboard").child((self.user?.uid)!).child("lastPick").setValue("")
            }
                
        }
        
            
        
        }) { (error) in
            print(error.localizedDescription)
        }

        }
    }
}
