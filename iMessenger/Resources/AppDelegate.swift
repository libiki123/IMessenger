//
//  AppDelegate.swift
//  iMessenger
//
//  Created by Nikki Truong on 2020-10-12.
//  Copyright © 2020 EthanTruong. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self

        return true
    }
          
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                print("Fail to sign in with Google: \(error)")
            }
            return
        }
        
        guard let email = user.profile.email,
              let username = user.profile.name
        else {
            
            return
        }
        
        DatabaseManager.shared.userExists(with: email, completion: {exists in
            if !exists {
                // Insert to database
                DatabaseManager.shared.insertUser(with: ChatAppUser(userName: username, emailAddress: email))
            }
        })
        
        guard let authentication = user.authentication else {
            print("Missing auth object of Google user")
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: {authResult, error in
            guard authResult != nil, error == nil else {
                print("Fail to login with Google credential")
                return
            }
            
            print("Successfully signed in with Google credential")
            NotificationCenter.default.post(name: .didLoginNotification, object: nil)
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user was disconnected")
    }
}
