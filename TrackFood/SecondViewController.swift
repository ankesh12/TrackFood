//
//  SecondViewController.swift
//  TrackFood
//
//  Created by student on 27/11/15.
//  Copyright © 2015 Nus. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var items: [String] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let prodDao = ProductDAO()
        tableView.delegate = self
        tableView.dataSource = self
        
        items = prodDao.getShopList()
        print("Items: \(items.count)")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        items.removeAll()
        let prodDao = ProductDAO()
        items = prodDao.getShopList()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell? = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        //displayData()
        cell!.textLabel?.text = self.items[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }

}

