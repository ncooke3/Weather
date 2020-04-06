//
//  GraphPoint.h
//  Weather
//
//  Created by Nicholas Cooke on 3/21/20.
//  Copyright © 2020 Nicholas Cooke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphPoint : UIView

@property (nonatomic) UILabel *label;
@property (nonatomic, weak) UILabel *associatedLabel;

- (void)expand;
- (void)shrink;

@end
