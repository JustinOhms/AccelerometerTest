//
//  NetworkManager.m
//  AccelerometerTest
//
//  Created by Alex Pawlowski on 9/12/12.
//

#import "NetworkManager.h"

#include <unistd.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <errno.h>

#define kAccelerometerSimulationPort 10552
#define kAccelerometerSimulationRepeat 0.01

@interface NetworkManager () {
    float dt, tmp;
}

@property (strong) NSTimer *timer;

@end

@implementation NetworkManager
@synthesize targetIPAddress, enabled = _enabled, shake;

- (id)init {
    self = [super init];
    if (self) {
        _enabled = YES;
        shake = NO;
        
        [self addObserver:self forKeyPath:@"self.targetIPAddress" options:NSKeyValueObservingOptionNew context:nil];
        
		// create socket
		udpSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
		// init in broadcast mode
		int broadcast = 0;
		setsockopt(udpSocket, SOL_SOCKET, SO_BROADCAST, &broadcast, sizeof(int));
        
		memset((char *) &targetAddress, 0, sizeof(targetAddress));
		targetAddress.sin_family = AF_INET;
		// broadcast address 255.255.255.255
		// TODO: figure out device IP address and netmask, produce a subnet broadcast address
		targetAddress.sin_addr.s_addr = htonl(0xFFFFFFFF);
		targetAddress.sin_port = htons(kAccelerometerSimulationPort);
		targetAddress.sin_len = sizeof(targetAddress);
        
        dt = 0;
        tmp = 2 * 2 * M_PI * kAccelerometerSimulationRepeat;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:kAccelerometerSimulationRepeat target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"self.targetIPAddress"]) {
        const char *addr = [self.targetIPAddress UTF8String];
		inet_aton(addr, &targetAddress.sin_addr);
    }
}

- (void)timerAction {
    if (udpSocket != -1 && _enabled && _accelInfo) {
        _accelInfo.absTime = CFAbsoluteTimeGetCurrent();
        const char *msg;
        if (shake) {
            msg = [[NSString stringWithFormat:@"ACC: %s,%.3f,%1.3f,%1.3f,%1.3f\n",[_accelInfo.deviceID UTF8String],_accelInfo.absTime,3*cos(tmp * dt + M_2_PI),3*cos(tmp * dt + M_2_PI),(3 * cos(tmp * dt + M_2_PI))] UTF8String];
            dt++;
            if (dt >= floor(2 / kAccelerometerSimulationRepeat)) {
                shake = NO;
            }
        } else {
            dt = 0;
            msg = [[NSString stringWithFormat:@"ACC: %s,%.3f,%1.3f,%1.3f,%1.3f\n",[_accelInfo.deviceID UTF8String],_accelInfo.absTime,_accelInfo.x,_accelInfo.y,_accelInfo.z] UTF8String];
        }
        
        long error = sendto(udpSocket, msg, strlen(msg), 0, (struct sockaddr*)&targetAddress, sizeof(targetAddress));
        if( error < 0 )
        {
            //NSLog(@"Socket error %d", errno);
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.targetIPAddress"];
}

@end
