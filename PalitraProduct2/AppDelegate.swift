//
//  AppDelegate.swift
//  PalitraProduct2
//
//  Created by Pol Krm on 12.07.22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if user == nil {
                self.showModalAuth()
                print("Mark authvc present")
            } else {
                print("Mark user did auth")
            }
        }
        return true
    }
    
    private func showModalAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let authVC = storyboard.instantiateViewController(withIdentifier: "\(AuthVC.self)") as? AuthVC else { return }
        self.window?.rootViewController?.tabBarController?.present(authVC, animated: true, completion: nil)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

