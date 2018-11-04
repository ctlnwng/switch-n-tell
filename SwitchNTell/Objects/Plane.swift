//
//  Plane.swift
//  SwitchNTell
//
//  To represent a Plane in the user's world.
//
//  Source of original file: https://gist.githubusercontent.com/AbovegroundDan/dcc1da6f7a651fe3ab073402a185d26e/raw/da07f834af1388fe922836a0fa4a95c2c6043178/plane.swift
//

import Foundation
import UIKit
import SceneKit
import ARKit

class Plane: SCNNode {
    var anchor: ARPlaneAnchor
    
    var nodeColor = UIColor.green;
    var tempNodeColor = UIColor.orange;

    var nodeRadius = CGFloat.init(0.1);
    
    var planeGeometry: SCNPlane
    var planeNode: SCNNode
    
    var cord1, cord2, cord3, cord4 : SphereNode?
    
    var tempCord1, tempCord2, tempCord3, tempCord4 : SphereNode?
    
    init(_ anchor: ARPlaneAnchor) {
        
        self.anchor = anchor
        
        let grid = UIImage(named: "plane_grid.png") //TODO: replace with a RUG (@wayfair)
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let material = SCNMaterial()
        material.diffuse.contents = grid
        self.planeGeometry.materials = [material]
        
        self.planeGeometry.firstMaterial?.transparency = 0.5
        self.planeNode = SCNNode(geometry: planeGeometry) //ah this isn't appearing
        self.planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1, 0, 0)
        
        super.init()
        
        self.addChildNode(planeNode)
    }
    
    func update(_ anchor: ARPlaneAnchor) {
        self.anchor = anchor
        
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        
        self.position = SCNVector3Make(anchor.center.x, -0.002, anchor.center.z)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCord(cordPosition: SCNVector3, rootNode: SCNNode) {
        let sphere = SCNSphere(color: self.nodeColor, radius: CGFloat(self.nodeRadius))
        let tempSphere = SCNSphere(color: self.tempNodeColor, radius: CGFloat(self.nodeRadius))

        
        //if Node 1, place wherever
        if(cord1 == nil && cord2 == nil && cord3 == nil && cord4 == nil) {
            cord1 = SphereNode(sphere: sphere, position: cordPosition)
            //make three options around it
            tempCord1 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x + 1, cordPosition.y, cordPosition.z))
            tempCord2 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x, cordPosition.y, cordPosition.z + 1))
            tempCord3 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x - 1, cordPosition.y, cordPosition.z))
            tempCord4 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x, cordPosition.y, cordPosition.z - 1))

            if let c1 = cord1, let tc1 = tempCord1, let tc2 = tempCord2, let tc3 = tempCord3, let tc4 = tempCord4 {
                rootNode.addChildNode(c1)
                rootNode.addChildNode(tc1)
                rootNode.addChildNode(tc2)
                rootNode.addChildNode(tc3)
                rootNode.addChildNode(tc4)
            }
        }
        
        //TODO TODO add to cord object depending on...
    }
    
    func interactNode(sphereNode: SphereNode?, rootNode: SCNNode){
        let sphere = SCNSphere(color: self.nodeColor, radius: CGFloat(self.nodeRadius)) //TODO: repeat

        if(sphereNode == tempCord1), let c = tempCord1 {
            cord2 = SphereNode(sphere: sphere, position: c.position)
            tempCord1?.removeFromParentNode();
        }
        if(sphereNode == tempCord2), let c = tempCord2 {
            cord2 = SphereNode(sphere: sphere, position: c.position)
            tempCord2?.removeFromParentNode();
        }
        if(sphereNode == tempCord3), let c = tempCord3 {
            cord2 = SphereNode(sphere: sphere, position: c.position)
            tempCord3?.removeFromParentNode();
        }
        if(sphereNode == tempCord4), let c = tempCord4 {
            cord2 = SphereNode(sphere: sphere, position: c.position)
            tempCord4?.removeFromParentNode();
        }
        if let c2 = cord2 {
            rootNode.addChildNode(c2)
        }
    }

    
    //remove all children
    override func removeFromParentNode() {
        super.removeFromParentNode()
        cord1?.removeFromParentNode()
        cord2?.removeFromParentNode()
        cord3?.removeFromParentNode()
        cord4?.removeFromParentNode()
        tempCord1?.removeFromParentNode()
        tempCord2?.removeFromParentNode()
        tempCord3?.removeFromParentNode()
        tempCord4?.removeFromParentNode()
    }
}


//TODO: replace with game corner
class SphereNode: SCNNode {
    
    
    init(sphere: SCNSphere, position: SCNVector3 ) {
        super.init()
        self.geometry = sphere
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SCNSphere {
    
    convenience init(color: UIColor, radius: CGFloat) {
        self.init(radius: radius)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        materials = [material]
    }
}
