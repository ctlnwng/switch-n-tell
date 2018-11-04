//
//  ViewController.swift
//  SwitchNTell
//
//  Created by Bahar Sheikhi on 11/3/18.
//  Copyright © 2018 SwitchNTell. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class BoardViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var boardWidth:Float = 4.0
    var instructionsView: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numPlayers:Int? = Int(STSettings.instance().numPlayers)

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        let scene = SCNScene()
        
        let gameSpaces:[GameSpace] = createGameSpaces(numPlayers: numPlayers!)
        
        for space in gameSpaces {
            scene.rootNode.addChildNode(space)
        };
        
        // Set the scene to the view
        sceneView.scene = scene
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSceneView();
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.addInstructions()
        self.shuffleButton()
        self.cancelButton()
    }

    private func addInstructions() {
        let topMargin: CGFloat = 15
        let instructionsHeight: CGFloat = 100
        self.instructionsView = UILabel.init()
        if let view = self.instructionsView {
        view.text = STStringConstants.getGamePlayInstructions()
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        view.backgroundColor = UIColor.gray
        view.textColor = UIColor.white
        view.frame = CGRect.init(x: self.view.frame.minX, y: topMargin, width: self.view.frame.width, height: instructionsHeight)
        self.view.addSubview(view)
        }
    }
    
    private func shuffleButton()
    {
        let shuffleButton = UIButton.init(type: UIButtonType.custom)
        shuffleButton.frame = CGRect.init(x: self.view.frame.midX, y: self.view.frame.maxY - 40, width: 50, height: 100)
        shuffleButton.setTitle("Shuffle", for: .normal)
        shuffleButton.setTitleColor(UIColor.red, for: .normal)
        shuffleButton.backgroundColor = UIColor.gray
        shuffleButton.addTarget(self, action: #selector(shuffle), for: UIControlEvents.touchDown)
        
        self.view.addSubview(shuffleButton)
    }
    
    @objc private func shuffle() {
        if let n = Int(STSettings.instance().numPlayers) {
            let num = arc4random_uniform(UInt32(n)) + 1
            if let view = self.instructionsView
            {
                view.text = "Player " + String(num)
            }
        }
    }
    
    private func cancelButton()
    {
        let cancelButton = UIButton.init(type: UIButtonType.custom)
        cancelButton.frame = CGRect.init(x: self.view.frame.midX - 50, y: self.view.frame.maxY - 40, width: 50, height: 100)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        cancelButton.backgroundColor = UIColor.blue
        cancelButton.addTarget(self, action: #selector(onCancelPressed), for: UIControlEvents.touchDown)
        
        self.view.addSubview(cancelButton)
    }
    
    @objc func onCancelPressed() {
       //self.performSegue(withIdentifier: "goBackToSetup", sender: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    func setUpSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }

    func createGameSpaces(numPlayers: Int) -> [GameSpace] {
        var gameSpaces: [GameSpace] = []
        
        let degApart:CGFloat = 360 / CGFloat(numPlayers)
        let radius = CGFloat(boardWidth / 2.0)
        let questions = QuestionManager.getNRandomQuestions(n: numPlayers)

        for n in 0...(numPlayers - 1) {
            let angle = CGFloat(n) * degApart
            let xyCoord = polarToCartesian(angle: angle, radius: radius)
            
            let gameSpace:GameSpace = GameSpace(x: xyCoord.x, y: 0, z: xyCoord.y - radius, questionString: questions[n])
            
            gameSpaces.append(gameSpace)
        }
        
        return gameSpaces
    }
    
    func polarToCartesian(angle: CGFloat, radius: CGFloat) -> CGPoint {
        let x: CGFloat = radius * cos(degToRad(angle: angle))
        let z: CGFloat = radius * sin(degToRad(angle: angle))
        return CGPoint(x: x, y: z)
    }
    
    func degToRad(angle: CGFloat) -> CGFloat {
        return angle * .pi / 180
    }

    // MARK: - ARSCNViewDelegate
 
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()

     return node
     }
     */

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }
}

extension UIColor {
    
    class var customBlue: UIColor {
        return UIColor(red:0.37, green:0.49, blue:0.89, alpha:1.0)
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
}
