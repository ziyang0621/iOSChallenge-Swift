//
//  ViewController.swift
//  iOSChallenge
//
//  Created by Ziyang Tan on 4/10/15.
//  Copyright (c) 2015 Ziyang Tan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var menuOne: MenuControl!
    @IBOutlet weak var menuTwo: MenuControl!
    @IBOutlet weak var menuThree: MenuControl!
    @IBOutlet weak var menuFour: MenuControl!
    @IBOutlet weak var menuFive: MenuControl!
    @IBOutlet weak var menuSix: MenuControl!
    var menuArray = [MenuControl]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchItem = UIBarButtonItem(image: UIImage(named: "MON_searchIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        let calendarItem = UIBarButtonItem(image: UIImage(named: "MON_calendarIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        let compassItem = UIBarButtonItem(image: UIImage(named: "MON_compassIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        navigationItem.leftBarButtonItems = [searchItem, calendarItem, compassItem]
        
        let slideMenuItem = UIBarButtonItem(image: UIImage(named: "MON_menuIcon"), style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = slideMenuItem
        
        var soundPath = NSBundle.mainBundle().pathForResource("ocean_wave", ofType: "mp3")
        var soundPathURL = NSURL(fileURLWithPath: soundPath!)
        audioPlayer = AVAudioPlayer(contentsOfURL: soundPathURL, error: nil)
        
        let menuOneChoices = ["ONE OF A KIND", "SMALL BATCH", "LARGE BATCH", "MASS MARKET"]
        let menuTwoChoices = ["SAVORY", "SWEET", "UMAMI"]
        let menuThreeChoices = ["CRUNCHY", "MUSHY", "SMOOTH"]
        let menuFourChoices = ["SPICY", "MILD"]
        let menuFiveChoices = ["A LITTLE", "A LOT"]
        let menuSixChoices = ["BREAKFAST", "BRUNCH", "LUNCH", "SNACK", "DINNER"]
        
        menuOne.menuChoices = menuOneChoices
        menuTwo.menuChoices = menuTwoChoices
        menuThree.menuChoices = menuThreeChoices
        menuFour.menuChoices = menuFourChoices
        menuFive.menuChoices = menuFiveChoices
        menuSix.menuChoices = menuSixChoices
        
        menuArray = [menuOne, menuTwo, menuThree, menuFour, menuFive, menuSix]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func shufflePressed(sender: AnyObject) {
        playSound()
        for menuItem in menuArray {
            menuItem.randomizeChoices()
        }
    }
    
    @IBAction func GoPressed(sender: AnyObject) {
        let selectionVC = UIStoryboard.sidePanelViewController()
        var selectionText = ""
        for menu in menuArray {
            selectionText += menu.menuChoices[menu.selectedIndex] + "\n\n"
        }
        selectionVC!.selectionText = selectionText
        showViewController(selectionVC!, sender: self)
    }
    
    func playSound() {
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
}


