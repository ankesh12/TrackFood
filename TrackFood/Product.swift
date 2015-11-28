//
//  Product.swift
//  FoodTracker
//
//  Created by student on 27/11/15.
//  Copyright © 2015 Nus. All rights reserved.
//

import Foundation

class Products{
    var name: String
    var quantity: String
    var threshold: String
    var slFlag: String!
    var Image: NSData!
    
    init(){
        self.name=""
        self.quantity=""
        self.threshold=""
        self.slFlag="0"
    }
    
    init (name:String, quantity:String, threshold:String, slFlag: String) {
        self.name = name
        self.quantity = quantity
        self.threshold = threshold
        self.slFlag = slFlag
    }
    
    class func getAllExisting() -> NSMutableArray {
        let products = NSMutableArray()
//        products.addObject(Products(name:"Apple", quantity:"10", threshold:"5"));
//        products.addObject(Products(name:"Orange", quantity:"10", threshold:"5"));
//        products.addObject(Products(name:"carrot", quantity:"10", threshold:"5"));
//        products.addObject(Products(name:"Guava", quantity:"10", threshold:"5"));
        return products
    }
    
    
}