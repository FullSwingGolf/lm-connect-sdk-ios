//
//  ViewController.h
//  SimulatorConnectObjCDemo
//
//  Created by Chad Godsey on 5/18/21.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

-(IBAction) clubSelectAction;
-(IBAction) distanceAction;
-(IBAction) normalizedAction;
-(IBAction) shortShotAction;

@property IBOutlet UILabel *deviceLabel;
@property IBOutlet UILabel *statusLabel;
@property IBOutlet UILabel *clubSelectLabel;
@property IBOutlet UIActivityIndicatorView *statusActivity;
@property IBOutlet UIButton *connectButton;
@property IBOutlet UIButton *disconnectButton;


@property IBOutlet UILabel *carryLabel;
@property IBOutlet UILabel *totalLabel;

@property IBOutlet UILabel *spinRateLabel;
@property IBOutlet UILabel *spinAxisLabel;

@property IBOutlet UILabel *ballSpeedLabel;
@property IBOutlet UILabel *clubSpeedLabel;

@property IBOutlet UILabel *smashLabel;
@property IBOutlet UILabel *clubPathLabel;

@property IBOutlet UILabel *faceAngleLabel;
@property IBOutlet UILabel *faceToPathLabel;

@property IBOutlet UILabel *attackLabel;
@property IBOutlet UILabel *apexLabel;

@property IBOutlet UILabel *launchLabel;
@property IBOutlet UILabel *hLaunchLabel;

@property IBOutlet UILabel *sideCarryLabel;
@property IBOutlet UILabel *sideTotalLabel;

@property IBOutlet UIPickerView *locationSelect;
@property IBOutlet UIPickerView *clubSelect;

@property IBOutlet UILabel *distanceLabel;
@property IBOutlet UILabel *distanceValueLabel;
@property IBOutlet UISlider *distanceSelect;

@property IBOutlet UILabel *shortShotLabel;
@property IBOutlet UISwitch *shortShot;

@property IBOutlet UILabel *normalizedLabel;
@property IBOutlet UISwitch *normalized;

@end

