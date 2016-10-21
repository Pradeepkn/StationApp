//
//  RemarksStatusUpdateViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/18/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "RemarksStatusUpdateViewController.h"
#import "UIColor+AppColor.h"
#import "AppUtilityClass.h"

@interface RemarksStatusUpdateViewController ()

@property (weak, nonatomic) IBOutlet UIView *remarksContainerView;
@property (weak, nonatomic) IBOutlet UIView *statusContainerView;
@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;
@property (weak, nonatomic) IBOutlet UITextField *remarksTextField;

@property (weak, nonatomic) IBOutlet UIButton *toStartButton;
@property (weak, nonatomic) IBOutlet UIButton *onGoingButton;
@property (weak, nonatomic) IBOutlet UIButton *delayedButton;
@property (weak, nonatomic) IBOutlet UIButton *completedButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *navigationTopView;
@property (weak, nonatomic) IBOutlet UIView *remarksCompletedContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *completedViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UISwitch *remarksSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarksContainerHeightConstraint;

@end

@implementation RemarksStatusUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateViewElements];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isRemarksStatusUpdate) {
        NSInteger remarksContainerViewHeight = [AppUtilityClass sizeOfText:self.remarksTextView.text widthOfTextView:self.remarksTextView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:18.0f]].height +86;
        if (remarksContainerViewHeight > self.view.frame.size.height - 150) {
            remarksContainerViewHeight = self.view.frame.size.height - 150;
        }else if (remarksContainerViewHeight < 140) {
            remarksContainerViewHeight = 140.0f;
        }
        self.remarksContainerHeightConstraint.constant = remarksContainerViewHeight;
    }
}

- (void)updateViewElements {
    if (self.isRemarksUpdate) {
        self.remarksContainerView.hidden = NO;
        self.statusContainerView.hidden = YES;
        if (self.isRemarksStatusUpdate) {
            self.remarksCompletedContainerView.hidden = NO;
            self.completedViewHeightConstraint.constant = 40.0f;
            [self.remarksSwitch setOn:self.isRemarksCompleted];
            self.remarksTextView.text = self.remarksMessage;
            self.remarksTextView.editable = NO;
            self.remarksTextField.text = @" ";
            self.remarksTextView.scrollsToTop = YES;
        }else {
            self.completedViewHeightConstraint.constant = 0.0f;
            self.remarksCompletedContainerView.hidden = YES;
            [self.remarksTextView becomeFirstResponder];
        }
    }else {
        self.remarksContainerView.hidden = YES;
        self.statusContainerView.hidden = NO;
    }
    self.titleLabel.text = self.selectedStation.stationName;
    switch (self.statusCode) {
        case kTaskToStart:
            [self.toStartButton setBackgroundColor:[UIColor whiteColor]];
            self.toStartButton.layer.borderWidth = 1.0f;
            self.toStartButton.layer.borderColor = [UIColor appRedColor].CGColor;
            break;
        case kTaskOnTrack:
            [self.onGoingButton setBackgroundColor:[UIColor whiteColor]];
            self.onGoingButton.layer.borderWidth = 1.0f;
            self.onGoingButton.layer.borderColor = [UIColor appRedColor].CGColor;
            break;
        case kTaskDelayed:
            [self.delayedButton setBackgroundColor:[UIColor whiteColor]];
            self.delayedButton.layer.borderWidth = 1.0f;
            self.delayedButton.layer.borderColor = [UIColor appRedColor].CGColor;
            break;
        case kTaskCompleted:
            [self.completedButton setBackgroundColor:[UIColor whiteColor]];
            self.completedButton.layer.borderWidth = 1.0f;
            self.completedButton.layer.borderColor = [UIColor appRedColor].CGColor;
            break;
            
        default:
            break;
    }
}

- (IBAction)backButtonClicked:(id)sender {
    [self.view endEditing:YES];
    [self removeViewFromSuperView];
}

- (void)removeViewFromSuperView {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (IBAction)remarksStatusUpdated:(UISwitch *)sender {

}

- (IBAction)submitRemarksButtonClicked:(id)sender {
    if (self.isRemarksStatusUpdate) {
        if (self.remarksSwitch.isOn) {
            [self.delegate updateRemarksStatus:kCompleted];
        }else {
            [self.delegate updateRemarksStatus:kNotCompleted];
        }
        [self removeViewFromSuperView];
        return;
    }else {
        if (self.remarksTextView.text.length) {
            [self.delegate updateRemarks:self.remarksTextView.text];
            [self removeViewFromSuperView];
        }else {
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please enter remarks message", nil)];
        }
    }
}

- (IBAction)statusUpdateButtonClicked:(UIButton *)sender {
    [self updateButtonBorderWidth];
    [self.toStartButton setBackgroundColor:[UIColor backgroundGrayColor]];
    [self.onGoingButton setBackgroundColor:[UIColor backgroundGrayColor]];
    [self.delayedButton setBackgroundColor:[UIColor backgroundGrayColor]];
    [self.completedButton setBackgroundColor:[UIColor backgroundGrayColor]];
    [sender setBackgroundColor:[UIColor whiteColor]];
    sender.layer.borderWidth = 1.0f;
    sender.layer.borderColor = [UIColor appRedColor].CGColor;
    [self.delegate updateStatus:sender.tag];
    [self removeViewFromSuperView];
}

- (void)updateButtonBorderWidth {
    self.toStartButton.layer.borderWidth = self.onGoingButton.layer.borderWidth = self.delayedButton.layer.borderWidth = self.completedButton.layer.borderWidth = 0.0f;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.remarksTextField.text = @" ";
    }else {
        self.remarksTextField.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
