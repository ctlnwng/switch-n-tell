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
    
    var planes = [ARPlaneAnchor: Plane]()
    
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
        planes[anchor] = plane
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
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                self.updatePlane(anchor: planeAnchor)
            }
        }
    }
    
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
            plane.update(anchor)
        }
    }
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
