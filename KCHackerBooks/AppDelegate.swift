//
//  AppDelegate.swift
//  KCHackerBooks
//
//  Created by Bhavish Chandnani on 8/7/16.
//  Copyright © 2016 BVC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Crear una window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        do{
            //var changeURL : Bool =  false
        let defaults = NSUserDefaults.standardUserDefaults()
        var json : JSONArray = []
        if let name = defaults.objectForKey(Const.UserDefaultKeys.jsonFile) as? String{
            let filePath = try PathForFile(name, directory: nil)
            print (filePath)
            json = try loadJSONFromLocalFile(filePath)
            
        } else {
            json = try DownloadJSON()
            defaults.setObject(Const.FilesName.booksFile, forKey: Const.UserDefaultKeys.jsonFile)
        }
            
        var chars = [BVCBook]()
            var tags : [String] = []
        for dict in json{
            do{
                let char = try decode (hackerBook: dict)
                chars.append(char)
                tags = fillArrayWithNotRepeatedElements(tags, elementsToAdd: char.tags)
            }catch{
                print("Error al procesar \(dict)")
            }
        }
            
        let favorites = loadFavoritesBooks()
        
        let model = BVCLibrary (books: chars, tags: tags, favoriteBooks: favorites)
         print("Model loaded")
            
            let rootVC : UIViewController
            
            if(!(UIDevice.currentDevice().userInterfaceIdiom == .Phone)){
                rootVC = viewControllerForIpadWithModel(model)
            }else{
                rootVC = viewControllersForIphoneWithModel(model)
            }
            
        window?.rootViewController = rootVC
        // Hacer visible & key a la window
        window?.makeKeyAndVisible()

        return true
    }catch{
        fatalError("Error launching App")
    }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func viewControllersForIphoneWithModel(model: BVCLibrary) -> UIViewController {
        let libraryVC = BVCLibraryTableViewController (model: model)
        
        let libraryNavVC = UINavigationController (rootViewController: libraryVC)
        
        libraryVC.delegate = libraryVC
        
        return libraryNavVC
    }
    
    func viewControllerForIpadWithModel(model: BVCLibrary) -> UIViewController {
        let splitVC = UISplitViewController()
        
        if let tags = model.tags{
            let firstTagBooks = model.booksForTag(tags[0])
        
            let bookVC = BVCBookViewController(model: firstTagBooks![0])
        
            let bookNavVC = UINavigationController (rootViewController: bookVC)
        
            let libraryVC = BVCLibraryTableViewController (model: model)
        
            let libraryNavVC = UINavigationController (rootViewController: libraryVC)
        
            splitVC.viewControllers = [libraryNavVC, bookNavVC]
        
            splitVC.delegate = bookVC
        
            libraryVC.delegate = bookVC
        }
        
        return splitVC

    }

}

