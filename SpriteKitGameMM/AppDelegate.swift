//
//  AppDelegate.swift
//  SpriteKitGameMM
//
//  Created by Aaron Bradley on 2/11/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import UIKit
import Parse
import Fabric
import Crashlytics
import AudioToolbox.AudioServices
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate {

    var window: UIWindow?
    var bgMusicPlayer = AVAudioPlayer()
    var inGameMusicPlayer = AVAudioPlayer()
    var isMuted:Bool?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])

        Parse.setApplicationId("PeaTcxDstCFxbD320OshP9bA9PkBXvyNIw5FJlIF", clientKey: "fU0X9yNe0TUmr566CoSU0gVmnjzBRQUZcJzCTUft")
        FBLoginView.self
        FBProfilePictureView.self
        PFFacebookUtils.initializeFacebook()

        isMuted = false

        let bgMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ThemeOfKingsSnippet", ofType: "mp3")!)
      do {
        try bgMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusic)
      } catch {
        print("Something went wrong with bgMusicPlayer")
      }
      
//        bgMusicPlayer = try? AVAudioPlayer(contentsOfURL: bgMusic)
        bgMusicPlayer.delegate = self
        bgMusicPlayer.numberOfLoops = -1
        bgMusicPlayer.prepareToPlay()
        startBGMusic()

        let inGameMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("ConquerIt", ofType: "mp3")!)
      do {
        try inGameMusicPlayer = AVAudioPlayer(contentsOfURL: inGameMusic)
      } catch {
        print("Something went wrong with inGameMusicPlayer")
      }
//        inGameMusicPlayer = try? AVAudioPlayer(contentsOfURL: inGameMusic)
        inGameMusicPlayer.numberOfLoops = -1


        return true
    }

    func startBGMusic() {
        bgMusicPlayer.play()
    }

    func startInGameMusic() {
        inGameMusicPlayer.play()
    }

    func stopInGameMusic() {
        inGameMusicPlayer.stop()
        inGameMusicPlayer.currentTime = 0
    }

    func stopBGMusic() {
        bgMusicPlayer.stop()
        bgMusicPlayer.currentTime = 0

    }

    func stopAllMusic() {
        stopBGMusic()
        stopInGameMusic()
    }

  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    let wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
    return wasHandled
  }




    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

         //NSNotificationCenter.defaultCenter().postNotificationName("pause", object:nil)
        //println("okay")
    }

    func applicationDidEnterBackground(application: UIApplication) {

        // CALL PAUSE FUNCTION
        //NSNotificationCenter.defaultCenter().postNotificationName("stayPausedNotification", object:nil)
        //println("big sean")


        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

         NSNotificationCenter.defaultCenter().postNotificationName("stayPaused", object:nil)
        NSNotificationCenter.defaultCenter().postNotificationName("tutorialPaused", object:nil)

    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        NSNotificationCenter.defaultCenter().postNotificationName("stayPausedNotification", object:nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

