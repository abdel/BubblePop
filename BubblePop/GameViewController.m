//
//  GameViewController.m
//  BubblePop
//
//  Created by Abdelrahman Ahmed on 4/05/2016.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BubbleView.h"
#import "BubbleScore.h"
#import "GameViewController.h"
#import "ScoreViewController.h"

@interface GameViewController ()
{
   // Current Score
   int currentScore;
   
   // Player name
   NSString * playerName;
   
   // Total number of bubbles
   int numberOfBubbles;
   
   // Number of bubbles on screen
   int numberOfBubblesOnScreen;
   
   // Bubbles
   NSMutableArray *bubbles;
   
   // Bubbles
   NSMutableArray *bubblesOnScreen;
   
   // Valid bubble colors
   NSMutableArray *bubbleColors;
   
   // Color weights for each color
   NSMutableArray *colorWeights;
   
   // Recently popped bubble
   BubbleView *poppedBubble;
   
   // Custom pink color
   UIColor *pinkColor;
   
   int x, y, offset, minX, maxX, minY, maxY;
   
   BOOL newRow;
   
   int speedTime;
   int originalTime;
   double speed;
}
@end

@implementation GameViewController

#pragma-mark Properties
@synthesize timerLabel;
@synthesize scoreLabel;
@synthesize highScoreLabel;
@synthesize countDownLabel;
@synthesize sentName;
@synthesize sentTime;
@synthesize sentBubbles;
@synthesize countDown;
@synthesize gameTimer;
@synthesize scoreUpLabel;

#pragma-mark UIViewController
- (void)viewDidLoad
{
   [super viewDidLoad];
   
   // Set player name
   playerName = sentName;
   
   // Set the starting values
   // for the game timer (user input)
   gameTimer = nil;
   currentScore = 0;
   self.timerLabel.text = sentTime;
   self.timerLabel.tag = [sentTime intValue];
   
   // Set the starting values for game countdown
   countDown = nil;
   self.countDownLabel.text = @"3";
   self.countDownLabel.tag = 3;
   [countDownLabel setHidden:YES];
   
   // Create an array for bubble shapes
   bubbles = [[NSMutableArray alloc] init];
   
   // Load high scores
   ScoreViewController *scoreView = [[ScoreViewController alloc]init];
   NSNumber *highScore = [scoreView loadScores];
   if (highScore != nil)
   {
      // Set highscore label
      highScoreLabel.tag = [highScore intValue];
      highScoreLabel.text = [NSString stringWithFormat:@"%@", highScore];
   }
   else
   {
      // Set highscore label
      highScoreLabel.tag = 0;
      highScoreLabel.text = @"0";
   }
   
   // Create an array for bubble shapes
   bubblesOnScreen = [[NSMutableArray alloc] init];
   
   // Get integer value of bubble count
   numberOfBubbles = [sentBubbles intValue];
   
   // Create pink color for bubbles (Unavailable in UIColor)
   pinkColor = [UIColor colorWithRed:(255.0/255.0) green:(192.0/255.0) blue:(203.0/255.0) alpha:(255.0/255.0)];
   
   // Store all colors into an array
   bubbleColors = [[NSMutableArray alloc] initWithCapacity:5];
   [bubbleColors addObject:[UIColor redColor]];
   [bubbleColors addObject:pinkColor];
   [bubbleColors addObject:[UIColor greenColor]];
   [bubbleColors addObject:[UIColor blueColor]];
   [bubbleColors addObject:[UIColor blackColor]];
   
   // Store color weights into an array
   colorWeights = [[NSMutableArray alloc] initWithCapacity:5];
   [colorWeights addObject:[NSNumber numberWithDouble:0.40]];
   [colorWeights addObject:[NSNumber numberWithDouble:0.30]];
   [colorWeights addObject:[NSNumber numberWithDouble:0.15]];
   [colorWeights addObject:[NSNumber numberWithDouble:0.10]];
   [colorWeights addObject:[NSNumber numberWithDouble:0.05]];
   
   // Set starting speed
   speed = 10;
   
   // Hide scores earned label
   [scoreUpLabel setHidden:YES];
   
   // Coordinates values
   offset = 115;
   newRow = false;
   
   [self setDefaultCoordinates];
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL) animated
{
   // Keep track of original time
   originalTime = (int)self.timerLabel.tag;
   
   // Set speedTime
   speedTime = originalTime;
   
   // Set up the timer for countdown
   countDown = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountDown) userInfo:nil repeats:YES];
   
   // Set up the timer for the game
   gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateGameTimer) userInfo:nil repeats:YES];
}

