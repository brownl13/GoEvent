//
//  LoadViewController.swift
//  GoEvent
//
//  Created by Logan on 3/28/18.
//  Copyright © 2018 Logan. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Logo.jpg")!)
        
        usleep(10000000)
        
        let mySC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.pushViewController(mySC, animated: true)
        
    }
    
}
