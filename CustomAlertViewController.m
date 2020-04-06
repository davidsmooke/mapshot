//
//  CustomAlertViewController.m
//  MapShot
//
//  Created by Innoppl Technologies on 03/04/14.
//  Copyright (c) 2014 Innoppl Technologies. All rights reserved.
//

#import "CustomAlertViewController.h"

@interface CustomAlertViewController ()

@end

@implementation CustomAlertViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    newuserTextField= [[UITextField alloc] initWithFrame:CGRectMake(30, 70, 240, 40)];
    newuserTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    newuserTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    newuserTextField.spellCheckingType=UITextSpellCheckingTypeNo;
    newuserTextField.delegate = self;
    newuserTextField.backgroundColor=[UIColor orangeColor];
    newuserTextField.textColor=[UIColor whiteColor];
    [contentView addSubview:newuserTextField];
    
    checkMarkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    checkMarkButton.frame=CGRectMake(30, 125, 25, 25);
    checkMarkButton.tag=555;
    [checkMarkButton setImage:[UIImage imageNamed:@"checkUnselected.png"] forState:UIControlStateNormal];
    [checkMarkButton addTarget:self action:@selector(checkMarkActionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:checkMarkButton];
    
    
    agreeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    agreeButton.frame=CGRectMake(70, 115, 220, 25);
    [agreeButton addTarget:self action:@selector(termsAndCondition:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:agreeButton];
    
    agreeLabel=[[UILabel alloc] initWithFrame:CGRectMake(70, 120, 220, 25)];
    agreeLabel.text=@"I agree to Terms and Conditions";
    agreeLabel.backgroundColor=[UIColor clearColor];
    agreeLabel.textColor=[UIColor whiteColor];
    agreeLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    
    [contentView addSubview:agreeLabel];
    
    linkLabel=[[UILabel alloc] initWithFrame:CGRectMake(70, 145, 200, 2)];
    linkLabel.backgroundColor=[UIColor whiteColor];
    
    [contentView addSubview:linkLabel];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void) viewWillAppear:(BOOL)animated{
    [newuserTextField becomeFirstResponder];
    [super viewWillAppear:YES];
}

-(void) checkMarkActionMethod:(UIButton*)sender{
  
    if (sender.tag==555){
      
        checkMarkButton.tag=666;
        [checkMarkButton setImage:[UIImage imageNamed:@"checkSelected.png"] forState:UIControlStateNormal];
    }
    else if (sender.tag==666){
       
        checkMarkButton.tag=555;
        [checkMarkButton setImage:[UIImage imageNamed:@"checkUnselected.png"] forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)termsAndCondition:(UIButton*)sender{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    TermsAndConditonsViewController *termsObject =[storyBoard  instantiateViewControllerWithIdentifier:@"termAndConditionId"];
    [self.navigationController pushViewController:termsObject animated:YES];
}


-(IBAction) okAction:(UIButton*) sender{
    

    if([newuserTextField.text length] == 0)  {
   
    UIAlertView *fillNameAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please Choose Your New Name ." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
       [fillNameAlert show];
    }
    else {
                
    if (checkMarkButton.tag==666){
        
      
        [newuserTextField resignFirstResponder];
        id<CustomAlertViewControllerDelegate> strongDelegate = self.delegate;
                    
                    // Our delegate method is optional, so we should
                    // check that the delegate implements it
        if ([strongDelegate respondsToSelector:@selector(customalertOK:button:textFieldValue:)]) {
        [strongDelegate customalertOK:self button:sender textFieldValue:newuserTextField.text];
        }
    }
    else if (checkMarkButton.tag==555){
                    
    UIAlertView *agreeTermsAndCondition=[[UIAlertView alloc] initWithTitle:@"Agree" message:@"Agree to the terms and condition of mapshot" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    agreeTermsAndCondition.tag=101;
    [agreeTermsAndCondition show];
    }
    }
    
}
-(IBAction) cancelAction:(UIButton*) sender{
    
  
    [newuserTextField resignFirstResponder];
    id<CustomAlertViewControllerDelegate> strongDelegate = self.delegate;
    // Our delegate method is optional, so we should
    // check that the delegate implements it
    if ([strongDelegate respondsToSelector:@selector(customalertCancel:button:)]) {
        [strongDelegate customalertCancel:self button:sender];
    }
   
}

#pragma mark - Keyboard Notification Methods

- (void)keyboardWasShown:(NSNotification *)notification
{
}


- (void) keyboardWillHide:(NSNotification *)notification {
}

@end
