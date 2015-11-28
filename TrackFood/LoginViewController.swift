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
    
    var buffer:NSMutableData!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userID.resignFirstResponder()
        password.resignFirstResponder()
        return true
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
            signUp(sender)
        }else{
            login(sender)
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
    
    func processSignUpValidation(data:NSMutableData,sender: AnyObject){
        
        do {
            if var json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
            
            print (json)
                if let success:NSInteger = json.valueForKey("success") as? NSInteger{
                    if(success == 1)
                    {
                        NSLog("Sign Up SUCCESS");
                        dispatch_async(dispatch_get_main_queue(), {
                            // code here
                            self.showAlertView("Welcome!",message: "Sign up Success!")
                        })
                        //self.dismissViewControllerAnimated(true, completion: nil)
                    } else if (success == 2){
                        NSLog("Login SUCCESS");
                        dispatch_async(dispatch_get_main_queue(), {
                            // code here
                            self.performSegueWithIdentifier("loginSegue", sender: sender)

                        })
                                          }else {
                        var error_msg:NSString
                        
                        if json["error_message"] as? NSString != nil {
                            error_msg = json["error_message"] as! NSString
                        } else {
                            error_msg = "Unknown Error"
                        }
                  
                        dispatch_async(dispatch_get_main_queue(), {
                            // code here
                             self.showAlertView("SignUp Failed", message: error_msg as String)
                        })

                        
                        
                    }

                }
                
                if let error:NSString = json.valueForKey("error_message") as? NSString{
                    var error_msg:NSString
                    
                    if json["error_message"] as? NSString != nil {
                        error_msg = json["error_message"] as! NSString
                      
                    } else {
                        error_msg = "Unknown Error"
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        // code here
                        self.showAlertView("Failed", message: error_msg as String)
                    })
                }
                
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
            
        }
        
    }
    
    func showAlertView(title:String,message:String){
        
        var alertView:UIAlertView = UIAlertView()
        alertView.title = title
        alertView.message = message
        alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }
    
    
    func signUp(sender: AnyObject){
        
        var username:NSString = self.userID.text! as NSString
        var password:NSString = self.password.text! as NSString
        var confirm_password:NSString = self.confirmPassword.text! as NSString
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if ( !password.isEqual(confirm_password) ) {
            
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords doesn't Match"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            
            var post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: "http://172.23.132.82:5000/register")!
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(request){
                (data, response, error) in
                
                self.buffer = NSMutableData(data: data!)
               
                self.processSignUpValidation(self.buffer,sender: sender)
                
            }
            
            task.resume()
    }
        
}
//
    func login(sender: AnyObject){
        
        var username:NSString = self.userID.text! as NSString
        var password:NSString = self.password.text! as NSString
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            showAlertView("Sign in Failed!",message: "Please enter Username and Password")
        } else {
            
            var post:NSString = "username=\(username)&password=\(password)"
            
            NSLog("PostData: %@",post);
            
            var url:NSURL = NSURL(string: "http://172.23.132.82:5000/login")!
            
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            
            var postLength:NSString = String( postData.length )
            
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(request){
                (data, response, error) in
                self.buffer = NSMutableData(data: data!)
                self.processSignUpValidation(self.buffer,sender: sender)
                
            }
            
            task.resume()
        }
    }

    
 
}
