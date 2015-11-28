//
//  LoginViewController.swift
//  TrackFood
//
//  Created by 李继庠 on 28/11/15.
//  Copyright © 2015 Nus. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    var signupActive = true
    
    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var welcomeBackLabel: UILabel!
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userID.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func login(sender: AnyObject) {
        
//        textFieldShouldReturn(userID)
//        textFieldShouldReturn(password)
//        let login:LoginModel = LoginModel()
//        let result:Bool = login.verifyUserandPassword(userID.text!, password: password.text!)
//        if (!result){
//            printMessage("Incorrect userID or password!")
//        }else{
//            printMessage("Welcome to the application!")
//            self.performSegueWithIdentifier("loginSegue", sender: sender)
//        }
        
    }
    
    func printMessage(name:String){
        
        //        let alertPopUp:UIAlertController = UIAlertController(title: "Alert", message: name, preferredStyle: UIAlertControllerStyle.Alert)
        //
        //        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) {action->Void in}
        //
        //        alertPopUp.addAction(cancelAction)
        //        self.presentViewController(alertPopUp, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        userID.delegate = self
//        password.delegate = self
        
        
        // Do any additional setup after loading the view.
        welcomeBackLabel.hidden = true
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func signUpTap(sender: AnyObject) {
    
        if signupActive == true{
            //excute sign
            //signUp()
        }else{
            //login()
        }
    
    }
    
    
    @IBAction func loginTap(sender: AnyObject) {
    
        if signupActive == true {
            
            SignUpButton.setTitle("Log In", forState: UIControlState.Normal)
            
            statusLabel.text = "Not registered?"
            
            LoginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signupActive = false
            confirmPassword.hidden = true
            welcomeBackLabel.hidden = false
            
            
        } else {
            
            SignUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            statusLabel.text = "Already registered?"
            
            LoginButton
                
                .setTitle("Login", forState: UIControlState.Normal)
            
            signupActive = true
            confirmPassword.hidden = false
             welcomeBackLabel.hidden = true
        }

    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
//    func signUp(){
//        
//        var username:NSString = self.userID.text! as NSString
//        var password:NSString = self.password.text! as NSString
//        var confirm_password:NSString = txtConfirmPassword.text as NSString
//        
//        if ( username.isEqualToString("") || password.isEqualToString("") ) {
//            
//            var alertView:UIAlertView = UIAlertView()
//            alertView.title = "Sign Up Failed!"
//            alertView.message = "Please enter Username and Password"
//            alertView.delegate = self
//            alertView.addButtonWithTitle("OK")
//            alertView.show()
//        } else if ( !password.isEqual(confirm_password) ) {
//            
//            var alertView:UIAlertView = UIAlertView()
//            alertView.title = "Sign Up Failed!"
//            alertView.message = "Passwords doesn't Match"
//            alertView.delegate = self
//            alertView.addButtonWithTitle("OK")
//            alertView.show()
//        } else {
//            
//            var post:NSString = "username=\(username)&password=\(password)&c_password=\(confirm_password)"
//            
//            NSLog("PostData: %@",post);
//            
//            var url:NSURL = NSURL(string: "https://dipinkrishna.com/jsonsignup.php")!
//            
//            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
//            
//            var postLength:NSString = String( postData.length )
//            
//            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//            request.HTTPMethod = "POST"
//            request.HTTPBody = postData
//            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//            
//            
//            var reponseError: NSError?
//            var response: NSURLResponse?
//            
//            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
//            
//            if ( urlData != nil ) {
//                let res = response as NSHTTPURLResponse!;
//                
//                NSLog("Response code: %ld", res.statusCode);
//                
//                if (res.statusCode >= 200 && res.statusCode < 300)
//                {
//                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
//                    
//                    NSLog("Response ==> %@", responseData);
//                    
//                    var error: NSError?
//                    
//                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
//                    
//                    
//                    let success:NSInteger = jsonData.valueForKey("success") as NSInteger
//                    
//                    //[jsonData[@"success"] integerValue];
//                    
//                    NSLog("Success: %ld", success);
//                    
//                    if(success == 1)
//                    {
//                        NSLog("Sign Up SUCCESS");
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                    } else {
//                        var error_msg:NSString
//                        
//                        if jsonData["error_message"] as? NSString != nil {
//                            error_msg = jsonData["error_message"] as NSString
//                        } else {
//                            error_msg = "Unknown Error"
//                        }
//                        var alertView:UIAlertView = UIAlertView()
//                        alertView.title = "Sign Up Failed!"
//                        alertView.message = error_msg
//                        alertView.delegate = self
//                        alertView.addButtonWithTitle("OK")
//                        alertView.show()
//                        
//                    }
//                    
//                } else {
//                    var alertView:UIAlertView = UIAlertView()
//                    alertView.title = "Sign Up Failed!"
//                    alertView.message = "Connection Failed"
//                    alertView.delegate = self
//                    alertView.addButtonWithTitle("OK")
//                    alertView.show()
//                }
//            }  else {
//                var alertView:UIAlertView = UIAlertView()
//                alertView.title = "Sign in Failed!"
//                alertView.message = "Connection Failure"
//                if let error = reponseError {
//                    alertView.message = (error.localizedDescription)
//                }
//                alertView.delegate = self
//                alertView.addButtonWithTitle("OK")
//                alertView.show()
//            }
//        }
//        
//    }
//    
//    func login(){
//        
//        var username:NSString = txtUsername.text
//        var password:NSString = txtPassword.text
//        
//        if ( username.isEqualToString("") || password.isEqualToString("") ) {
//            
//            var alertView:UIAlertView = UIAlertView()
//            alertView.title = "Sign in Failed!"
//            alertView.message = "Please enter Username and Password"
//            alertView.delegate = self
//            alertView.addButtonWithTitle("OK")
//            alertView.show()
//        } else {
//            
//            var post:NSString = "username=\(username)&password=\(password)"
//            
//            NSLog("PostData: %@",post);
//            
//            var url:NSURL = NSURL(string: "https://dipinkrishna.com/jsonlogin2.php")!
//            
//            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
//            
//            var postLength:NSString = String( postData.length )
//            
//            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
//            request.HTTPMethod = "POST"
//            request.HTTPBody = postData
//            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//            
//            
//            var reponseError: NSError?
//            var response: NSURLResponse?
//            
//            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
//            
//            if ( urlData != nil ) {
//                let res = response as NSHTTPURLResponse!;
//                
//                NSLog("Response code: %ld", res.statusCode);
//                
//                if (res.statusCode >= 200 && res.statusCode < 300)
//                {
//                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
//                    
//                    NSLog("Response ==> %@", responseData);
//                    
//                    var error: NSError?
//                    
//                    let jsonData:NSDictionary = NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers , error: &error) as NSDictionary
//                    
//                    
//                    let success:NSInteger = jsonData.valueForKey("success") as NSInteger
//                    
//                    //[jsonData[@"success"] integerValue];
//                    
//                    NSLog("Success: %ld", success);
//                    
//                    if(success == 1)
//                    {
//                        NSLog("Login SUCCESS");
//                        
//                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//                        prefs.setObject(username, forKey: "USERNAME")
//                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
//                        prefs.synchronize()
//                        
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                    } else {
//                        var error_msg:NSString
//                        
//                        if jsonData["error_message"] as? NSString != nil {
//                            error_msg = jsonData["error_message"] as NSString
//                        } else {
//                            error_msg = "Unknown Error"
//                        }
//                        var alertView:UIAlertView = UIAlertView()
//                        alertView.title = "Sign in Failed!"
//                        alertView.message = error_msg
//                        alertView.delegate = self
//                        alertView.addButtonWithTitle("OK")
//                        alertView.show()
//                        
//                    }
//                    
//                } else {
//                    var alertView:UIAlertView = UIAlertView()
//                    alertView.title = "Sign in Failed!"
//                    alertView.message = "Connection Failed"
//                    alertView.delegate = self
//                    alertView.addButtonWithTitle("OK")
//                    alertView.show()
//                }
//            } else {
//                var alertView:UIAlertView = UIAlertView()
//                alertView.title = "Sign in Failed!"
//                alertView.message = "Connection Failure"
//                if let error = reponseError {
//                    alertView.message = (error.localizedDescription)
//                }
//                alertView.delegate = self
//                alertView.addButtonWithTitle("OK")
//                alertView.show()
//            }
//        }
//        
//    }

    
}

