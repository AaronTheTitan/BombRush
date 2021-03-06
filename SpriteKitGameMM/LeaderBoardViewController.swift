//
//  LeaderBoardViewController.swift
//  SpriteKitGameMM
//
//  Created by Ryan  Gunn on 2/21/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import Foundation
import Parse
import Social
import UIKit




class LeaderBoard: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    var score:Int?
    var highScoreArray = [Int]()
    var nameArray = [String]()
    var newestObjectArray = [String]()

    var isHighScore:Bool!


    @IBOutlet var postButton: UIButton!

    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var addYourButton: UIButton!
   


    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.inGameMusicPlayer.volume = 1
        if appDelegate.isMuted == false {
            appDelegate.stopInGameMusic()
            appDelegate.startBGMusic()
        }

        //NSInteger score = [[NSUserDefaults standardUserDefaults] integerForKey:@"highscore"];
        postButton.hidden = true
        nameTextField.hidden = true
        addYourButton.hidden = true
        //addYoursButton.hidden = true

        score  = NSUserDefaults.standardUserDefaults().integerForKey("highscore")

//        
        isHighScore = NSUserDefaults.standardUserDefaults().boolForKey("isHighScore")


//        println("\(score!)")
        //tableView.registerNib(UINib(nibName: "LeaderBoardCell", bundle: nil), forCellReuseIdentifier: "leaderBoardCell")

        tableView.backgroundColor = UIColor.blackColor()

        addHighScoreObject()
        checkIsHighScore()


        self.nameTextField.delegate = self
}

    func addHighScoreObject () {
        var playerNameArray = [String]()
        var scoreArray = [Int]()
        let query = PFQuery(className:"GameScore")
        query.orderByAscending("score")

      query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in

                if error == nil {

                  if let foundObjects = objects {

                    for object in foundObjects {
                        let playerName = object.objectForKey("playerName") as! String
                        let score = object.objectForKey("score") as! Int

                        playerNameArray.insert(playerName, atIndex: 0)
                        scoreArray.insert(score, atIndex: 0)

                        self.highScoreArray = scoreArray
                        self.nameArray = playerNameArray
                    }
                  }

                    self.tableView.reloadData()

                    
                } else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error!, error!.userInfo)
                }
        }

    }

    func findnewObject() {

        var newObject = [String]()
        let queryNewObject = PFQuery(className:"GameScore")
        queryNewObject.orderByAscending("createdAt")

      queryNewObject.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in

            if error == nil {
                // The find succeeded.
                //NSLog("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
              if let foundObjects = objects {

                for object in foundObjects {
                    let playerName = object.objectForKey("playerName") as! String


                    newObject.insert(playerName, atIndex: 0)


                    self.newestObjectArray = newObject

                }
              }

                self.tableView.reloadData()


            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error!, error!.userInfo)
            }
        }


    }

    func checkIsHighScore() {
        if isHighScore == true {
            addYourButton.hidden = false

        }else {
            addYourButton.hidden = true
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArray.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("leaderBoardCell")!
        cell.backgroundColor = UIColor.grayColor()

        if !newestObjectArray.isEmpty{
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)

        }

        if !nameArray.isEmpty{

        let nameString = self.nameArray[indexPath.row]
            if nameString == newestObjectArray.first{
                            }

        cell.textLabel!.text = "\(indexPath.row + 1). \(nameString)"

            let scoreString = self.highScoreArray[indexPath.row]
            cell.detailTextLabel?.text = "\(scoreString) points"
            cell.detailTextLabel?.textColor = UIColor.blackColor()

        }
        return cell
    }


    func postGameScore () {
        let gameScore = PFObject(className: "GameScore")
        gameScore.setObject(NSUserDefaults.standardUserDefaults().integerForKey("highscore"), forKey: "score")
        gameScore.setObject(nameTextField.text!, forKey: "playerName")
        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if success {
                self.tableView.reloadData()
                //NSLog("Object created with id: \(gameScore.objectId)")
            } else {
                NSLog("%@", error!)
            }

        }

    }

    func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

    @IBAction func postToLeaderBoardButtonPressed(sender: UIButton) {
        postButton.hidden = false
        nameTextField.hidden = false
        nameTextField.becomeFirstResponder()
    }

    @IBAction func postButtonPressed(sender: UIButton) {
       postGameScore()
        nameTextField.resignFirstResponder() == true
        nameTextField.hidden = true
        postButton.hidden = true
        addYourButton.hidden = true

        addHighScoreObject()
        findnewObject()


        //self.tableView.scrollToRowAtIndexPath(newestObjectArray[indexPath], atScrollPosition: UITableViewScrollPosition.None, animated: false)


        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isHighScore")
        NSUserDefaults.standardUserDefaults().synchronize()

    }

    @IBAction func faceBookButtonPressed(sender: UIButton) {

        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.setInitialText("My high score on Bomb Rush is \(score!), try to beat that")
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }

    @IBAction func twitterButtonPressed(sender: UIButton) {

        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("My high score on Bomb Rush is \(score!), try to beat that")

            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }


    }




}