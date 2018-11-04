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
    
    //Board to place on
    var board : Board?
    var plane : Plane?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create TapGesture Recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        sceneView.addGestureRecognizer(tap)
        
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
        
        let tapLocation = sceneView.center// Get the center point, of the SceneView.
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else { return }
        
        //only place on the current board
        if(hitTestResult.anchor == plane?.anchor) {
            let translation = hitTestResult.worldTransform.translation
            let x = translation.x
            let y = translation.y
            let z = translation.z
            
            //TODO: yuck, should just do a relative location but tired
            plane?.addCord(cordPosition: SCNVector3(x,y,z), rootNode: sceneView.scene.rootNode)
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
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
