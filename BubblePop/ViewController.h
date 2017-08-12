//
//  ViewController.h
//  BubblePop
//
//  Created by Abdelrahman Ahmed on 3/05/2016.
//  Copyright © 2016 Abdelrahman Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UIPickerView *timeAndBubblesPicker;

@property (strong, nonatomic) NSArray *time;
@property (strong, nonatomic) NSArray *bubbles;

- (IBAction)onDismissKeyboard:(id)sender;

- (void)handleBackgroundTap: (UITapGestureRecognizer*)sender;

@end
