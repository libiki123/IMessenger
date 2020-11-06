//
//  ProfileViewerViewController.swift
//  iMessenger
//
//  Created by Nikki Truong on 2020-10-12.
//  Copyright © 2020 EthanTruong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewerViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    let data = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ProfileViewerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "",
                                      message: "",
                                      preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                      style: .destructive,
                                      handler: { [weak self]_ in
                                        
                                        guard let strongSelf = self else {
                                            return
                                        }
                                        
                                        // logout Facebook
                                        FBSDKLoginKit.LoginManager().logOut()
                                        
                                        // Sign out Google
                                        GIDSignIn.sharedInstance()?.signOut()
                                        
                                        do {
                                            try FirebaseAuth.Auth.auth().signOut()
                                            
                                            let vc = LoginViewController()
                                            let nav = UINavigationController(rootViewController: vc)
                                            nav.modalPresentationStyle = .fullScreen
                                            strongSelf.present(nav, animated: true)
                                        } catch {
                                            print("fail logout")
                                        }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        present(actionSheet, animated: true)
       
    }
}
