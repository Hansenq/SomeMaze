//
//  SMMainMaze.m
//  SomeMaze
//
//  Created by Hansen Qian on 7/22/13.
//  Copyright (c) 2013 Hansen Qian. All rights reserved.
//

#import "SMMainMaze.h"

@interface SMMainMaze ()

@property BOOL contentCreated;
@property (strong, nonatomic) SKSpriteNode *actor;


@end

@implementation SMMainMaze

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */

    _contentCreated = NO;
    _actor = nil;

    self.backgroundColor = [SKColor blackColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
  }
  return self;
}

- (void)didMoveToView:(SKView *)view
{
  if (![self contentCreated])
  {
    [self createSceneContents];
    self.contentCreated = YES;
  }
}

- (void)createSceneContents {
  SKAction *makeTrucks = [SKAction sequence:@[
                                              [SKAction performSelector:@selector(addTrucks) onTarget:self],
                                              [SKAction waitForDuration:0.10 withRange:0.15]]];
  [self runAction:[SKAction repeatActionForever:makeTrucks]];

  _actor = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(20, 20)];
  [_actor setName:@"actor"];
  [_actor setPosition:CGPointMake(CGRectGetMidX(self.frame), 15)];
  [self addChild:_actor];
}

- (void)addTrucks {
  NSLog(@"Making 2 Trucks!");
  SKSpriteNode *truck = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(random() % 100 + 20, 20)];
  [truck setName:@"truck"];
  CGFloat halfTruckWidth = truck.size.width / 2;
  SKAction *action;
  if (random() % 2 == 0) {
    [truck setPosition:CGPointMake(640 + halfTruckWidth, random() % (1136 - 60) + 30)];
    action = [SKAction moveToX:0.0 - halfTruckWidth - 10 duration:2 + random() % 2];
  } else {
    [truck setPosition:CGPointMake(0.0 - halfTruckWidth, random() % (1136 - 60) + 30)];
    action = [SKAction moveToX:640 + halfTruckWidth + 10 duration:2 + random() % 2];
  }
  [truck runAction:[SKAction repeatActionForever:action]];
  //    SKPhysicsBody *truckPhysicsBody = [SKPhysicsBody bodyWithRectangleOfSize:truck.size];
  //    [truckPhysicsBody setAffectedByGravity:NO];
  //    [truck setPhysicsBody:truckPhysicsBody];
  [self addChild:truck];
}

- (void)didSimulatePhysics {
  [self enumerateChildNodesWithName:@"truck" usingBlock:^(SKNode *node, BOOL *stop) {
    if ([node isKindOfClass:[SKSpriteNode class]]) {
      SKSpriteNode *spriteNode = (SKSpriteNode *) node;
      CGFloat halfTruckWidth = spriteNode.size.width / 2;
      CGFloat xPosition = spriteNode.position.x;
      if (xPosition >= 640.0 + halfTruckWidth + 10 || xPosition <= 0.0 - halfTruckWidth - 10) {
        [spriteNode removeFromParent];
        NSLog(@"Deleting node!");
      }
    }
  }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  /* Called when a touch begins */

  for (UITouch *touch in touches) {
    CGPoint location = [touch locationInNode:self];
    if ([_actor containsPoint:location]) {
      [_actor setPosition:location];
    }

  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

  for (UITouch *touch in touches) {
    CGPoint location = [touch locationInNode:self];
    CGPoint originalPosition = [_actor position];
    [_actor setPosition:CGPointMake(originalPosition.x, originalPosition.y + location.y)];
  }
}


@end
