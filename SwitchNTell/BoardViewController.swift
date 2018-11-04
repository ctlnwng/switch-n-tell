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
    var instructionsView: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!

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
        let view = UILabel.init()
        view.text = STStringConstants.getGamePlayInstructions()
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        view.backgroundColor = UIColor.gray
        view.textColor = UIColor.white
        view.frame = CGRect.init(x: self.view.frame.minX, y: topMargin, width: self.view.frame.width, height: instructionsHeight)
        self.view.addSubview(view)
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
        
    }
    
    private func cancelButton()
    {
        let shuffleButton = UIButton.init(type: UIButtonType.custom)
        shuffleButton.frame = CGRect.init(x: self.view.frame.midX - 50, y: self.view.frame.maxY - 40, width: 50, height: 100)
        shuffleButton.setTitle("Cancel", for: .normal)
        shuffleButton.setTitleColor(UIColor.red, for: .normal)
        shuffleButton.backgroundColor = UIColor.blue
        
        self.view.addSubview(shuffleButton)
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

    func createBoard(plane: SCNPlane, numPlayers: Int) {
        

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
