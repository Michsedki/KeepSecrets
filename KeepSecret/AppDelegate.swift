//
//  AppDelegate.swift
//  KeepSecret
//
//  Created by Michael Tanious on 4/10/17.
//  Copyright © 2017 winmacworldIOS. All rights reserved.
//

import UIKit
import CoreData

// Globel variable refere to appDelegate to be able to call it from any class / file.swift
let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

let colorSmoothRed = UIColor(red: 255/255, green: 50/255, blue: 75/255, alpha: 1)
let colorLightGreen = UIColor(red: 30/255, green: 244/255, blue: 125/255, alpha: 1)

let fontSize12 = UIScreen.main.bounds.width / 31



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // boolean to check if errorView is currently showing or not
    var infoViewIsShowing = false
    
    // error view on top
    
    func infoView( message:String, color: UIColor) {
        
        //if errorView is not showing
        if infoViewIsShowing == false {
            
            // cast as errorview is currently showing
            infoViewIsShowing = true
            
            // errorView - red background creation
            let infoView_Hieght = self.window!.bounds.height / 14.2
            let infoView_Y = 0 - infoView_Hieght
            
            let infoView = UIView()
            infoView.frame = CGRect(x: 0, y: infoView_Y, width: self.window!.bounds.width, height: infoView_Hieght)
            
            
            infoView.backgroundColor = color
            self.window!.addSubview(infoView)
            
            // errorLabel - label to show error text
            let infoLabel_Width = infoView.bounds.width
            let infoLabel_Hieght = infoView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
            
            let infoLabel = UILabel()
            infoLabel.frame.size.width = infoLabel_Width
            infoLabel.frame.size.height = infoLabel_Hieght
            infoLabel.numberOfLines = 0
            infoLabel.text = message
            infoLabel.font = UIFont(name: "HelveticaNeue", size: fontSize12)
            infoLabel.textColor = UIColor.white
            infoLabel.textAlignment = .center
            infoView.addSubview(infoLabel)
            
            // animate error view
            
            UIView.animate(withDuration: 0.3, animations: {
                // move down error view
                infoView.frame.origin.y = 0
                
                // if animation did finish
            }, completion: { (finished : Bool) in
                // if it is true
                if (finished) {
                    
                    UIView.animate(withDuration: 0.3, delay: 1, options: .curveLinear, animations: {
                        
                        // move up error view
                        infoView.frame.origin.y = infoView_Y
                        
                        // if finished all animations
                    }, completion: { (finished: Bool) in
                        if finished {
                            
                            
                            infoView.removeFromSuperview()
                            infoLabel.removeFromSuperview()
                            self.infoViewIsShowing = false
                        }
                    })
                    
                    
                }
            })
            
        }
    }
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "KeepSecret")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

// shortcuts to appdelegate and context
let ad = UIApplication.shared.delegate as! AppDelegate
let context = ad.persistentContainer.viewContext
