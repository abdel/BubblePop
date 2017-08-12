//
//  BubbleScore.m
//  BubblePop
//
//  Created by Abdelrahman Ahmed on 10/05/2016.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

#import "BubbleScore.h"

@implementation BubbleScore

#pragma mark - properties
@synthesize name;
@synthesize score;

-(id) init
{
   if (self = [super init])
   {
      name = nil;
      score = nil;
   }
   
   return self;
}


@end
