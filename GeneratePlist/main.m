//
//  main.m
//  GeneratePlist
//
//  Created by Ravi Shankar on 07/07/13.
//  Copyright (c) 2013 Ravi Shankar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Util.h"

int main(int argc, char *argv[])
{        
    [Util generatePlist:@"mrts"];
    [Util generatePlist:@"bchtmb"];
    [Util generatePlist:@"tmbchg"];
    [Util generatePlist:@"ctltni"];
    [Util generatePlist:@"ctlsul"];
    [Util generatePlist:@"chethi"];

}
