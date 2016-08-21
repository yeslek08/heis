////
////  GameScene.swift
////  dimo
////
////  Created by Ken Chen on 8/14/16.
////  Copyright (c) 2016 heis. All rights reserved.
////
//
//import SpriteKit
//
//let BlockSize: CGFloat = 20.0
//let TickLengthLevelOne = NSTimeInterval(600)
//
//class SGameScene: SKScene {
//    //    override func didMoveToView(view: SKView) {
//    //        /* Setup your scene here */
//    //        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//    //        myLabel.text = "Hello, World!"
//    //        myLabel.fontSize = 45
//    //        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//    //
//    //        self.addChild(myLabel)
//    //    }
//    //
//    //    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//    //       /* Called when a touch begins */
//    //
//    //        for touch in touches {
//    //            let location = touch.locationInNode(self)
//    //
//    //            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//    //
//    //            sprite.xScale = 0.5
//    //            sprite.yScale = 0.5
//    //            sprite.position = location
//    //
//    //            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//    //
//    //            sprite.runAction(SKAction.repeatActionForever(action))
//    //
//    //            self.addChild(sprite)
//    //        }
//    //    }
//    
//    let gameLayer = SKNode()
//    let shapeLayer = SKNode()
//    let LayerPosition = CGPoint(x: 10, y: -10)
//    
//    var tick: (() -> ())?
//    var tickLengthMillis = TickLengthLevelOne
//    var lastTick: NSDate?
//    
//    var textureCache = Dictionary<String, SKTexture>()
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("NSCoder not supported")
//    }
//    
//    override init(size: CGSize) {
//        super.init(size: size)
//        anchorPoint = CGPoint(x: 0, y: 1.0)
//        
//        let background = SKSpriteNode(imageNamed: "background")
//        //        background.position = CGPoint(x: 0, y: 0)
//        //        background.anchorPoint = CGPoint(x: 0, y: 1.0)
//        background.anchorPoint = CGPointMake(0.5, 0.5)
//        background.position = CGPointMake(self.size.width / 2, self.size.height / 2)
//        addChild(background)
//        
//        addChild(gameLayer)
//        
//        let gameBoardTexture = SKTexture(imageNamed: "gameboard")
//        let gameBoard = SKSpriteNode(texture: gameBoardTexture,
//                                     size: CGSizeMake(BlockSize * CGFloat(NumColumns), BlockSize * CGFloat(NumRows)))
//        gameBoard.anchorPoint = CGPoint(x: 0, y: 1.0)
//        gameBoard.position = LayerPosition
//        
//        shapeLayer.position = LayerPosition
//        shapeLayer.addChild(gameBoard)
//        gameLayer.addChild(shapeLayer)
//        
//        // Add theme music ;)
//        let sound = SKAction.playSoundFileNamed("Sounds/theme.mp3", waitForCompletion: false)
//        
//        //        runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("Sounds/theme.mp3", waitForCompletion: true)))
//        //        playSoundAction(SKAction.repeatActionForever(sound))
//    }
//    
//    func playSound(sound: String) {
//        runAction(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
//    }
//    
//    func playSoundAction(sound: SKAction) {
//        runAction(sound)
//    }
//    
//    
//    override func update(currentTime: CFTimeInterval) {
//        /* Called before each frame is rendered */
//        guard lastTick != nil else {
//            return
//        }
//        let timePassed = lastTick!.timeIntervalSinceNow * -1000.0
//        if timePassed > tickLengthMillis {
//            self.lastTick = NSDate()
//            tick?()
//        }
//    }
//    
//    func startTicking() {
//        lastTick = NSDate()
//    }
//    
//    func stopTicking() {
//        lastTick = nil
//    }
//    
//    func pointForColumn(column: Int, row: Int) -> CGPoint {
//        let x = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize / 2)
//        let y = LayerPosition.y - ((CGFloat(row) * BlockSize) + (BlockSize / 2))
//        return CGPointMake(x, y)
//    }
//    
//    func addPreviewShapeToScene(shape: Shape, completion: () -> ()) {
//        for block in shape.blocks {
//            var texture = textureCache[block.spriteName]
//            // First time accessing texture store it in the cache
//            if texture == nil {
//                texture = SKTexture(imageNamed: block.spriteName)
//                textureCache[block.spriteName] = texture
//            }
//            let sprite = SKSpriteNode(texture: texture)
//            
//            sprite.position = pointForColumn(block.column, row: block.row - 2)
//            shapeLayer.addChild(sprite)
//            block.sprite = sprite
//            
//            // Animation
//            sprite.alpha = 0
//            
//            let moveAction = SKAction.moveTo(pointForColumn(block.column, row: block.row),
//                                             duration: NSTimeInterval(0.2))
//            moveAction.timingMode = .EaseOut // Lel more ease functions?
//            let fadeInAction = SKAction.fadeAlphaTo(0.7, duration: 0.4)
//            fadeInAction.timingMode = .EaseOut
//            sprite.runAction(SKAction.group([moveAction, fadeInAction]))
//        }
//        runAction(SKAction.waitForDuration(0.4), completion: completion)
//    }
//    
//    func movePreviewShape(shape: Shape, completion: () -> ()) {
//        for block in shape.blocks {
//            let sprite = block.sprite!
//            let moveTo = pointForColumn(block.column, row: block.row)
//            let moveToAction: SKAction = SKAction.moveTo(moveTo, duration: 0.2)
//            moveToAction.timingMode = .EaseOut
//            let fadeInAction: SKAction = SKAction.fadeAlphaTo(1.0, duration: 0.2)
//            sprite.runAction(SKAction.group([moveToAction, fadeInAction]), completion: {})
//        }
//        runAction(SKAction.waitForDuration(0.2), completion: completion)
//    }
//    
//    func redrawShape(shape: Shape, completion: () -> ()) {
//        for block in shape.blocks {
//            let sprite = block.sprite!
//            let moveTo = pointForColumn(block.column, row: block.row)
//            let moveToAction: SKAction = SKAction.moveTo(moveTo, duration: 0.05)
//            moveToAction.timingMode = .EaseOut
//            if block == shape.blocks.last {
//                sprite.runAction(moveToAction, completion: completion)
//            } else {
//                sprite.runAction(moveToAction)
//            }
//            
//        }
//    }
//    
//    // Add swag explosions
//    func animateCollapsingLines(linesToRemove: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>, completion:() -> ()) {
//        var longestDuration: NSTimeInterval = 0
//        // #2
//        for (columnIdx, column) in fallenBlocks.enumerate() {
//            for (blockIdx, block) in column.enumerate() {
//                let newPosition = pointForColumn(block.column, row: block.row)
//                let sprite = block.sprite!
//                // #3
//                let delay = (NSTimeInterval(columnIdx) * 0.05) + (NSTimeInterval(blockIdx) * 0.05)
//                let duration = NSTimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
//                let moveAction = SKAction.moveTo(newPosition, duration: duration)
//                moveAction.timingMode = .EaseOut
//                sprite.runAction(
//                    SKAction.sequence([
//                        SKAction.waitForDuration(delay),
//                        moveAction]))
//                longestDuration = max(longestDuration, duration + delay)
//            }
//        }
//        
//        for rowToRemove in linesToRemove {
//            for block in rowToRemove {
//                // #4
//                let randomRadius = CGFloat(UInt(arc4random_uniform(400) + 100))
//                let goLeft = arc4random_uniform(100) % 2 == 0
//                
//                var point = pointForColumn(block.column, row: block.row)
//                point = CGPointMake(point.x + (goLeft ? -randomRadius : randomRadius), point.y)
//                
//                let randomDuration = NSTimeInterval(arc4random_uniform(2)) + 0.5
//                // #5
//                var startAngle = CGFloat(M_PI)
//                var endAngle = startAngle * 2
//                if goLeft {
//                    endAngle = startAngle
//                    startAngle = 0
//                }
//                let archPath = UIBezierPath(arcCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
//                let archAction = SKAction.followPath(archPath.CGPath, asOffset: false, orientToPath: true, duration: randomDuration)
//                archAction.timingMode = .EaseIn
//                let sprite = block.sprite!
//                // #6
//                sprite.zPosition = 100
//                sprite.runAction(
//                    SKAction.sequence(
//                        [SKAction.group([archAction, SKAction.fadeOutWithDuration(NSTimeInterval(randomDuration))]),
//                            SKAction.removeFromParent()]))
//            }
//        }
//        // #7
//        runAction(SKAction.waitForDuration(longestDuration), completion:completion)
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