// Handle segue into the score controller
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   // Segue to the ScoreViewController
   ScoreViewController *destination = segue.destinationViewController;
   
   // Send data to destination
   destination.sentName = playerName;
   destination.sentScore = scoreLabel.text;
}

#pragma mark - Timers

- (void)updateCountDown
{
   // Get time left on countdown
   int countLeft = (int)self.countDownLabel.tag;
   
   // Avoid reducing a second while
   // label is still hidden
   if (!countDownLabel.hidden) {
      countLeft -= 1;
   }
   
   // Stop the countdown and hide the
   // coutndown label when the time hits zero.
   if (countLeft <= 0)
   {
      [countDown invalidate];
      countDown = nil;
      
      [countDownLabel setHidden:YES];
   }
   else
   {
      // Updated countdown label with the new time
      countDownLabel.text = [NSString stringWithFormat: @"%d", countLeft];
      countDownLabel.tag = countLeft;
      
      // Flash the count down label
      [countDownLabel setHidden:(!countDownLabel.hidden)];
   }
}

- (void)updateGameTimer
{
   // Get time left on the game timer
   int timeLeft = (int)self.timerLabel.tag - 1;
   
   [scoreUpLabel setHidden:YES];
   
   // Don't start game timer till
   // the count down has ended!
   if (countDown == nil)
   {
      // Stop timer and show the scoreboard
      // when the time hits zero.
      if (timeLeft <= 0)
      {
         [gameTimer invalidate];
         gameTimer = nil;
         
         [bubbles removeAllObjects];
         [bubblesOnScreen removeAllObjects];
         [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
         
         [self performSegueWithIdentifier:@"ScoreView" sender:self];
      }
      else
      {
         // Update timer label with the new time
         self.timerLabel.text = [NSString stringWithFormat: @"%d", timeLeft];
         self.timerLabel.tag = timeLeft;
      }
   }
   
   if (countDownLabel.tag <= 1)
   {
      int newSpeedTime = speedTime - (originalTime / 6); // Scaled to orginal time
      
      if (timeLeft == newSpeedTime)
      {
         speedTime = newSpeedTime;
         speed -= 0.6;
      }
      
      // Make sure we don't pass the bubble limit
      if ([bubblesOnScreen count] > numberOfBubbles)
      {
         // Get a random bubble index
         int randomBubbleIndex = arc4random() % ([bubblesOnScreen count] - 1);
         
         // Remove some random bubbles
         for (int i = randomBubbleIndex; i < ([bubblesOnScreen count] - 1); i++)
         {
            [bubblesOnScreen removeObjectAtIndex:i];
         }
      }
      else
      {
         // Set the randomness element
         NSInteger randomness = arc4random() % 3;
         
         // Draw bubbles
         [self drawBubbles:randomness];
      }
   }
}

#pragma mark - Drawing Bubbles

- (int)getRandomColor
{
   double sumOfWeights = 0;
   
   // Get the sum of all color weights
   for(int i = 0; i < [bubbleColors count]; i++)
   {
      double weight = [[colorWeights objectAtIndex:i] doubleValue];
      sumOfWeights += weight;
   }
   
   // Get generate a random weight within range
   double random = ((double)rand() / (double)RAND_MAX);
   double randomWeight = fmod(random, sumOfWeights);
   
   // Check random weight against original weight
   // and return index to get the color
   for(int i = 0; i < [bubbleColors count]; i++)
   {
      double weight = [[colorWeights objectAtIndex:i] doubleValue];
      
      if (randomWeight < weight) {
         return i;
      } else {
         randomWeight -= weight;
      }
   }
   
   return 0;
}

- (void)setDefaultCoordinates
{
   // Get max X-coordinate based on width
   maxX = [[UIScreen mainScreen] bounds].size.width - offset;
   
   // Get max Y-coordinte based on height
   maxY = [[UIScreen mainScreen] bounds].size.height + offset;
   
   // Calculate the minimum X
   minX = 20;
   
   // Set coordinates
   x = minX;
   y = maxY;
}

- (void)drawBubbles:(NSInteger)randomness
{
   // Get total count of bubbles
   NSUInteger index = [bubbles count];
   
   // Get max bubbles per row
   int numberOfDrawnBubbles = (maxX + offset) / offset;
   
   // Draw bubbles in a row
   for (int i = 0; i < numberOfDrawnBubbles; i++)
   {
      BOOL randomCondition = false;
      
      // Odd condition
      if (randomness == 0)
      {
         randomCondition = (i % 2 == 1);
      }
      // Even condition
      else if (randomness == 1)
      {
         randomCondition = (i % 2 == 0);
      }
      // Random condition
      else
      {
         int randomBubble = arc4random() % numberOfDrawnBubbles;
         randomCondition = (i != randomBubble);
      }
      
      // Randomly skip creating a bubble
      // to have different locations in the row
      if (randomCondition)
      {
         // Get random colour based on weight
         int randomColor = [self getRandomColor];
         
         // Create bubble
         BubbleView *bubble = [[BubbleView alloc]init];
         bubble.frame = CGRectMake(x, y, 100, 100);
         bubble.userInteractionEnabled = YES;
         bubble.layer.cornerRadius = 50;
         bubble.tag = randomColor; // Tag with color index for easy comparison

         // Fill with random color
         bubble.backgroundColor = [bubbleColors objectAtIndex:randomColor];
         
         // Get last bubble index
         NSInteger lastIndex = [bubblesOnScreen count] > 0 ? [bubblesOnScreen count] - 1 : 0;
         
         // Add bubble to view
         [self.view insertSubview:bubble atIndex:0];
         
         // Add bubble to all bubbles
         [bubbles insertObject:bubble atIndex:index++];
         
         // Add bubble to on screen bubbles
         [bubblesOnScreen insertObject:bubble atIndex:lastIndex];
         
         // Animate bubble with defined speed
         [BubbleView animateWithDuration:speed
                                   delay:0
                                 options: (UIViewAnimationOptionAllowUserInteraction |
                                           UIViewAnimationOptionAllowAnimatedContent)
                              animations:^
                              {
                                 bubble.frame = CGRectMake(x, 0 - (offset * 2), 100, 100);
                              }
                              completion:^(BOOL finished)
                              {
                                 if (finished)
                                 {
                                    [bubble removeFromSuperview];
                                 }
                              }];
      }
      
      
      // Ensure that the X-coordinate doesn't surpass the view bounds
      if ((x + offset) <= maxX)
      {
         // New X position for next bubble
         x += offset;
      }
      else
      {
         // Reached max X, start new row
         x = minX;
      }
   }
}


#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // Get the point user touched
   UITouch *touch = [touches anyObject];
   CGPoint touchPoint = [touch locationInView:self.view];
   
   // Check all bubbles we created
   for (int i = 0; i < [bubbles count]; i++)
   {
      BubbleView *bubble = [bubbles objectAtIndex:i];
      
      // Check if player touched a bubble
      if ([[bubble layer].presentationLayer hitTest:touchPoint])
      {
         int calculatedScore = 0;
         
         // Calculate score for RED bubbles
         if (bubble.tag == 0)
         {
            calculatedScore = 1;
         }
         
         // Calculate score for PINK bubbles
         else if (bubble.tag == 1)
         {
            calculatedScore = 2;
         }
         
         // Calculate score for GREEN bubbles
         else if (bubble.tag == 2)
         {
            calculatedScore = 5;
         }
         
         // Calculate score for BLUE bubbles
         else if (bubble.tag == 3)
         {
            calculatedScore = 8;
         }
         
         // Calculate score for BLACK bubbles
         else if (bubble.tag == 4)
         {
            calculatedScore = 10;
         }
         
         // Check if the color of the previously popped bubble
         // matches the current one, then multiply the score
         if (poppedBubble.tag == bubble.tag)
         {
            calculatedScore = ceil(calculatedScore * 1.5);
         }
         
         // Valid colored bubbles only
         if (calculatedScore != 0)
         {
            // Update score label with the new score
            currentScore += calculatedScore;
            
            scoreLabel.text = [NSString stringWithFormat: @"%d", currentScore];
            scoreLabel.tag = currentScore;
            
            // Update highScore label if current passed it
            if (currentScore > highScoreLabel.tag)
            {
               highScoreLabel.text = scoreLabel.text;
               highScoreLabel.tag = scoreLabel.tag;
            }
            
            scoreUpLabel.text = [NSString stringWithFormat: @"+%d", calculatedScore];
            scoreUpLabel.tag = calculatedScore;
            
            [scoreUpLabel setHidden:NO];
            
            // Set this bubble as the popped bubble
            poppedBubble = bubble;
            
            // Remove bubble from the view and list
            [bubbles removeObjectAtIndex:i];
            [bubble removeFromSuperview];
         }
      }
   }
}

@end
