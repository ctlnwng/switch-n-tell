//
//  BoardSetupViewController.swift
//  SwitchNTell
//
//  Handles setting up the board for a Switch-N-Tell game. i.e. finds a flat plane in the user's world and sets up the
//  four corners of the board.
//
//  Created by Noah Appleby on 11/3/18.
//  Copyright © 2018 SwitchNTell. All rights reserved.
//
//  Code sourced from example  https://github.com/kravik/ArMeasureDemo/blob/master/ArMeasureDemo/ViewController.swift

import Foundation

import UIKit
import SceneKit
import ARKit


class BoardSetupViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var onboarding: STOnboardingViewController?
    var instructionsLabel: UILabel?
    
    //Board to place on
    var board : Board?
    var plane : Plane?
    
    var saveButton: UIButton?
    var shuffleButton: UIButton?
    
    var boardWidth:CGFloat = 4.0
    
    var inGameState: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        inGameState = false
        
        //Create TapGesture Recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        sceneView.addGestureRecognizer(tap)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal]
        
        // Run the view's session
        sceneView.session.run(configuration)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.addSetupInstructions()
        self.goForwardButton()
        self.endGameButton()
        self.cancelButton()
    }
    
    private func addSetupInstructions() {
        let topMargin: CGFloat = 35
        let instructionsHeight: CGFloat = 100
        self.instructionsLabel = UILabel.init()
        if let view = self.instructionsLabel {
            view.text = STStringConstants.getSetupBoardInstructions()
            view.numberOfLines = 0
            view.textAlignment = NSTextAlignment.center
            view.backgroundColor = UIColor.transparentBlack
            view.textColor = UIColor.white
            view.clipsToBounds = true
            view.font = UIFont.init(name: "Avenir", size: 17)
            view.layer.cornerRadius = 10.0
            view.frame = CGRect.init(x: self.view.frame.minX, y: topMargin, width: self.view.frame.width, height: instructionsHeight)
            self.view.addSubview(view)
        }
    }
    
    private func goForwardButton()
    {
        saveButton = UIButton.init(type: UIButtonType.custom)
        saveButton?.frame = CGRect.init(x: self.view.frame.midX + 10, y: self.view.frame.maxY - 100, width: 60, height: 50)
        saveButton?.setTitle("Next", for: .normal)
        saveButton?.setTitleColor(UIColor.white, for: .normal)
        saveButton?.backgroundColor = UIColor.customRed
        saveButton?.clipsToBounds = true
        saveButton?.titleLabel?.font = UIFont.init(name: "Avenir", size: 17)
        saveButton?.layer.cornerRadius = 10.0
        saveButton?.addTarget(self, action: #selector(goForward), for: UIControlEvents.touchDown)
        
        if let subView = self.saveButton
        {
            self.view.addSubview(subView)
        }
        
        saveButton?.isHidden = true
    }
    
    private func endGameButton()
    {
        shuffleButton = UIButton.init(type: UIButtonType.custom)
        shuffleButton?.frame = CGRect.init(x: self.view.frame.midX + 10, y: self.view.frame.maxY - 100, width: 60, height: 50)
        shuffleButton?.setTitle("Shuffle", for: .normal)
        shuffleButton?.setTitleColor(UIColor.white, for: .normal)
        shuffleButton?.backgroundColor = UIColor.customRed
        shuffleButton?.titleLabel?.font = UIFont.init(name: "Avenir", size: 17)
        shuffleButton?.clipsToBounds = true
        shuffleButton?.layer.cornerRadius = 10.0
        shuffleButton?.addTarget(self, action: #selector(shuffle), for: UIControlEvents.touchDown)
        
        if let subView = self.shuffleButton
        {
            self.view.addSubview(subView)
        }
        
        shuffleButton?.isHidden = true
    }
    
    private func cancelButton()
    {
        let cancelButton = UIButton.init(type: UIButtonType.custom)
        cancelButton.frame = CGRect.init(x: self.view.frame.midX - 60, y: self.view.frame.maxY - 100, width: 60, height: 50)
        cancelButton.setTitle("Back", for: .normal)
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 10.0
        cancelButton.titleLabel?.font = UIFont.init(name: "Avenir", size: 17)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.backgroundColor = UIColor.transparentBlack
        cancelButton.addTarget(self, action: #selector(onCancelPressed), for: UIControlEvents.touchDown)
        
        self.view.addSubview(cancelButton)
    }
    
    @objc func goForward() {
        addGameSpaces()
        saveButton?.isHidden = true
        shuffleButton?.isHidden = false
        
        self.instructionsLabel?.text = STStringConstants.getGamePlayInstructions()
    }
    
    @objc private func shuffle() {
        if let n = Int(STSettings.instance().numPlayers) {
            let num = arc4random_uniform(UInt32(n)) + 1
            if let view = self.instructionsLabel
            {
                view.text = "Player " + String(num) + " must answer their question 😱."
            }
        }
    }
    
    @objc func onCancelPressed() {
        self.navigationController?.popViewController(animated: true)
    }

    // PRAGMA MARK for noah
    func setSetupInstructions(instructions: String) {
       self.instructionsLabel?.text = instructions
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // Render Functions - - - - - -
    
    //Handles rendering of a NEW node (ie: Add)
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.switchPlane(node: node, anchor: planeAnchor)
            }
        }
    }
    
    //Handles rendering of an EXISTING node (ie: Update)
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.updatePlane(node: node, anchor: planeAnchor)
            }
            
        }
    }
    
    // Interaction Callbacks - - - - - -

    // MARK: Gesture handlers
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
//        let tapLocation = sceneView.center// Get the center point, of the SceneView.
        let tapLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        if let hitTestResult = hitTestResults.first{
            //only place on the current board
            if(hitTestResult.anchor == plane?.anchor) {
                let translation = hitTestResult.worldTransform.translation
                let x = translation.x
                let y = translation.y
                let z = translation.z
                
                //TODO: yuck, should just do a relative location but tired
                plane?.addCord(cordPosition: SCNVector3(x,y,z), rootNode: sceneView.scene.rootNode, numPlayers: Int(STSettings.instance().numPlayers)!)
            }
        }
        
        let hitTestResults2 = sceneView.hitTest(tapLocation)
        
        guard let hitTestResult2 = hitTestResults2.first else { return }
        
        //only place on the current board
        let doneWithSetup = plane?.interactNode(sphereNode: hitTestResult2.node as? SphereNode, rootNode: sceneView.scene.rootNode, numPlayers: Int(STSettings.instance().numPlayers)!)
        
        if(doneWithSetup != nil) {
            saveButton?.isHidden = false
            inGameState = true
        }
    }
    
    // Helper Methods - - - - - -

    //helper function to switch to a new plane, removes the existing one (if present) and renders a new one
    private func switchPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        //remove the existing plane from the scene
        plane?.removeFromParentNode()
        
        //save the new plane
