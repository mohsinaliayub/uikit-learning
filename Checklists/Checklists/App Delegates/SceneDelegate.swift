//
//  SceneDelegate.swift
//  Checklists
//
//  Created by Mohsin Ali Ayub on 26.08.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let dataModel = DataModel()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let navigationController = window!.rootViewController as! UINavigationController
        let allListsViewController = navigationController.viewControllers[0] as! AllListsViewController
        allListsViewController.dataModel = dataModel
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        saveData()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        saveData()
    }
    
    func saveData() {
        dataModel.saveChecklists()
    }
    
}

