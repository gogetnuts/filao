//
//  ViewController.swift
//  Source
//
//  Created by Ben on 03/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit


var selectedTool:Int = 0
var dayProgressionBar : NSProgressIndicator = NSProgressIndicator()
var toolChamp:NSTextField = NSTextField()
var toolStep:NSStepper = NSStepper()
var toolPause:NSButton = NSButton()
var toolList:NSPopUpButton = NSPopUpButton()
var toolFilterHumidity:NSButton = NSButton()
var toolFilterLevel1:NSButton = NSButton()
var toolPhysics:NSButton = NSButton()


class ViewController: NSViewController {


    @IBOutlet var list: NSPopUpButton!
   // @IBOutlet var pause: NSButton!
   // @IBOutlet var filterLevel1: NSButton!
   // @IBOutlet var filterhumidity: NSButton!
    //@IBOutlet var champ: NSTextField!
   // @IBOutlet var physicsbutton: NSButton!
    //@IBOutlet var step: NSStepper!
    //@IBOutlet var dayTimeCorner: NSProgressIndicator!
    @IBOutlet var champ: NSTextField!
    @IBOutlet var filterLevel1: NSButton!
    @IBOutlet var skView: SKView!
    @IBOutlet var pause: NSButton!
    @IBOutlet var step: NSStepper!
    @IBOutlet var filterHumidity: NSButton!
    @IBOutlet var filterPhysics: NSButton!

    @IBOutlet var dayTimeCorner: NSProgressIndicator!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {

            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {

                // Copy gameplay related content over to the scene
                //sceneNode.entities = scene.entities
                //sceneNode.graphs = scene.graphs

                // Set the scale mode to scale to fit the window
                //sceneNode.scaleMode = .aspectFill
                sceneNode.scaleMode = .resizeFill
                sceneNode.size = CGSize(width: 800, height: 600)

                // Present the scene
                if let view = self.skView {
                    view.presentScene(sceneNode)


                    view.ignoresSiblingOrder = false

                    view.showsFPS = true
                    view.showsNodeCount = true
                    //view.showsPhysics = true



                }
                dayProgressionBar = dayTimeCorner
                toolChamp = champ
                toolStep = step
                toolPause = pause
                //toolList = list
                toolFilterHumidity = filterHumidity
                toolFilterLevel1 = filterLevel1
                toolPhysics = filterPhysics
            }
        }
    }
}