//        board = Board(anchor)
//        node.addChildNode((board)!)
        
        plane = Plane(anchor) //replace with board just checking rendering

        
        //add the new plane to the scene
        if let p = plane {
            node.addChildNode(p)
        }
    }
    
    //helper function to update the existing plane, i.e. extend it if more area was found
    func updatePlane(node: SCNNode, anchor: ARPlaneAnchor) {
        //if this is not the current plane, we've seen it before, switch to it being the primary one
        if let p = plane, p.anchor != anchor {
            switchPlane(node: node, anchor: anchor);
        }
        //extend the current plane
        plane?.update(anchor)
    }
    
    func addGameSpaces() {
        let numPlayers:Int? = Int(STSettings.instance().numPlayers)
        let gameSpaces:[GameSpace] = createGameSpaces(numPlayers: numPlayers!)
        
        for space in gameSpaces {
            sceneView.scene.rootNode.addChildNode(space)
        };
    }
    
    func createGameSpaces(numPlayers: Int) -> [GameSpace] {
        var gameSpaces: [GameSpace] = []
        
        boardWidth = (plane?.cord1?.position.distance(to: (plane?.cord2?.position)!))!
        
        let degApart: CGFloat = 360 / CGFloat(numPlayers)
        let center: SCNVector3 = (plane?.cord1?.position.midpoint(to: (plane?.cord3?.position)!))!
        let radius = CGFloat(boardWidth / 2.0)
        let questions = QuestionManager.getNRandomQuestions(n: numPlayers)
        
        for n in 0...(numPlayers - 1) {
            let angle = CGFloat(n) * degApart
            let xyCoord = polarToCartesian(angle: angle, radius: radius, center: center)
            
            let gameSpace:GameSpace = GameSpace(x: xyCoord.x, y: 0, z: xyCoord.y, questionString: questions[n], idx: String(n + 1))
            
            gameSpaces.append(gameSpace)
        }
        
        return gameSpaces
    }
    
    func polarToCartesian(angle: CGFloat, radius: CGFloat, center: SCNVector3) -> CGPoint {
        let x: CGFloat = (radius * cos(degToRad(angle: angle))) + CGFloat(center.x)
        let z: CGFloat = radius * sin(degToRad(angle: angle)) + CGFloat(center.z)
        return CGPoint(x: x, y: z)
    }
    
    func degToRad(angle: CGFloat) -> CGFloat {
        return angle * .pi / 180
    }
    
    
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension UIColor {
    
    class var primaryColor: UIColor {
        return UIColor(red:0.32, green:0.50, blue:0.76, alpha:1.0)
    }
    
    class var customRed: UIColor {
        return UIColor(red:0.80, green:0.25, blue:0.25, alpha:1.0)
    }
    
    class var customTeal: UIColor {
        return UIColor(red:0.31, green:0.77, blue:0.72, alpha:1.0)
    }
    
    class var customPurple: UIColor {
        return UIColor(red:0.33, green:0.23, blue:0.44, alpha:1.0)
    }
    
    class var customGreen: UIColor {
        return UIColor(red:0.61, green:0.93, blue:0.36, alpha:1.0)
    }
    
    class var customYellow: UIColor {
        return UIColor(red:0.94, green:0.96, blue:0.40, alpha:1.0)
    }
    
    class var transparentBlack: UIColor {
        return UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.7)
    }
}
