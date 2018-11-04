//
//  Board.swift
//  SwitchNTell
//
// To represent a game board in Switch n Tell
//
//  Created by Noah Appleby on 11/3/18.
//  Copyright © 2018 SwitchNTell. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit


class Board: SCNNode {
    
    var anchor: ARPlaneAnchor

    var cord1, cord2, cord3, cord4 : SphereNode?
    
    var nodeColor = UIColor.orange;
    var nodeRadius = CGFloat.init(0.1);
    
    
    var planeGeometry: SCNPlane
    var planeNode: SCNNode
    
    init(_ anchor: ARPlaneAnchor) {
        self.anchor = anchor
        
        let grid = UIImage(named: "plane_grid.png") //TODO: replace with a RUG (@wayfair)
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let material = SCNMaterial()
        material.diffuse.contents = grid
        self.planeGeometry.materials = [material]
        
        self.planeGeometry.firstMaterial?.transparency = 0.5
        self.planeNode = SCNNode(geometry: planeGeometry)
        self.planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
        
        super.init()
        
        self.addChildNode(planeNode)
        
        self.position = SCNVector3(anchor.center.x, -0.002, anchor.center.z) // 2 mm below the origin of plane.
    }
    
//    func addCord(cordPosition: SCNVector3) {
//        let sphere = SCNSphere(color: self.nodeColor, radius: CGFloat(self.nodeRadius))
//        let sphereNode = SphereNode(sphere: sphere)
//        
//        self.addChildNode(sphereNode)
//        //TODO TODO add to cord object depending on...
//    }
//    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //remove all children
    override func removeFromParentNode() {
        planeNode.removeFromParentNode()
        cord1?.removeFromParentNode()
        cord2?.removeFromParentNode()
        cord3?.removeFromParentNode()
        cord4?.removeFromParentNode()
    }
    
    func update(_ anchor: ARPlaneAnchor) {
        self.anchor = anchor;
        
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        
        self.position = SCNVector3Make(anchor.center.x, -0.002, anchor.center.z)
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
