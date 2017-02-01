//
//  ViewController.m
//  Canvas
//
//  Created by Jennifer Beck on 2/1/17.
//  Copyright © 2017 JenniferBeck. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (weak, nonatomic) IBOutlet UIImageView *downArrayView;
@property (nonatomic, assign) CGPoint trayOriginalCenter;
@property (nonatomic, assign) CGPoint trayCenterWhenOpen;
@property (nonatomic, assign) CGPoint trayCenterWhenClose;

@property (nonatomic, strong) UIImageView *newlyCreatedFace;
@property (nonatomic, assign) CGPoint newFaceOriginalCenter;

@property (nonatomic, assign) BOOL trayOpen;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup the center of the tray when open and closed.
    CGRect frame = self.trayView.frame;
    NSInteger buttonHeight  = self.downArrayView.frame.size.height;
    self.trayCenterWhenOpen = self.trayView.center;
    self.trayCenterWhenClose = CGPointMake(self.trayView.center.x,
                                           self.trayView.center.y + frame.size.height - buttonHeight);
    
    self.trayView.center = self.trayCenterWhenOpen; // Need to make this happen .vs. layout!
    self.trayOpen = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTrayPanGesture:(UIPanGestureRecognizer *)sender {
    
    // Absolute (x,y) coordinates in parentView
    CGPoint location = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(location));
        self.trayOriginalCenter = self.trayView.center;

    } else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed at: %@", NSStringFromCGPoint(location));
        
        CGPoint translation = [sender translationInView:self.trayView];
        self.trayView.center = CGPointMake(self.trayOriginalCenter.x,
                                      self.trayOriginalCenter.y + translation.y);
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended at: %@", NSStringFromCGPoint(location));
        
        // + animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
        [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:0.2 initialSpringVelocity:0.3 options:0.5 animations:^{
            if ([sender velocityInView:self.trayView].y > 0) {
                self.trayView.center = self.trayCenterWhenClose;
                self.trayOpen = NO;
            } else {
                self.trayView.center = self.trayCenterWhenOpen;
                self.trayOpen = YES;
            };
        } completion:^(BOOL finished) {
            // Nothing to do here.
        }];
    }
    
}

// TODO - pull out and use the animation for this too
// TODO - use the center of the tray to figure out if open/close .vs. saving state.
- (IBAction)onTrayTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (self.trayOpen) {
            self.trayView.center = self.trayCenterWhenClose;
            self.trayOpen = NO;
        } else {
            self.trayView.center = self.trayCenterWhenOpen;
            self.trayOpen = YES;
        }
    }
}

#pragma mark Putting faces onto the canvas

- (IBAction)onFacePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        // Gesture recognizers know the view they are attached to
        UIImageView *imageView = (UIImageView *)sender.view;
        
        // Create a new image view that has the same image as the one currently panning
        self.newlyCreatedFace = [[UIImageView alloc] initWithImage:imageView.image];
        
        // Add the new face to the tray's parent view.
        [self.view addSubview:self.newlyCreatedFace];
        
        // Initialize the position of the new face.
        self.newlyCreatedFace.center = imageView.center;
        
        // Since the original face is in the tray, but the new face is in the
        // main view, you have to offset the coordinates
        CGPoint faceCenter = self.newlyCreatedFace.center;
        self.newlyCreatedFace.center = CGPointMake(faceCenter.x,
                                                   faceCenter.y + self.trayView.frame.origin.y);
        self.newFaceOriginalCenter = self.newlyCreatedFace.center;
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.trayView];
        self.newlyCreatedFace.center = CGPointMake(self.newFaceOriginalCenter.x + translation.x,
                                                   self.newFaceOriginalCenter.y + translation.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
    }
}


@end
