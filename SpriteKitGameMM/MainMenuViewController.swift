//
//  MainMenuViewController.swift
//  SpriteKitGameMM
//
//  Created by Aaron Bradley on 2/22/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import AudioToolbox.AudioServices
import AVFoundation

class MainMenuViewController: UIViewController {

    @IBOutlet weak var muteButton: UIButton!
    var savedSoldier = NSUserDefaults.standardUserDefaults()
    var audioPlayer = AVAudioPlayer()

    @IBOutlet var imageViewSoldier: UIImageView!

    let soldierImages: [String] = ["S1-Idle__007" , "S2-Idle__007", "S3-Idle__007", "S4-Idle__007"]
    let soldierOrder: [String] = ["S1", "S2", "S3", "S4"]
    var soldierImageIndex: Int = 0

    override func viewWillAppear(animated: Bool) {
        if savedSoldier.objectForKey("currentSoldier") != nil {
            let name = savedSoldier.objectForKey("currentSoldier") as! String
            imageViewSoldier.image = UIImage(named: name)
            soldierImageIndex = soldierImages.indexOf(name)!

        } else {
            savedSoldier.setObject(self.soldierOrder[soldierImageIndex], forKey: "currentSoldierString")
            savedSoldier.synchronize()

        }

        let selectionSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("SwitchSoldier", ofType: "mp3")!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }

//        var error:NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: selectionSound)
        } catch {
          print("Something went wrong")
      }
//        } catch var error1 as NSError {
//            error = error1
//            audioPlayer = nil
//        }
        audioPlayer.prepareToPlay()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if appDelegate.isMuted == false {
            appDelegate.stopInGameMusic()
            appDelegate.startBGMusic()

        } else {
            muteButton.setImage(UIImage(named: "muteButtonGray"), forState: UIControlState.Normal)

        }
    }


    @IBAction func onMuteButtonTapped(sender: UIButton) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if appDelegate.isMuted == true {
            appDelegate.isMuted = false

            muteButton.setImage(UIImage(named: "muteButtonBlue"), forState: UIControlState.Normal)

            appDelegate.stopInGameMusic()
            appDelegate.startBGMusic()
        } else {
            appDelegate.isMuted = true
            muteButton.setImage(UIImage(named: "muteButtonGray"), forState: UIControlState.Normal)

            appDelegate.stopAllMusic()

        }
    }


    @IBAction func buttonTapChangeSoldier(sender: UIButton) {

        soldierImageIndex++
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let selectedSoldier = soldierCycle()
        savedSoldier.setObject(selectedSoldier, forKey: "currentSoldier")
        savedSoldier.synchronize()

        savedSoldier.setObject(self.soldierOrder[soldierImageIndex], forKey: "currentSoldierString")

        imageViewSoldier.image = UIImage(named: savedSoldier.objectForKey("currentSoldier") as! String)
        if appDelegate.isMuted == false {
        audioPlayer.play()

        }


    }


    func soldierCycle() -> String {

        if soldierImageIndex >= soldierImages.count {
            soldierImageIndex = 0
        }

        return soldierImages[soldierImageIndex]

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {


    if let gameViewController = segue.destinationViewController as? GameViewController {
            gameViewController.currentSoldier = NSUserDefaults.standardUserDefaults().objectForKey("currentSoldierString") as? String
            NSUserDefaults.standardUserDefaults().synchronize()

        }
    }

}