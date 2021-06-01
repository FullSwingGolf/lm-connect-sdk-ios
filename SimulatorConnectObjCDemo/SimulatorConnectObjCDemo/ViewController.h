//
//  ViewController.h
//  SimulatorConnectObjCDemo
//
//  Created by Chad Godsey on 5/18/21.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

-(IBAction) clubSelectAction;

@property IBOutlet UILabel *deviceLabel;
@property IBOutlet UILabel *statusLabel;
@property IBOutlet UIActivityIndicatorView *statusActivity;
@property IBOutlet UIButton *updateButton;
@property IBOutlet UIButton *connectButton;
@property IBOutlet UIButton *disconnectButton;

@property IBOutlet UILabel *carryLabel;
@property IBOutlet UILabel *totalLabel;
@property IBOutlet UILabel *launchLabel;
@property IBOutlet UILabel *backspinLabel;
@property IBOutlet UILabel *attackLabel;
@property IBOutlet UILabel *axisLabel;

@property IBOutlet UISegmentedControl *clubSelect;

@end

