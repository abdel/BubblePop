//
//  ScoreViewController.m
//  BubblePop
//
//  Created by Abdelrahman Ahmed on 3/05/2016.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

#import "ScoreViewController.h"
#import "BubbleScore.h"

@implementation ScoreViewController

#pragma mark - Properties

@synthesize scores;
@synthesize sentName;
@synthesize sentScore;
@synthesize sortedScores;
@synthesize endGameLabel;

#pragma mark - UIViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   // Initialize table data
   scores = [[NSMutableArray alloc] init];
   sortedScores = [[NSArray alloc] init];
   
   // Save new score
   [self saveScores];
   
   // Update end game message
   endGameLabel.text = [NSString stringWithFormat:@"Congratulations, you scored %@!", sentScore];
   
   // Load data from file to populate table view
   [self loadScores];
}

#pragma mark - File I/O

- (NSString *)getHighScoresFile
{
   // Find path to highscores
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *documentsDirectory = [paths objectAtIndex:0];
   
   // Get the highscores file
   return [documentsDirectory stringByAppendingPathComponent:@"highscores.csv"];
}

- (NSNumber *)loadScores
{
   NSNumber *maxHighScore = 0;
   
   // Get highscores file
   NSString *highScoresFile = [self getHighScoresFile];
   NSFileManager *fileManager = [NSFileManager defaultManager];
   
   // Check if highscores already exist
   if ([fileManager fileExistsAtPath:highScoresFile])
   {
      // Read all highscores
      NSError *error = nil;
      NSString *highScores = [[NSString alloc]
                              initWithContentsOfFile:highScoresFile
                              encoding:NSUTF8StringEncoding error:&error];
      
      // Proceed if no errors returned
      if (error == nil)
      {
         // Split each score from file using \n delimiter
         NSArray *localScores = [highScores componentsSeparatedByCharactersInSet:
                                 [NSCharacterSet newlineCharacterSet]];
         
         // Get individual score data
         for (int i = 0; i < [localScores count] - 1; i++)
         {
            NSString *score = [localScores objectAtIndex:i];
            
            // Separate score data using , delimiter
            NSArray *scoreData = [score componentsSeparatedByString:@","];
            
            // Store the highest value found in the scoreData
            NSNumber *maxScore = [scoreData valueForKeyPath:@"@max.intValue"];
            if (maxScore > maxHighScore)
            {
               maxHighScore = maxScore;
            }

            // Store data inside BubbleScore object
            BubbleScore *bubbleScore = [[BubbleScore alloc] init];
            bubbleScore.name = [NSString stringWithFormat:@"%@", [scoreData objectAtIndex:0]];
            bubbleScore.score = [NSString stringWithFormat:@"%@", [scoreData objectAtIndex:1]];
            
            [self.scores addObject:bubbleScore];
         }
         
         // Sort the highscores descendingly using the int value of the score
         self.sortedScores = [self.scores sortedArrayUsingComparator:
                            ^NSComparisonResult(id hs1, id hs2)
         {
            if ([[hs1 score] intValue] < [[hs2 score] intValue])
            {
               return NSOrderedDescending;
            }
            else
            {
               return NSOrderedAscending;
            }
         }];
      }
   }
   
   return maxHighScore;
}

- (void)saveScores
{
   // Set highscore (FORMAT: name, score)
   NSString *newScore = [NSString stringWithFormat:@"%@,%@\n", sentName, sentScore];
   
   // Get highscores file
   NSString *highScoresFile = [self getHighScoresFile];
   NSFileManager *fileManager = [NSFileManager defaultManager];
   
   // Check if highscores already exist
   if(![fileManager fileExistsAtPath:highScoresFile])
   {
      // Create new file with new score
      [newScore writeToFile:highScoresFile atomically:TRUE
                   encoding:NSUTF8StringEncoding error:NULL];
   }
   else
   {
      // Save new score to the end of the file
      NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:highScoresFile];
      [fileHandle seekToEndOfFile];
      [fileHandle writeData:[newScore dataUsingEncoding:NSUTF8StringEncoding]];
   }
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [sortedScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   BubbleScore *bubbleScore = [sortedScores objectAtIndex:indexPath.row];
   
   static NSString *cellID = @"ScoreCell";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   
   if (cell == nil)
   {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellID];
   }
   
   // Format cell with scores
   cell.textLabel.text = [NSString stringWithFormat:@"%@ scored: %@",
                          [bubbleScore name],
                          [bubbleScore score]];
   
   return cell;
}

@end
