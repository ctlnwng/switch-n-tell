//
//  Question.swift
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
    
    override init() {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        
        // Circle
        self.sphere = SCNSphere(radius: 0.1)
        self.sphere.materials = [material]
        
        self.sphereNode = SCNNode(geometry: sphere)
        self.sphereNode.position = SCNVector3(0,0,-0.5)
        
        let boundingBoxMin = sphere.boundingBox.min
        let boundingBoxMax = sphere.boundingBox.max
        
        // Question
        self.question = SCNText(string: "What is your most traumatic memory?", extrusionDepth: 0.0)
        self.question.font = UIFont (name: "Arial", size: 1)
        self.question.isWrapped = true;
        
        self.questionNode = SCNNode(geometry: question)
        self.questionNode.position = SCNVector3(0, 0, 0)
        self.questionNode.scale = SCNVector3(0.1, 0.1, 0.1)
        
        super.init()
        
        self.center(node: self.questionNode)
        
        self.addChildNode(sphereNode)
        self.addChildNode(questionNode)
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


