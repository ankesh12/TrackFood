//
//  MasterViewController.swift
//  FoodTracker
//
//  Created by student on 27/11/15.
//  Copyright © 2015 Nus. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    var products : NSMutableArray!
    var prodDao: ProductDAO!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        //products = Products.getAllExisting()
        prodDao = ProductDAO()
        prodDao.dummyInsert()
        products = prodDao.selectAllProduct()
        
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        let timer = NSTimer(timeInterval: 10, target: self, selector: Selector("notifcall"), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode:NSDefaultRunLoopMode)
    }

    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        products.removeAllObjects()
        products = prodDao.selectAllProduct()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        //objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row] as! NSDate
                let object = products[indexPath.row] as! Products
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//                //controller.detailItem = object
//                controller.editingProduct = object
//                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
                (segue.destinationViewController as! DetailViewController).editingProduct = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

//        let object = objects[indexPath.row] as! NSDate
//        cell.textLabel!.text = object.description

        let object = products[indexPath.row] as! Products
        cell.textLabel!.text = object.name
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var prod = Products()
            prod = products[indexPath.row] as! Products
            let status = prodDao.delete(prod)
            if status == true {
                products.removeObjectAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func notifcall()
    {
        let count = prodDao.belowCount();
        print (count);
        
        if count > 0 {
            let notification:UILocalNotification = UILocalNotification()
            notification.category = "FIRST_CATEGORY"
            notification.alertBody = "Some Items running low"
            notification.fireDate = NSDate(timeInterval: 2, sinceDate: NSDate())
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        else {
            
            print("no products bwlow")
        }
        
        
    }


}

