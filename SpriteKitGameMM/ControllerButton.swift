//
//  ControllerButton.swift
//  SpriteKitGameMM
//
//  Created by Aaron Bradley on 2/11/15.
//  Copyright (c) 2015 Aaron Bradley. All rights reserved.
//

import Foundation
import SpriteKit

class ControllerButton: UIButton {



    @IBAction func buttonTapJump(sender: UIButton) {
        print("JUMP")

//        soldierNode?.setCurrentState(Soldier.SoldierStates.Jump)
//        soldierNode?.stepState()
    }

    @IBAction func buttonTapDuck(sender: UIButton) {
        print("DUCK")
//        soldierNode?.setCurrentState(Soldier.SoldierStates.Crouch)
//        soldierNode?.stepState()
    }

}