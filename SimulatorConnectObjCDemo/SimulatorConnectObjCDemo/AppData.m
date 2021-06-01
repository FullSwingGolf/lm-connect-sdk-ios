//
//  AppData.m
//  SimulatorConnectObjCDemo
//
//  Created by Chad Godsey on 5/25/21.
//

#import "AppData.h"

@implementation AppData

@synthesize authCode;
@synthesize devices;
@synthesize device;
@synthesize shots;
@synthesize clubType;
@synthesize connected;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static AppData *sharedAppData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppData = [[self alloc] init];
    });
    return sharedAppData;
}


- (id)init {
  if (self = [super init]) {
      //authCode = [[NSString alloc] initWithString:@""];
  }
  return self;
}

- (void)dealloc {
  // Should never be called, but just here for clarity really.
}

@end
