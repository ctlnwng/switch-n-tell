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
        self.sphereNode.position = SCNVector3(x: 0, y: 0, z: -0.5)
        
//        let boundingBoxMin = sphere.boundingBox.min
//        let boundingBoxMax = sphere.boundingBox.max

//        let boundingRect = CGRect(x: CGFloat(sphereNode.position.x),
//                                  y: CGFloat(sphereNode.position.y),
//                                  width: sphere.radius * 2,
//                                  height: sphere.radius * 2)
//        let boundingRect = CGRect(origin: .zero, size: CGSize(width: 100.0, height: 500.0))
    
        
        // Question
        self.question = SCNText(string: "What is your most traumatic memory?", extrusionDepth: 0.0)
//        self.question.containerFrame = boundingRect
        self.question.font = UIFont (name: "Arial", size: 2)
//        self.question.isWrapped = true;
        
        
        self.questionNode = SCNNode(geometry: question)
        self.questionNode.position = SCNVector3(x: sphereNode.position.x,
                                                y: sphereNode.position.y,
                                                z: sphereNode.position.z + Float(sphere.radius))
        
        let (min, max) = questionNode.boundingBox
        
        let textWidth = max.x - min.x
        let textHeight = max.y - min.y
        let sphereWidth = sphere.radius * 2;
        let sphereHeight = sphere.radius * 2;
        let scale = sphereWidth / CGFloat(textWidth);
        
        print(scale)
        self.questionNode.scale = SCNVector3(0.01, 0.01, 0.01)
    
        
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        self.questionNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        //2. Get The Width & Height Of Our Node
        super.init()
        
//        self.center(node: self.questionNode)
        
        self.addChildNode(questionNode)
        self.addChildNode(sphereNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func center(node: SCNNode) {
//        let (min, max) = node.boundingBox
//
//        let dx = min.x + 0.5 * (max.x - min.x)
//        let dy = min.y + 0.5 * (max.y - min.y)
//        let dz = min.z + 0.5 * (max.z - min.z)
//        node.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
//    }
}


