//
//  AccelerationInfo.h
//  AccSim
//
//  Created by Otto Chrons on 9/26/08.
//  Copyright 2008 Enzymia Ltd.. All rights reserved.
//

typedef double UIAccelerationValue;

// Internal communication object for acceleration information
@interface AccelerationInfo : NSObject {
	NSString *deviceID;
	CFAbsoluteTime absTime;
	UIAccelerationValue x, y, z;
}

@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic) CFAbsoluteTime absTime;
@property (nonatomic) UIAccelerationValue x, y, z;

+ (AccelerationInfo*)createWithTimestamp:(NSTimeInterval)timeStamp X:(UIAccelerationValue)x Y:(UIAccelerationValue)y Z:(UIAccelerationValue)z;

+ (AccelerationInfo*)createWithTimestamp:(NSTimeInterval)timeStamp X:(UIAccelerationValue)x Y:(UIAccelerationValue)y Z:(UIAccelerationValue)z deviceID:(NSString *)devID;

@end
