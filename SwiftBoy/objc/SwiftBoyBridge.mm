//
//  SwiftBoyBridge.mm
//  SwiftBoy
//
//  Created by Andrew Gilliland on 12/21/25.
//

#import "SwiftBoyBridge.h"
#include "math.hpp"

@implementation SwiftBoyBridge

+ (int)addA:(int)a b:(int)b {
    return add(a, b);
}

@end
