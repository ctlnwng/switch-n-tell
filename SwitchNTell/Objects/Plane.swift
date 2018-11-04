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
    
    var nodeColor = UIColor.primaryColor;
    var tempNodeColor = UIColor.customRed;

    var nodeRadius = CGFloat.init(0.05);
    
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
    
    func addCord(cordPosition: SCNVector3, rootNode: SCNNode, numPlayers: Int) {
        let halfLength = Float(numPlayers) / 4.0;
        let sphere = SCNSphere(color: self.nodeColor, radius: CGFloat(self.nodeRadius))
        let tempSphere = SCNSphere(color: self.tempNodeColor, radius: CGFloat(self.nodeRadius))

        
        //if Node 1, place wherever
        if(cord1 == nil && cord2 == nil && cord3 == nil && cord4 == nil) {
            cord1 = SphereNode(sphere: sphere, position: cordPosition)
            //make three options around it
            tempCord1 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x + halfLength, cordPosition.y + 0.05, cordPosition.z))
            tempCord2 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x, cordPosition.y + 0.05, cordPosition.z + halfLength))
            tempCord3 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x - halfLength, cordPosition.y + 0.05, cordPosition.z))
            tempCord4 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x, cordPosition.y + 0.05, cordPosition.z - halfLength))

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
    
    func interactNode(sphereNode: SphereNode?, rootNode: SCNNode, numPlayers: Int) -> Bool {
        let halfLength = Float(numPlayers) / 4.0;
        let sphere = SCNSphere(color: self.nodeColor, radius: CGFloat(self.nodeRadius)) //TODO: repeat
        let tempSphere = SCNSphere(color: self.tempNodeColor, radius: CGFloat(self.nodeRadius)) //TODO: repeat

        if let node = sphereNode {
            let setNode = setNextNode(nextNode: SphereNode(sphere: sphere, position: node.position))
            
            tempCord1?.removeFromParentNode()
            tempCord2?.removeFromParentNode()
            tempCord3?.removeFromParentNode()
            tempCord4?.removeFromParentNode()
            
            rootNode.addChildNode(setNode)
            
            let cordPosition = setNode.position
            
            //TODO: this is ROUGH
            //when two cords have been placed, give two more options
            if(cord1 != nil && cord2 != nil && cord3 == nil && cord4 == nil) {
                
                //make three options around it
                if(cord1?.position.z == cord2?.position.z) {
                    tempCord1 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x, cordPosition.y + 0.05, cordPosition.z + halfLength))
                    tempCord2 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x, cordPosition.y + 0.05, cordPosition.z - halfLength))
                }
                else if(cord1?.position.x == cord2?.position.x)  {
                    tempCord1 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x + halfLength, cordPosition.y + 0.05, cordPosition.z))
                    tempCord2 = SphereNode(sphere: tempSphere, position: SCNVector3(cordPosition.x - halfLength, cordPosition.y + 0.05, cordPosition.z))
                }
                
                if let tc1 = tempCord1, let tc2 = tempCord2 {
                    rootNode.addChildNode(tc1)
                    rootNode.addChildNode(tc2)
                }
            }
            
            //when three cords have been placed, no need for more options
            else if(cord1 != nil && cord2 != nil && cord3 != nil && cord4 == nil) {
                
                let cordPosition = setNode.position
                
                if(cord2?.position.z == cord3?.position.z) {
                    cord4 = SphereNode(sphere: sphere, position: SCNVector3((cord3?.position.x)!, cordPosition.y, (cord1?.position.z)!))
                }
                else if(cord2?.position.x == cord3?.position.x) {
                    cord4 = SphereNode(sphere: sphere, position: SCNVector3((cord1?.position.x)!, cordPosition.y, (cord3?.position.z)!))
                }
                if let c4 = cord4 {
                    rootNode.addChildNode(c4)
                    return true
                }
            }
        }
        return false
    }
    
    private func setNextNode(nextNode: SphereNode) -> SphereNode {
        if(cord2 == nil) {
            cord2 = nextNode;
            return cord2!
        } else if (cord3 == nil) {
            cord3 = nextNode;
            return cord3!
        } else if (cord4 == nil) {
            cord4 = nextNode;
            return cord4!
        }
        return cord1! //TODO: lolno
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
