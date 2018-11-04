//
//  GameSpace.swift
//  SwitchNTell
//
//  Created by Caitlin Wang on 11/3/18.
//  Copyright © 2018 SwitchNTell. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class GameSpace: SCNNode {
    var sphere: SCNSphere
    var sphereNode: SCNNode
    
    var question: SCNText
    var questionNode: SCNNode
    
    init(x: CGFloat, y: CGFloat, z: CGFloat, questionString: String, idx: String) {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.transparentBlack
        
        // Circle
        self.sphere = SCNSphere(radius: 0.18)
        self.sphere.materials = [material]
        
        self.sphereNode = SCNNode(geometry: sphere)
        self.sphereNode.position = SCNVector3(x: Float(x), y: Float(y), z: Float(z))
        
        // Question
        self.question = SCNText(string: idx + ". " + questionString, extrusionDepth: 0.0)
        self.question.font = UIFont (name: "Avenir-Medium", size: 4)
        self.question.containerFrame = CGRect(origin: CGPoint(x: CGFloat(sphereNode.position.x), y: CGFloat(sphereNode.position.y)), size: CGSize(width: sphere.radius * 200, height: 100.0))
        self.question.isWrapped = true
        self.question.alignmentMode = kCAAlignmentCenter
        
        self.questionNode = SCNNode(geometry: question)
        self.questionNode.position = SCNVector3(x: sphereNode.position.x,
                                                y: sphereNode.position.y,
                                                z: sphereNode.position.z + Float(sphere.radius))
        
        self.questionNode.scale = SCNVector3Make(0.01, 0.01, 0.01)
        
        super.init()
        
        self.center(node: self.questionNode)
        
        self.addChildNode(questionNode)
        self.addChildNode(sphereNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func center(node: SCNNode) {
        let (min, max) = node.boundingBox

        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        node.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
    }
}


