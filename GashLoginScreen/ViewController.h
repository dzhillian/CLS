//
//  ViewController.h
//  GashLoginScreen
//
//  Created by dzhillian on 8/18/15.
//  Copyright (c) 2015 flabs. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)signinClicked:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;

@end
