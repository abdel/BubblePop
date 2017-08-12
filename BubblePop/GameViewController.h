//
//  GameViewController.h
//  BubblePop
//
//  Created by Abdelrahman Ahmed on 4/05/2016.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreUpLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) NSString *sentBubbles;
@property (weak, nonatomic) NSString *sentName;
@property (weak, nonatomic) NSString *sentTime;

@property (strong, nonatomic) NSTimer *countDown;
@property (strong, nonatomic) NSTimer *gameTimer;

- (void)drawBubbles:(NSInteger)randomness;
- (void)updateGameTimer;
- (void)updateCountDown;
- (int)getRandomColor;

@end
