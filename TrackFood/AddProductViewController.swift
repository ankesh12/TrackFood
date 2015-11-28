//
//  AddProductViewController.swift
//  TrackFood
//
//  Created by student on 27/11/15.
//  Copyright © 2015 Nus. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddProductViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var prodName: UITextField!
    @IBOutlet weak var textQuantity: UITextField!
    @IBOutlet weak var quantity: UISlider!
    @IBOutlet weak var textThreshold: UITextField!
    @IBOutlet weak var threshold: UISlider!
    @IBOutlet weak var prodImage: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var imagePicker: UIImagePickerController!
    var newMedia: Bool?
    var typeCheck: Bool = false
    
    var editingProduct: Products?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prodName.delegate = self
        textQuantity.delegate = self
        textThreshold.delegate = self
        prodName.userInteractionEnabled = true
        
        typeCheck = false
        if editingProduct != nil {
            prodName.text = editingProduct!.name
            textQuantity.text = editingProduct!.quantity
            quantity.value = Float(textQuantity.text!)!
            textThreshold.text = editingProduct!.threshold
            threshold.value = Float(editingProduct!.threshold)!
            button.setTitle("Edit Product", forState: .Normal)
            prodName.enabled = false
            typeCheck = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func quantityChanged(sender: AnyObject) {
        let valueQuantity : Int = Int(quantity.value);
        textQuantity.text = String(valueQuantity)
    }
    
    @IBAction func thresholdChanged(sender: AnyObject) {
        let valueQuantity : Int = Int(threshold.value);
        textThreshold.text = String(valueQuantity)
    }

    @IBAction func takePhoto(sender: UIButton) {
//        imagePicker =  UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.mediaTypes = [String(kUTTypeImage)]
//        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
//        imagePicker.allowsEditing = false
//        
//        presentViewController(imagePicker, animated: true, completion: nil)

        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                //imagePicker.mediaTypes = [kUTTypeImage]
                imagePicker.mediaTypes = [String(kUTTypeImage)]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = true
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        let selectedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as! UIImage
//        prodImage.image = selectedImage
//        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == (kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            prodImage.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType == kUTTypeMovie as String {
                // Code to support video here
            }
            
        }
        
    }
   
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        //        if error != nil {
        //            let alert = UIAlertController(title: "Save Failed",
        //                message: "Failed to save image",
        //                preferredStyle: UIAlertControllerStyle.Alert)
        //
        //            let cancelAction = UIAlertAction(title: "OK",
        //                style: .Cancel, handler: nil)
        //
        //            alert.addAction(cancelAction)
        //            self.presentViewController(alert, animated: true,
        //                completion: nil)
        //        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addProduct() {
        if typeCheck == true {
            let prod = Products()
            let prodDao = ProductDAO()
            prod.name = prodName.text!
            prod.quantity = textQuantity.text!
            print(textQuantity.text)
            prod.threshold = textThreshold.text!
            let val = prodDao.updateProduct(prod)
            if val == true {
                print("Success")
            }
            else{
                print("Failed")
            }
        }
        else {
            let prod = Products()
            let prodDao = ProductDAO()
            prod.name = prodName.text!
            prod.quantity = textQuantity.text!
            prod.threshold = textThreshold.text!
            let val = prodDao.createProduct(prod)
            if val == true {
                print("Success")
            }
            else{
                print("Failed")
            }
        }
        
    }
}
