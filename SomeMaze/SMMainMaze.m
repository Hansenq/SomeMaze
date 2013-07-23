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
@property BOOL touching;
@property (strong, nonatomic) SKSpriteNode *actor;
@property CGPoint lastTouch;


@end

@implementation SMMainMaze

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    /* Setup your scene here */

    _contentCreated = NO;
    _touching = NO;
    _actor = nil;
    _lastTouch.x = 0;
    _lastTouch.y = 0;

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
  SKPhysicsBody *actorPhysicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_actor.size];
  [actorPhysicsBody setAffectedByGravity:NO];
  [actorPhysicsBody setAllowsRotation:NO];
  [_actor setPhysicsBody:actorPhysicsBody];
  [self addChild:_actor];
}

- (void)addTrucks {
  NSLog(@"Making 2 Trucks!");
  SKSpriteNode *truck = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(random() % 100 + 20, 20)];
  [truck setName:@"truck"];
  CGFloat halfTruckWidth = truck.size.width / 2;
  SKAction *action;
//  CGFloat direction;
  if (random() % 2 == 0) {
    [truck setPosition:CGPointMake(640 + halfTruckWidth, random() % (1136 - 60) + 30)];
//    direction = M_PI;
    action = [SKAction moveToX:0.0 - halfTruckWidth - 10 duration:2 + random() % 2];
  } else {
    [truck setPosition:CGPointMake(0.0 - halfTruckWidth, random() % (1136 - 60) + 30)];
//    direction = 0;
    action = [SKAction moveToX:640 + halfTruckWidth + 10 duration:2 + random() % 2];
  }
  [truck runAction:[SKAction repeatActionForever:action]];
//  SKPhysicsBody *truckPhysicsBody = [SKPhysicsBody bodyWithRectangleOfSize:truck.size];
//  CGFloat speed = 200;
//  CGPoint velocity = CGPointMake(speed * cosf(direction), speed * sinf(direction));
//  [truckPhysicsBody applyForce:velocity];
//  [truckPhysicsBody setVelocity:velocity];
//  [truckPhysicsBody setAffectedByGravity:NO];
//  [truck setPhysicsBody:truckPhysicsBody];
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

  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  if ([_actor containsPoint:location]) {
    [_actor setPosition:location];
    _lastTouch = location;
    _touching = YES;
    SKPhysicsBody *actorPhysicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_actor.size];
    [actorPhysicsBody setAffectedByGravity:NO];
    [actorPhysicsBody setAllowsRotation:NO];
    [_actor setPhysicsBody:actorPhysicsBody];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  if (_touching) {
    CGPoint delta = CGPointMake(location.x - [self lastTouch].x, location.y - [self lastTouch].y);
    CGPoint originalPosition = [_actor position];
    [_actor setPosition:CGPointMake(originalPosition.x + delta.x, originalPosition.y + delta.y)];
    _lastTouch = location;
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  _touching = NO;
}


@end
