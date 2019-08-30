//
//  procHelper.c
//  RSwitch
//
//  Created by hrbrmstr on 8/25/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

#include "procHelper.h"
#include "procInfo.h"
#import <Foundation/Foundation.h>

NSMutableArray *getArgs(pid_t pid) {
  
  Process* process = [[Process alloc] init:pid];
  return(process.arguments);
  
}
