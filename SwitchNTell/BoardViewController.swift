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
    var boardWidth:CGFloat = 4.0
    var instructionsView: UILabel?
    var plane: Plane?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numPlayers:Int? = Int(STSettings.instance().numPlayers)

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        let scene = SCNScene()
        
        let gameSpaces:[GameSpace] = createGameSpaces(numPlayers: numPlayers!)
        
        boardWidth = (plane?.cord1?.position.distance(to: (plane?.cord2?.position)!))!
        
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
        
        
        let degApart: CGFloat = 360 / CGFloat(numPlayers)
        let center: SCNVector3 = (plane?.cord1?.position.midpoint(to: (plane?.cord3?.position)!))!
        let radius = CGFloat(boardWidth / 2.0)
        let questions = QuestionManager.getNRandomQuestions(n: numPlayers)

        for n in 0...(numPlayers - 1) {
            let angle = CGFloat(n) * degApart
            let xyCoord = polarToCartesian(angle: angle, radius: radius, center: center)
            
            let gameSpace:GameSpace = GameSpace(x: xyCoord.x, y: CGFloat(center.y), z: xyCoord.y, questionString: questions[n])
            
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
