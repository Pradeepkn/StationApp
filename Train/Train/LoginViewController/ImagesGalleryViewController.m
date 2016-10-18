//
//  ImagesGalleryViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/18/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "ImagesGalleryViewController.h"
#import "ImagesGalleryView.h"
#import "DRPageScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImagesGalleryViewController ()

@property (nonatomic, strong) DRPageScrollView *pageScrollView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageNameLabel;

@end

@implementation ImagesGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Images";
    [self updateNextButtonTitle];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageScrollView = [DRPageScrollView new];

    self.pageScrollView.pageReuseEnabled = YES;
    [self.view addSubview:self.pageScrollView];
    applyConstraints(self.pageScrollView);
    
    // Note: you can either take this nib approach or directly instantiate your UI elements programatically and add them to pageView.
    
    for (int index = 0; index < self.galleryInfoArray.count; index++) {
        StationGalleryInfo *stationGalleryInfo = (StationGalleryInfo *)[self.galleryInfoArray objectAtIndex:index];
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"ImagesGalleryView" owner:self options:nil];
        ImagesGalleryView *view = (ImagesGalleryView *) [nibViews firstObject];
        __weak ImagesGalleryViewController *weakSelf = self;
        [self.pageScrollView addPageWithHandler:^(UIView *pageView) {
            [weakSelf updateNextButtonTitle];
            weakSelf.stationNameLabel.text = stationGalleryInfo.stationName;
            weakSelf.imageNameLabel.text = stationGalleryInfo.imageName;
            [view.imageView  sd_setImageWithURL:[NSURL URLWithString:stationGalleryInfo.imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [view.imageView setImage:image];
            }];
            [pageView addSubview:view];
            applyConstraints(view);
        }];
    }
    [self.view bringSubviewToFront:self.closeButton];
    [self.view bringSubviewToFront:self.nextButton];
    [self.view bringSubviewToFront:self.previousButton];
    [self.view bringSubviewToFront:self.stationNameLabel];
    [self.view bringSubviewToFront:self.imageNameLabel];
}

- (IBAction)closeButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (IBAction)previousButtonClicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.pageScrollView.currentPage == 0) {
            return;
        }
        self.pageScrollView.currentPage = self.pageScrollView.currentPage - 1;
    } completion:^(BOOL finished) {
        [self updateNextButtonTitle];
    }];
}

- (IBAction)nextButtonClicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        if (self.pageScrollView.currentPage == self.galleryInfoArray.count - 1) {
            return;
        }
        self.pageScrollView.currentPage = self.pageScrollView.currentPage + 1;
    } completion:^(BOOL finished) {
        [self updateNextButtonTitle];
    }];
}

- (void)updateNextButtonTitle {
    [self.nextButton setTitle:[NSString stringWithFormat:@"%ld from %lu", (long)self.pageScrollView.currentPage, (unsigned long)self.galleryInfoArray.count] forState:UIControlStateNormal];
}

void applyConstraints(UIView *view) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *attributeArray = @[@(NSLayoutAttributeTop), @(NSLayoutAttributeLeft), @(NSLayoutAttributeBottom), @(NSLayoutAttributeRight)];
    
    for (NSNumber *attributeNumber in attributeArray) {
        NSLayoutAttribute attribute = (NSLayoutAttribute)[attributeNumber integerValue];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:attribute multiplier:1 constant:0];
        
        [view.superview addConstraint:constraint];
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
