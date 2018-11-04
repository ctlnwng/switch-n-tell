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

//        scene.rootNode.addChildNode(gameSpace)
        
        // Set the scene to the view
        sceneView.scene = scene
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSceneView();
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
