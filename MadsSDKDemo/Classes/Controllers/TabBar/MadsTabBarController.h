//
//  MadsTabBarController.h
//  MadsDemo
//
//  Created by Vim Solution on 7/10/14.
//
//

#import <UIKit/UIKit.h>

@interface MadsTabBarController : UITabBarController

@end


#import "MadsDemoAppDelegate.h"


@implementation UINavigationBar (customNav)

- (CGSize)sizeThatFits:(CGSize)size
{
    if (!self.topItem.title) {
        return CGSizeZero;
    }
    return CGSizeMake(self.superview.bounds.size.width, self.bounds.size.height) ;
}

@end
