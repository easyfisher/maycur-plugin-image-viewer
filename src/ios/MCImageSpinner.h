//
//  MCImageSpinner.h
//  每刻报销
//
//  Created by LinyunDong on 6/1/16.
//
//

#import <UIKit/UIKit.h>

@protocol MCImageSpinnerDelegate <NSObject>

- (void)imageDidTap;

@end

@interface MCImageSpinner : UIView

@property (nonatomic, assign) id<MCImageSpinnerDelegate> delegate;

- (instancetype)initWithUrls:(NSArray<NSString *> *)urls default:(NSInteger)index;

@end
