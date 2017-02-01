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
//        if ([sender velocityInView:self.trayView].y > 0) {
//            self.trayView.center = self.trayCenterWhenClose;
//        } else {
//            self.trayView.center = self.trayCenterWhenOpen;
//        }
 
        [UIView animateWithDuration:0.4 animations:^{
            if ([sender velocityInView:self.trayView].y > 0) {
                self.trayView.center = self.trayCenterWhenClose;
            } else {
                self.trayView.center = self.trayCenterWhenOpen;
            }
        }];
    }
    
}


@end
