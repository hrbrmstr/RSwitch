//
//  procHelper.h
//  RSwitch
//
//  Created by hrbrmstr on 8/25/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

#ifndef procHelper_h
#define procHelper_h

#include <stdio.h>
#include "procHelper.h"
#include "procInfo.h"
#import <Foundation/Foundation.h>

NSMutableArray *getArgs(pid_t pid);

#endif /* procHelper_h */
