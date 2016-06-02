#import "MCImageViewer.h"
#import <Cordova/CDVPlugin.h>
#import "MCImageSpinner.h"

@interface MCImageViewer() <MCImageSpinnerDelegate>

@property (nonatomic, strong) MCImageSpinner *spinner;

@end

@implementation MCImageViewer

- (void)show:(CDVInvokedUrlCommand*)command {
    NSArray<NSString *> *urls = [command.arguments objectAtIndex:0];
    NSNumber *indexNum = [command.arguments objectAtIndex:1];
    if (!urls || !indexNum) {
        return;
    }
    if (urls.count <= 0) {
        return;
    }
    NSInteger index = [indexNum integerValue];
    if (index < 0) {
        index = 0;
    } else if (index >= urls.count) {
        index = urls.count - 1;
    }
    
    self.spinner = [[MCImageSpinner alloc] initWithUrls:urls default:index];
    self.spinner.delegate = self;
    self.spinner.alpha = 0;
    
    CGFloat width = self.webView.bounds.size.width;
    CGFloat height = self.webView.bounds.size.height;
    self.spinner.frame = CGRectMake(0, 0, width, height);
    
    [self.webView.superview addSubview:self.spinner];
    [UIView  animateWithDuration:0.35 animations:^(){
        self.spinner.alpha = 1;
    }];
}

- (void)imageDidTap {
    [UIView animateWithDuration:0.35 animations:^(){
        self.spinner.alpha = 0;
    } completion:^(BOOL finished){
        [self.spinner removeFromSuperview];
        self.spinner = nil;
    }];
}

@end




