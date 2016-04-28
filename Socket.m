//
//  Socket.m
//  WiiScale
//
//  Created by 安部謙太朗 on 2016/04/28.
//  Copyright © 2016年 Dmitri Amariei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiiScale-Swift.h"
/*

@interface AbeSocket : NSObject

@property SocketIOClient* socket;

-(void)socketInit;

@end

@implementation AbeSocket

-(void)socketInit{
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:8080"];
    
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @YES}];
    
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];
    
    [socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
        double cur = [[data objectAtIndex:0] floatValue];
        
        [socket emitWithAck:@"canUpdate" withItems:@[@(cur)]](0, ^(NSArray* data) {
            [socket emit:@"update" withItems:@[@{@"amount": @(cur + 2.50)}]];
        });
        
        [ack with:@[@"Got your currentAmount, ", @"dude"]];
    }];
    
    [socket connect];
     
}

@end
*/