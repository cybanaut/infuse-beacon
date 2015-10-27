//
//  signInViewController.swift
//  Infuse Beacon
//
//  Created by waynehui on 23/10/15.
//  Copyright © 2015年 waynehui. All rights reserved.
//

import UIKit

class signInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleLabel : UILabel!
    
    @IBOutlet var facebookButton : UIButton!
    @IBOutlet var twitterButton : UIButton!
    
    @IBOutlet var bgImageView : UIImageView!
    
    @IBOutlet var noAccountButton : UIButton!
    @IBOutlet var signInButton : UIButton!
    
    @IBOutlet var forgotPassword : UIButton!
    
    @IBOutlet var passwordContainer : UIView!
    @IBOutlet var passwordLabel : UILabel!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet var passwordUnderline : UIView!
    
    @IBOutlet var userContainer : UIView!
    @IBOutlet var userLabel : UILabel!
    @IBOutlet var userTextField : UITextField!
    @IBOutlet var userUnderline : UIView!

    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImageView.image = UIImage(named: "nav-bg-2")
        bgImageView.contentMode = .ScaleAspectFill
        
        titleLabel.text = "Sign In"
        titleLabel.font = UIFont(name: MegaTheme.semiBoldFontName, size: 45)
        titleLabel.textColor = UIColor.whiteColor()
        
        twitterButton.setTitle("Sign in with Twitter", forState: .Normal)
        twitterButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        twitterButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        twitterButton.backgroundColor = UIColor(red: 0.23, green: 0.43, blue: 0.88, alpha: 1.0)
        twitterButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        facebookButton.setTitle("Sign in with Facebook", forState: .Normal)
        facebookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        facebookButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 16)
        facebookButton.backgroundColor = UIColor(red: 0.21, green: 0.30, blue: 0.55, alpha: 1.0)
        facebookButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        
        let attributedText = NSMutableAttributedString(string: "Don't have an account? Sign up")
        attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(23, 7))
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0, attributedText.length))
        
        noAccountButton.setAttributedTitle(attributedText, forState: .Normal)
        noAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        noAccountButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size:14)
        noAccountButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 22)
        signInButton.layer.borderWidth = 3
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        signInButton.layer.cornerRadius = 5
        signInButton.addTarget(self, action: Selector("signIn"), forControlEvents: .TouchUpInside)
        
        forgotPassword.setTitle("Forgot Password?", forState: .Normal)
        forgotPassword.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        forgotPassword.titleLabel?.font = UIFont(name: MegaTheme.semiBoldFontName, size: 15)
        forgotPassword.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
        
        passwordContainer.backgroundColor = UIColor.clearColor()
        
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordLabel.textColor = UIColor.whiteColor()
        
        passwordTextField.text = ""
        passwordTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.secureTextEntry = true
        
        userContainer.backgroundColor = UIColor.clearColor()
        
        userLabel.text = "Email"
        userLabel.font = UIFont(name: MegaTheme.fontName, size: 20)
        userLabel.textColor = UIColor.whiteColor()
        
        userTextField.text = ""
        userTextField.font = UIFont(name: MegaTheme.fontName, size: 20)
        userTextField.textColor = UIColor.whiteColor()
        
        self.userTextField.delegate = self;
        self.passwordTextField.delegate = self;

    }
    
    func signIn(){
        
        
        
        print("yes")
        let loginIdEmail:String = userTextField.text!
        let password:String = passwordTextField.text!
        
        if (loginIdEmail.isEmpty || password.isEmpty){
            displayAlertMessage("Login ID and Password required!")
            return
        }
        
        let serverURL = "http://beacon.infusecreativeinc.com/server/submitLogin.php"
        let urlString = serverURL + "?login=" + loginIdEmail + "&password=" + password
        
        let session = NSURLSession.sharedSession()
        let shotsUrl = NSURL(string: urlString)
        
        let task = session.dataTaskWithURL(shotsUrl!){
            (data, response, error) -> Void in
            
            print("Response: \(response)")
            let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                let json: NSDictionary?
                do {
                    self.mySpinner.startAnimating()
                    
                    json = try NSJSONSerialization.JSONObjectWithData(data! , options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    if let parseJSON = json {
                        // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                        let success = parseJSON["return_code"] as? Int
                        print("Succes: \(success)")
                        
                        if(success==0){
                            //Login success
                            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "userLoggedIn")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }else{
                            //let error_title = parseJSON["error_title"] as? String
                            var error_message = parseJSON["error_message"] as? String
                            error_message = error_message!.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                            /*
                            let alertMsg = UIAlertController(title: error_title, message: error_message, preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                            
                            alertMsg.addAction(okAction)
                            
                            self.presentViewController(alertMsg, animated: true, completion: nil)
*/
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.displayAlertMessage(error_message!)
                            }
                            
                        }
                        
                        self.mySpinner.stopAnimating()
                        
                    }
                }catch let dataError {
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    print(dataError)
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: '\(jsonStr)'")
                    // return or throw?
                    return
                }
            }
        }
        task.resume()
    }

    func displayAlertMessage(displayMessage:String){
        
        let alertMsg = UIAlertController(title: "Alert", message: displayMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alertMsg.addAction(okAction)
        
        self.presentViewController(alertMsg, animated: true, completion: nil)
    }

    func dismiss(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        titleLabel.hidden = newCollection.verticalSizeClass == UIUserInterfaceSizeClass.Compact    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
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
