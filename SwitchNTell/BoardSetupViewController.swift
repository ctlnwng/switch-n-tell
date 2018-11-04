//
//  BoardSetupViewController.swift
//  SwitchNTell
//
//  Created by Noah Appleby on 11/3/18.
//  Copyright © 2018 SwitchNTell. All rights reserved.
//

import Foundation

import UIKit
import SceneKit
import ARKit


class BoardSetupViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var onboarding: STOnboardingViewController?
    var instructionsLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNextVC()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Set the scene to the view
        sceneView.scene = scene
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //        DispatchQueue.main.async {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            self.addPlane(node: node, anchor: planeAnchor)
        }
        //        }
    }
    
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        let plane = Plane(anchor)
        node.addChildNode(plane)
    }
    
    private func setupNextVC() {
        //Create TapGesture Recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        sceneView.addGestureRecognizer(tap)
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
        self.saveButton()
        self.cancelButton()
    
    }
    
    private func saveButton()
    {
        let shuffleButton = UIButton.init(type: UIButtonType.custom)
        shuffleButton.frame = CGRect.init(x: self.view.frame.midX + 10, y: self.view.frame.maxY - 100, width: 60, height: 50)
        shuffleButton.setTitle("Next", for: .normal)
        shuffleButton.setTitleColor(UIColor.white, for: .normal)
        shuffleButton.backgroundColor = UIColor.red
        shuffleButton.clipsToBounds = true
        shuffleButton.layer.cornerRadius = 10.0
        shuffleButton.addTarget(self, action: #selector(goForward), for: UIControlEvents.touchDown)
        
        self.view.addSubview(shuffleButton)
    }
    
    private func cancelButton()
    {
        let cancelButton = UIButton.init(type: UIButtonType.custom)
        cancelButton.frame = CGRect.init(x: self.view.frame.midX - 60, y: self.view.frame.maxY - 100, width: 60, height: 50)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 10.0
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.backgroundColor = UIColor.gray
        cancelButton.addTarget(self, action: #selector(onCancelPressed), for: UIControlEvents.touchDown)
        
        self.view.addSubview(cancelButton)
    }
    
    @objc func goForward() {
        self.performSegue(withIdentifier: "goToBoard", sender: nil)
    }
    
    
    @objc func onCancelPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func addSetupInstructions() {
        let topMargin: CGFloat = 35
        let instructionsHeight: CGFloat = 60
        self.instructionsLabel = UILabel.init()
        if let view = self.instructionsLabel {
        view.text = STStringConstants.getSetupBoardInstructions()
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        view.backgroundColor = UIColor.gray
        view.textColor = UIColor.white
        view.frame = CGRect.init(x: self.view.frame.minX, y: topMargin, width: self.view.frame.width, height: instructionsHeight)
        self.view.addSubview(view)
        }
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
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    
    var nodes: [SCNNode] = []
    
    var nodeColor = UIColor.orange;
    var nodeRadius = CGFloat.init(0.1);
    
    // MARK: Gesture handlers
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        let tapLocation = sceneView.center// Get the center point, of the SceneView.
        let hitTestResults = sceneView.hitTest(tapLocation, types:.featurePoint)
        
        if let result = hitTestResults.first {
            let position = SCNVector3.positionFrom(matrix: result.worldTransform)
            let sphere = SCNSphere(color: self.nodeColor, radius: CGFloat(self.nodeRadius))
            let node = SCNNode(geometry: sphere)
            node.position = position;
            sceneView.scene.rootNode.addChildNode(node)
            nodes.append(node)
        }
    }
    // Code Example from https://github.com/kravik/ArMeasureDemo/blob/master/ArMeasureDemo/ViewController.swift
}

//TODO: move to objects directory if keep beyond testing
extension SCNSphere {
    convenience init(color: UIColor, radius: CGFloat) {
        self.init(radius: radius)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        materials = [material]
    }
}

extension SCNVector3 {
    func distance(to destination: SCNVector3) -> CGFloat {
        let dx = destination.x - x
        let dy = destination.y - y
        let dz = destination.z - z
        return CGFloat(sqrt(dx*dx + dy*dy + dz*dz))
    }
    
    static func positionFrom(matrix: matrix_float4x4) -> SCNVector3 {
        let column = matrix.columns.3
        return SCNVector3(column.x, column.y, column.z)
    }
}
