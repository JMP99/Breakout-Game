//
//  GameScene.swift
//  Breakout
//
//  Created by Student on 3/13/17.
//  Copyright © 2017 Student. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ball = SKShapeNode()
    var paddle = SKSpriteNode()
    var bricks = [SKSpriteNode]()
    

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createBackground()
        makeBall()
        multipleBricks()
        makePaddle()
        makeLoseZone()
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 2, dy: 3))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
        //else {
        
        //}
    }
    

    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1 {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.position = CGPoint(x: 0, y: starsBackground.size.height * CGFloat(i))
            starsBackground.size = CGSize(width: frame.width, height: frame.height + 10000)
            addChild(starsBackground)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 250)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
    }
    
    func makeBall() {
        ball = SKShapeNode(circleOfRadius: 20)
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.strokeColor = UIColor.black
        ball.fillColor = UIColor.yellow
        ball.name = "ball"
        // physics shape matches ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ingores all forces and impulses
        ball.physicsBody?.isDynamic = false
        // use precise collision detection
        ball.physicsBody?.usesPreciseCollisionDetection = true
        //no loss of energy from friction
        ball.physicsBody?.friction = 0
        // gravity is not a factor
        ball.physicsBody?.affectedByGravity = false
        //bounces fully off of other objects
        ball.physicsBody?.restitution = 1
        //does not slow down over time
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask =
            (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball) // add ball object to the view
    }
    
    
    func makePaddle() {
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width:frame.width/4, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    

    func makeLoseZone() {
        let loseZone = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width, height:50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    
    func multipleBricks() {
        let countB = Int(frame.width) / 100
        let height = Int(frame.maxY)
        let xOffset = (Int(frame.width) - (countB * 100)) / 10 + Int(frame.minX) + 50
        for x in 0..<countB{makeBrick(x: x * 100 + xOffset, y: height - 100) }
        for x in 0..<countB{makeBrick(x: x * 100 + xOffset, y: height - 250) }
        for x in 0..<countB{makeBrick(x: x * 100 + xOffset, y: height - 400) }



    
    
    
    }
    
    func makeBrick(x: Int, y: Int) {
        let brick = SKSpriteNode(imageNamed: "brick")
        
        brick.position = CGPoint(x: x, y: y)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
        bricks.append(brick)
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        for brick in bricks{
            if contact.bodyA.node == brick ||
                contact.bodyB.node == brick {
                brick.removeFromParent()
                brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
                brick.physicsBody?.isDynamic = false

                
            }
            
            
            if contact.bodyA.node?.name == "loseZone" ||
                contact.bodyB.node?.name == "loseZone" {
                ball.removeFromParent()
                makeBall()
                ball.physicsBody?.isDynamic = true
                ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 3))
                
            }
        }
        
    
    }
    
    
    
    
    
    
    
    
    
}




