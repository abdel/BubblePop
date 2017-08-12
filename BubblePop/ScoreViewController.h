//
//  ScoreViewController.h
//  BubblePop
//
//  Created by Abdelrahman Ahmed on 3/05/2016.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *endGameLabel;

@property (strong, nonatomic) NSMutableArray *scores;
@property (strong, nonatomic) NSArray *sortedScores;

@property (weak, nonatomic) NSString *sentScore;
@property (weak, nonatomic) NSString *sentName;

- (NSString *)getHighScoresFile;
- (NSNumber *)loadScores;
- (void)saveScores;

@end
