//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by student on 27/11/15.
//  Copyright © 2015 Nus. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var prodName: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var threshold: UITextField!
    @IBOutlet weak var imageIcon: UIImageView!

    var editingProduct : Products!
    var prodDao = ProductDAO()

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        prodName.text = editingProduct.name
        quantity.text = editingProduct.quantity
        threshold.text = editingProduct.threshold
        if(editingProduct.name == "Apple"){
            let imageName = "Unknown.jpeg"
            let imageS = UIImage(named: imageName)
            imageIcon.image = imageS
            //imageIcon.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
            //view.addSubview(imageIcon)
        }
        else{
            let imageName = "Unknown-3.jpeg"
            let imageS = UIImage(named: imageName)
            imageIcon.image = imageS!
            //imageIcon.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
            //view.addSubview(imageIcon)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        editingProduct = prodDao.findProduct(editingProduct)
        quantity.text = editingProduct.quantity
        threshold.text = editingProduct.threshold
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editPage" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                //let object = objects[indexPath.row] as! NSDate
//                let object = products[indexPath.row] as! Products
//                //                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//                //                //controller.detailItem = object
//                //                controller.editingProduct = object
//                //                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                //                controller.navigationItem.leftItemsSupplementBackButton = true
//                (segue.destinationViewController as! DetailViewController).editingProduct = object
//            }
            (segue.destinationViewController as! AddProductViewController).editingProduct = editingProduct
        }
    }
    
    @IBAction func addToSL() {
        var prod = Products()
        prod = editingProduct
        prod.slFlag = "1"
        let prodDao = ProductDAO()
        let status = prodDao.updateProduct(prod)
        if status == true {
            print("Success")
        }
        else {
            print("Failed")
        }
    }
    
    @IBAction func consume(){
        var quant: Int = Int(editingProduct.quantity)!
        quant = quant - 1
        editingProduct.quantity = String(quant)
        let prodDao = ProductDAO()
        let status = prodDao.updateProduct(editingProduct)
        if status == true {
            print("Success")
            quantity.text = editingProduct.quantity
        }
        else {
            print("Failed")
        }
    }

}


