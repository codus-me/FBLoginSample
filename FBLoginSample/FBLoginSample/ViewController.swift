//
//  ViewController.swift
//  FBLoginSample
//
//  Created by 許銘修 on 2017/7/19.
//  Copyright © 2017年 Codus. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet var avatarImageView : UIImageView!
    @IBOutlet var idLabel : UILabel!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var loginButton : UIButton!

    @IBAction func bindFB() {
        
        if FBSDKAccessToken.current() != nil {
            // already login!
            loadProfile()
            return
        }
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile","email"], from: self, handler: { action, previewViewController in
            if action != nil {
                if let cancel = action?.isCancelled {
                    //let tokenInfo = action?.token
                    
                    if !cancel {
                        self.loadProfile()
                    }
                }
            } else {
                print("未知的錯誤")
            }
        })
    }
    
    func loadProfile() {
        loginButton.isHidden = true
        FBSDKProfile.loadCurrentProfile(completion: {
            profile, error in
            if let profile = profile {
                self.loadAvatar(url: profile.imageURL(for: .square, size: CGSize(width: 120, height: 120)))
                self.nameLabel.text = "名字： " + profile.name
                self.idLabel.text = "ID： " + profile.userID
            } else {
                print("current user still not got")
            }
        })
    }
    
    func loadAvatar(url: URL) {
        do {
            let data = try Data.init(contentsOf: url)
            avatarImageView.image = UIImage(data: data)
        } catch {
            print("get avatar failed: \(error)")
        }
    }
}

