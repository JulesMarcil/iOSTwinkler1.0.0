//
//  FeedbackViewController.m
//  TabBarSlider
//
//  Created by Arnaud Drizard on 03/09/13.
//  Copyright (c) 2013 Arnaud Drizard. All rights reserved.
//

#import "FeedbackViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AuthAPIClient.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

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
    [super viewDidLoad];
    
    CGRect frame= [self.actionBarContainer frame];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [self.actionBarContainer setFrame:CGRectMake(frame.origin.x,
                                                 screenRect.size.height-frame.size.height-40,
                                                 frame.size.width,
                                                 frame.size.height)];
    
    self.nextButton.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.nextButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.nextButton.layer.borderWidth = 1.0f;
    
    self.cancelButton.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.cancelButton.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.cancelButton.layer.borderWidth = 1.0f;
    
    self.feedbackTextView.backgroundColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.8];
    self.feedbackTextView.layer.borderColor = [UIColor colorWithRed:(205/255.0) green:(205/255.0) blue:(205/255.0) alpha:1].CGColor;
    self.feedbackTextView.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"Type in your feedbacks here!"]){
        textView.text=@"";
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)send:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    NSString *feedbackType=[[NSString alloc] init];
    
    switch (self.feedbackSegmentedControl.selectedSegmentIndex) {
        case 1:
            feedbackType=@"Bug";
            break;
        case 2:
            feedbackType=@"Idea";
            break;
        case 3:
            feedbackType=@"Suggestion";
            break;
    }
    
    NSArray *keys = @[@"type", @"text", @"group_id"];
    NSArray *objects = @[feedbackType, self.feedbackTextView.text, [[NSUserDefaults standardUserDefaults] objectForKey:@"currentGroupId"]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects
                                                             forKeys:keys];
    
    [[AuthAPIClient sharedClient] postPath:@"api/feedback"
                                parameters:parameters
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSError *error = nil;
                                       NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                       NSLog(@"%@", response);
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"error: %@", error);
                                   }];
}
@end
