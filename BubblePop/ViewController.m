//
//  ViewController.m
//  BubblePop
//
//  Created by Abdelrahman Ahmed on 3/05/2016.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize nameInput;
@synthesize timeAndBubblesPicker;
@synthesize bubbles;
@synthesize time;

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   // Data source for time picker
   time = [[NSArray alloc] initWithObjects:@"30", @"60", @"90", @"120", nil];
   
   // Data source for bubbles picker
   bubbles = [[NSArray alloc] initWithObjects:@"10", @"15", @"20", @"25", nil];

   // Recognise background taps to dismiss the keyboard
   // for the name input text field
   UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTap:)];
   tapRecogniser.cancelsTouchesInView = NO;
   [self.view addGestureRecognizer:tapRecogniser];
   
   // Get stored player name
   NSString *playerName = [[NSUserDefaults standardUserDefaults] valueForKey:@"PlayerName"];
   
   // Update textfield with stored name
   nameInput.text = playerName;
}

- (void)viewDidAppear:(BOOL)animated
{
   // Get default time value from Settings
   NSString *defaultTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"SettingsGameTimeOption"];
   NSUInteger defaultTimeIndex = 1;
   if (defaultTime != nil)
   {
      defaultTimeIndex = [time indexOfObject:defaultTime];
   }
   
   // Select the default time value in the PickerView
   [timeAndBubblesPicker selectRow:defaultTimeIndex inComponent:0 animated:YES];
   [timeAndBubblesPicker reloadComponent:0];
   
   // Get default bubbles value from settings
   NSString *defaultBubbles = [[NSUserDefaults standardUserDefaults] valueForKey:@"SettingsGameBubblesOption"];
   NSUInteger defaultBubblesIndex = 1;
   if (defaultBubbles != nil)
   {
      defaultBubblesIndex = [bubbles indexOfObject:defaultBubbles];
   }
   
   // Select the default bubbles value in the PickerView
   [timeAndBubblesPicker selectRow:defaultBubblesIndex inComponent:1 animated:YES];
   [timeAndBubblesPicker reloadComponent:1];
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
}

// Handle segue into the game controller
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   // Get selected time
   NSInteger timeIndex = [timeAndBubblesPicker selectedRowInComponent:0];
   
   // Get selected bubble count
   NSInteger bubblesIndex = [timeAndBubblesPicker selectedRowInComponent:1];
   
   // Set default name if user didn't set one
   if ([nameInput.text  isEqual: @""]) {
      nameInput.text = @"Guest";
   }
   
   // Remember the player name using NSUSerDefault
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setValue:nameInput.text forKey:@"PlayerName"];
   [defaults synchronize];
   
   // Segue to the GameViewController
   GameViewController *destination = segue.destinationViewController;
   
   // Send data to destination
   destination.sentName = nameInput.text;
   destination.sentTime = [time objectAtIndex:timeIndex];
   destination.sentBubbles = [bubbles objectAtIndex:bubblesIndex];
}

// Method to dismiss the keyboard if the player is done
// typing their names
- (IBAction)onDismissKeyboard:(id)sender
{
   [nameInput resignFirstResponder];
}

// Dismiss keyboard if player taps outside
- (void)handleBackgroundTap:(UITapGestureRecognizer *)sender
{
   [self onDismissKeyboard:sender];
}

// Get the total number of pickers
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   return 2;
}

// Get the number of items in the picker component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   if (component == 0)
   {
      return time.count;
   }
   else
   {
      return bubbles.count;
   }
}

// Set the title for the items in each picker
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   if (component == 0)
   {
      return [NSString stringWithFormat:@"%@ seconds", [time objectAtIndex:row]];
   }
   else
   {
      return [NSString stringWithFormat:@"%@ bubbles", [bubbles objectAtIndex:row]];
   }
}

@end
