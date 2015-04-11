//
//  SelectionViewController.swift
//  iOSChallenge
//
//  Created by Ziyang Tan on 4/10/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    @IBOutlet weak var selectionTextView: UITextView!
    var selectionText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionTextView.text = selectionText
    }
}
