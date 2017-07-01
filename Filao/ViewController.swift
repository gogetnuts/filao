//
//  ViewController.swift
//  Source
//
//  Created by Ben on 03/06/2017.
//  Copyright © 2017 Ben. All rights reserved.
//


import SpriteKit
import GameplayKit


var selectedTool:Int = 0
var dayProgressionBar : NSProgressIndicator = NSProgressIndicator()
var toolChamp:NSTextField = NSTextField()
var toolStep:NSStepper = NSStepper()
var toolPause:NSButton = NSButton()
var toolList:NSPopUpButton = NSPopUpButton()

var scNode:GameScene?


class ViewController: NSViewController {


    @IBOutlet var champ: NSTextField!

    @IBOutlet var skView: SKView!
    @IBOutlet var pause: NSButton!
    @IBOutlet var step: NSStepper!

    @IBOutlet var filterLevel1: filterButton!
    @IBOutlet var filterHumidity: filterButton!
    @IBOutlet var filterPhysics: filterButton!

    @IBOutlet var dayTimeCorner: NSProgressIndicator!
    @IBOutlet var filterGrid: filterButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {

            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                scNode = sceneNode
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
                }
                dayProgressionBar = dayTimeCorner
                toolChamp = champ
                toolStep = step
                toolPause = pause

            }
        }
    }
}


