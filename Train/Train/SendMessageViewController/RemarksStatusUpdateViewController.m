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

@interface RemarksStatusUpdateViewController () {
    NSInteger selectedStatus;
}

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editStatusHorizontalConstraints;

@end

@implementation RemarksStatusUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateViewElements];
    self.editStatusHorizontalConstraints.constant = -70;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)updateViewElements {
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

- (IBAction)submitRemarksButtonClicked:(id)sender {
    [self.delegate updateStatus:self.statusCode withRemarksMessage:self.remarksTextView.text];
    [self removeViewFromSuperView];
}

- (IBAction)statusUpdateButtonClicked:(UIButton *)sender {
    self.editStatusHorizontalConstraints.constant = -70;
    [self updateButtonBorderWidth];
    [self.toStartButton setBackgroundColor:[UIColor backgroundGrayColor]];
    [self.onGoingButton setBackgroundColor:[UIColor backgroundGrayColor]];
    [self.delayedButton setBackgroundColor:[UIColor backgroundGrayColor]];
    [self.completedButton setBackgroundColor:[UIColor backgroundGrayColor]];
    [sender setBackgroundColor:[UIColor whiteColor]];
    sender.layer.borderWidth = 1.0f;
    sender.layer.borderColor = [UIColor appRedColor].CGColor;
    self.statusCode = sender.tag;
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:1.0 animations:^{
        self.editStatusHorizontalConstraints.constant = -160;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.editStatusHorizontalConstraints.constant = -70;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.editStatusHorizontalConstraints.constant = -70;
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
