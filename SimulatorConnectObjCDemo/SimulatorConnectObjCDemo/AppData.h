//
//  AppData.h
//  SimulatorConnectObjCDemo
//
//  Created by Chad Godsey on 5/25/21.
//

#import <Foundation/Foundation.h>
#import "SimulatorConnect/SimulatorConnect-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppData : NSObject 

@property (nonatomic, retain) NSString *authCode;
@property (nonatomic, retain) NSArray<id<LMDevice>> *devices;
@property (nonatomic, retain) id<LMDevice> device;
@property (nonatomic, retain) NSArray<id<LMShot>> *shots;
@property (nonatomic) LMClubType clubType;
@property (nonatomic) Boolean connected;

+ (id)sharedManager;

@end

NS_ASSUME_NONNULL_END
