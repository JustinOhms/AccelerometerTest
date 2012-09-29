//
//  NetworkManager.h
//  AccelerometerTest
//
//  Created by Alex Pawlowski on 9/12/12.
//

#import <Foundation/Foundation.h>

#include <unistd.h>
#include <netdb.h>

#import "AccelerationInfo.h"

@interface NetworkManager : NSObject {
    int udpSocket;
	struct sockaddr_in targetAddress;
    BOOL shake;
}

@property (strong, nonatomic) NSString *targetIPAddress;
@property (strong) AccelerationInfo *accelInfo;
@property (assign) BOOL enabled;
@property (assign) BOOL shake;

@end
