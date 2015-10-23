//
//  mainViewController.swift
//  Infuse Beacon
//
//  Created by waynehui on 23/10/15.
//  Copyright © 2015年 waynehui. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Home Page"
        titleLabel.font = UIFont(name: MegaTheme.semiBoldFontName, size: 45)
        
        signOutButton.setTitle("Sign Out", forState: .Normal)
        signOutButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        signOutButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 22)
        signOutButton.layer.borderWidth = 3
        signOutButton.layer.borderColor = UIColor.redColor().CGColor
        signOutButton.layer.cornerRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let isLoggedIn:Bool = NSUserDefaults.standardUserDefaults().boolForKey("userLoggedIn")
        
        if(!isLoggedIn)
        {
            self.performSegueWithIdentifier("signInView", sender: self)
        }
    }
    
    @IBAction func signOut(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "userLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.performSegueWithIdentifier("signInView", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
