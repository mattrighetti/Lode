//
//  AppDelegate.swift
//  UniRadar
//
//  Created by Mattia Righetti on 30/09/2019.
//  Copyright © 2019 Mattia Righetti. All rights reserved.
//

import CoreData
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var viewModel: ViewModel?
    var appState: AppState?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.

        // Make NavigationView the same color as the background
        //        UINavigationBar.appearance().backgroundColor = UIColor(named: "background")
        // Make NavigationView the same color as the background
        // NB: This was needed because the largeTitle wasn't updating after applying the code above
        //        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "text")!]

        // Make Dividers the same color as the background to make them disappear
        UITableView.appearance().separatorStyle = .none
        // Set List background color
        UITableView.appearance().backgroundColor = UIColor(named: "background")
        UITableViewCell.appearance().backgroundColor = UIColor(named: "background")
        UITableViewCell.appearance().selectionStyle = .none
        UIPickerView.appearance().backgroundColor = UIColor(named: "cardBackground")
        UIScrollView.appearance().backgroundColor = UIColor(named: "background")
        
        initModel()

        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func initModel() {
        let context = self.persistentContainer.viewContext
        self.viewModel = ViewModel(context: context)
        self.appState = AppState()
        
        if ((self.appState?.initialSetup) != nil) {
            self.viewModel?.totalCfu = UserDefaults.standard.integer(forKey: "totalCfu")
            self.viewModel?.laudeValue = UserDefaults.standard.integer(forKey: "laudeValue")
        }
    }

}
