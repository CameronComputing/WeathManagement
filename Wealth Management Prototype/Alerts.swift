//
//  Alerts.swift
//  Wealth Management Prototype
//
//  Created by Nicholas Cameron on 2017-08-22.
//  Copyright © 2017 CameronComputing. All rights reserved.
//

import UIKit

class Alerts: NSObject {

    
    class func dynamicAlert(viewController:UIViewController,title:String, message:String){
        
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            
        }))
        
        DispatchQueue.main.async {
            viewController.present(refreshAlert, animated: true, completion: nil)
        }
    }
    

    
    
}
