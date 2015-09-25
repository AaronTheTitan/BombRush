//
//  GameViewController.swift
//  SpriteKitGameMM
//
//  Created by Aaron Bradley on 2/11/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import UIKit
import SpriteKit


extension SKNode {
  class func unarchiveFromFile(file : NSString) -> SKNode? {
    if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
      let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
      let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)

      archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
      let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
      archiver.finishDecoding()
      return scene
    } else {
      return nil
    }
  }
}


class MySKView: SKView {
  var stayPaused = false as Bool

  override var paused: Bool {
    get {
      return super.paused
    }
    set {
      if (!stayPaused) {
        super.paused = newValue
      }
      stayPaused = false
    }
  }

  func setStayPaused() {
    self.stayPaused = true
  }
}

class GameViewController: UIViewController {

  var currentSoldier:String?
  var alert:UIAlertController!
//  var highScoreTextField:UITextField!
//  let nameTextField:UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
      let skView = self.view as! SKView
      skView.showsFPS = false
      skView.showsNodeCount = false

      /* Sprite Kit applies additional optimizations to improve rendering performance */
      skView.ignoresSiblingOrder = true

      /* Set the scale mode to scale to fit the window */
      scene.scaleMode = .AspectFill
      skView.presentScene(scene)

      //            scene.currentSoldier = self.currentSoldier!
      scene.currentSoldier = NSUserDefaults.standardUserDefaults().objectForKey("currentSoldierString") as? String


      NSNotificationCenter.defaultCenter().addObserver(skView, selector:Selector("setStayPaused"), name: "stayPausedNotification", object: nil)

      NSNotificationCenter.defaultCenter().addObserverForName("segue", object: nil, queue: nil) { (notification: NSNotification) in

        self.performSegueWithIdentifier("gameOverSegue", sender: self)
        scene.removeAllChildren()
        scene.removeAllActions()


        return
      }

      NSNotificationCenter.defaultCenter().addObserverForName("leader", object: nil, queue: nil) { (notification: NSNotification) in
        self.performSegueWithIdentifier("leaderSegue", sender: self)

        scene.removeAllChildren()
        scene.removeAllActions()

        return
      }


      NSNotificationCenter.defaultCenter().addObserverForName("highscore", object: nil, queue: nil) { (notification: NSNotification) in


        let alertController = UIAlertController(title: "New High Score", message: "Enter your name and post your new high score.", preferredStyle: .Alert)

        let postAction = UIAlertAction(title: "Post", style: .Default) { (action) in
          let name = alertController.textFields![0] 

          let gameScore = PFObject(className: "GameScore")
          gameScore.setObject(NSUserDefaults.standardUserDefaults().integerForKey("highscore"), forKey: "score")
          gameScore.setObject(name.text!, forKey: "playerName")

          gameScore.saveInBackgroundWithBlock({ (success, error) -> Void in
            if !success {
              print(error)
            }
          })



          NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isHighScore")
          NSUserDefaults.standardUserDefaults().synchronize()

          self.performSegueWithIdentifier("leaderSegue", sender: self)
        }
        alertController.addAction(postAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)

        self.presentViewController(alertController, animated: true) {
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) in
          textField.placeholder = "Name"
          textField.keyboardType = .EmailAddress
        }


        return
      }

    }
  }




  override func shouldAutorotate() -> Bool {
    return true
  }

  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return UIInterfaceOrientationMask.AllButUpsideDown
    } else {
      return UIInterfaceOrientationMask.All
    }
  }


  override func prefersStatusBarHidden() -> Bool {
    return true
  }

  override func viewDidLayoutSubviews() {

  }
}
