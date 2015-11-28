//
//  ProductDAO.swift
//  TrackFood
//
//  Created by student on 27/11/15.
//  Copyright © 2015 Nus. All rights reserved.
//

import Foundation
class ProductDAO {
    var productDB: COpaquePointer = nil;
    var insertStatement : COpaquePointer = nil; //pointer to the prepared statement
    var selectStatement : COpaquePointer = nil;
    var deleteStatement : COpaquePointer = nil;
    var updateStatement : COpaquePointer = nil;
    var selectAllStatement : COpaquePointer = nil;
    var selectSLStatement : COpaquePointer = nil;
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
    
    init() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        print(paths)
        
        let docsDir = paths + "/products.sqlite"
        
        if (sqlite3_open(docsDir,&productDB) == SQLITE_OK) {
            let sql = "CREATE TABLE IF NOT EXISTS PRODUCTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, QUANTITY TEXT, THRESHOLD TEXT, SLFLAG TEXT, IMAGE BLOB)"
            
            if sqlite3_exec(productDB, sql, nil, nil, nil) != SQLITE_OK {
                print("Failed to create table")
                print(sqlite3_errmsg(productDB));
            }
        }
        else {
            print("Failed to open database");
            print(sqlite3_errmsg(productDB));
        }
        
        prepareStatement();
    }
    
    func prepareStatement() {
        var sqlString: String
        
        sqlString = "INSERT INTO PRODUCTS (name, quantity, threshold,slflag, image) VALUES (?,?,?,?,?)"
        var cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(productDB, cSql!, -1, &insertStatement, nil)
        
        sqlString = "SELECT quantity, threshold FROM PRODUCTS WHERE name=?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(productDB, cSql!, -1, &selectStatement, nil)
        
        sqlString = "UPDATE PRODUCTS set quantity = ?, threshold = ?, slflag = ? WHERE name = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(productDB, cSql!, -1, &updateStatement, nil)
        
        sqlString = "DELETE FROM PRODUCTS WHERE name = ?"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(productDB, cSql!, -1, &deleteStatement, nil)
        
        sqlString = "SELECT * FROM PRODUCTS"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(productDB, cSql!, -1, &selectAllStatement, nil)
        
        sqlString = "SELECT * FROM PRODUCTS WHERE slflag = 1"
        cSql = sqlString.cStringUsingEncoding(NSUTF8StringEncoding)
        sqlite3_prepare_v2(productDB, cSql!, -1, &selectSLStatement, nil)
        
    }
    
    func createProduct(prod: Products) -> Bool {
        let nameStr = prod.name as NSString?
        let quantityStr = prod.quantity as NSString?
        let thresholdStr = prod.threshold as NSString?
        let flagStr = prod.slFlag as NSString?
        let imageS = prod.Image as NSData!
        var status: Bool
        
        sqlite3_bind_text(insertStatement, 1, nameStr!.UTF8String, -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStatement, 2, quantityStr!.UTF8String, -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStatement, 3, thresholdStr!.UTF8String, -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insertStatement, 4, flagStr!.UTF8String, -1, SQLITE_TRANSIENT);
        sqlite3_bind_blob(insertStatement, 5, imageS!.bytes, Int32(imageS!.length), SQLITE_TRANSIENT);
        
        if (sqlite3_step(insertStatement) == SQLITE_DONE) {
            status = true;
            //displayData()
            //tableView.reloadData()
        }
        else {
            status = false;
            print("Error Code: ", sqlite3_errcode(productDB));
            let error = String.fromCString(sqlite3_errmsg(productDB));
            print("Error message: ", error);
        }
        
        sqlite3_reset(insertStatement);
        sqlite3_clear_bindings(insertStatement);
        return status;
    }
    
    func findProduct(prod: Products) -> Products {
        let nameStr = prod.name as NSString?
        
        sqlite3_bind_text(selectStatement, 1, nameStr!.UTF8String, -1, SQLITE_TRANSIENT)
        
        if sqlite3_step(selectStatement) == SQLITE_ROW {
            
            let quant_buf = sqlite3_column_text(selectStatement, 0)
            prod.quantity = String.fromCString(UnsafePointer<CChar>(quant_buf))!
            
            let threshold_buf = sqlite3_column_text(selectStatement, 1)
            prod.threshold = String.fromCString(UnsafePointer<CChar>(threshold_buf))!
            
        }
        else {
            
            print("Error Code: ", sqlite3_errcode(productDB));
            let error = String.fromCString(sqlite3_errmsg(productDB));
            print("Error message: ", error);
        }
        
        sqlite3_reset(selectStatement);
        sqlite3_clear_bindings(selectStatement);
        return prod
    }
    
    func selectAllProduct()-> NSMutableArray {
        let items = NSMutableArray()
        while sqlite3_step(selectAllStatement) == SQLITE_ROW {
            //let id = sqlite3_column_int64(selectAllStatement, 0)
            //print("id = \(id); ", terminator: "")
            
            let name = sqlite3_column_text(selectAllStatement, 1)
            let quantity = sqlite3_column_text(selectAllStatement, 2)
            let threshold = sqlite3_column_text(selectAllStatement, 3)
            let len = sqlite3_column_bytes(selectAllStatement, 5)
            let point = sqlite3_column_blob(selectAllStatement, 5)
            let image: NSData = NSData(bytes: point, length: Int(len))
            
            if name != nil {
                let prod: Products = Products()
                let nameString = String.fromCString(UnsafePointer<Int8>(name))
                prod.name = nameString!
                let quantString = String.fromCString(UnsafePointer<Int8>(quantity))
                prod.quantity = quantString!
                let threshString = String.fromCString(UnsafePointer<Int8>(threshold))
                prod.threshold = threshString!
                prod.Image = image
                print("name = \(nameString!)")
                items.addObject(prod);
            } else {
                print("name not found")
            }
            
        }
        sqlite3_reset(selectAllStatement);
        sqlite3_clear_bindings(selectAllStatement);
        return items
    }
    
    func updateProduct(prod: Products) -> Bool {
        
        let nameStr = prod.name as NSString?
        let quantityStr = prod.quantity as NSString?
        let thresholdStr = prod.threshold as NSString?
        let flagStr = prod.slFlag as NSString?
        var status: Bool
        
        sqlite3_bind_text(updateStatement, 1, quantityStr!.UTF8String, -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStatement, 2, thresholdStr!.UTF8String, -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStatement, 3, flagStr!.UTF8String, -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(updateStatement, 4, nameStr!.UTF8String, -1, SQLITE_TRANSIENT);
        
        if sqlite3_step(updateStatement) == SQLITE_DONE {
            //status.text = "Contact updated";
            status = true
        }
        else {
            //status.text = "Failed to update contact";
            status = false
            print("Error Code: ", sqlite3_errcode(productDB));
            let error = String.fromCString(sqlite3_errmsg(productDB));
            print("Error message: ", error);
        }
        
        sqlite3_reset(updateStatement);
        sqlite3_clear_bindings(updateStatement);
        return status
    }
    
    func delete(prod:Products) -> Bool {
        let nameStr = prod.name as NSString?
        var status: Bool
        
        sqlite3_bind_text(deleteStatement, 1, nameStr!.UTF8String, -1, SQLITE_TRANSIENT)
        
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
            status = true
        }
        else {
            status = false
            print("Error Code: ", sqlite3_errcode(productDB));
            let error = String.fromCString(sqlite3_errmsg(productDB));
            print("Error message: ", error);
        }
        
        sqlite3_reset(deleteStatement);
        sqlite3_clear_bindings(deleteStatement);
        return status
    }
    
    func getShopList() -> [String] {
        var items: [String] = []
        while sqlite3_step(selectSLStatement) == SQLITE_ROW {
            //let id = sqlite3_column_int64(selectAllStatement, 0)
            //print("id = \(id); ", terminator: "")
            
            let name = sqlite3_column_text(selectSLStatement, 1)
//            let quantity = sqlite3_column_text(selectSLStatement, 2)
//            let threshold = sqlite3_column_text(selectSLStatement, 3)
//            let flagStr = sqlite3_column_text(selectSLStatement, 4)
            if name != nil {
//                let prod: Products = Products()
               let nameString = String.fromCString(UnsafePointer<Int8>(name))
                print("name = \(nameString!)")
                items.append(nameString!)
            } else {
                print("name not found")
            }
            
        }
        sqlite3_reset(selectAllStatement);
        sqlite3_clear_bindings(selectAllStatement);
        return items
    }
    
    func belowCount() -> Int {
        var prodList: NSMutableArray!
        var count = 0
        prodList = selectAllProduct()
        let length = prodList.count
        
        for index in 0..<length{
            let prod = prodList[index] as! Products
            let thresh: Int = Int(prod.threshold)!
            let quant: Int = Int(prod.quantity)!
            if quant < thresh {
                count = count + 1
            }
        }
        return count
    }
    
    func dummyInsert(){
        let imageName = "Unknown.jpeg"
        let imageS = UIImage(named: imageName)
        let imageData: NSData = UIImageJPEGRepresentation(imageS!, 1.0)!
        let prod1: Products = Products(name: "Apple",quantity: "10",threshold: "5",slFlag: "1", image: imageData)
        createProduct(prod1)
        let prod2: Products = Products(name: "Orange",quantity: "10",threshold: "5",slFlag: "0", image: imageData)
        createProduct(prod2)
        let prod3: Products = Products(name: "Banana",quantity: "10",threshold: "5",slFlag: "0", image: imageData)
        createProduct(prod3)
        let prod4: Products = Products(name: "Grapes",quantity: "10",threshold: "5",slFlag: "0", image: imageData)
        createProduct(prod4)        
    }
}