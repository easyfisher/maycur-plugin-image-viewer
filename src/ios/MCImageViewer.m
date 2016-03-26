#import "MCImageViewer.h"
#import <Cordova/CDVPlugin.h>

@interface MCImageViewer()

@property (nonatomic, strong) UIScrollView *scrollView;

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
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor blackColor];
    CGFloat width = self.webView.bounds.size.width;
    CGFloat height = self.webView.bounds.size.height;
    self.scrollView.frame = CGRectMake(width/2, height/2, 0, 0);
    
    for (int i = 0; i < urls.count; i++) {
        UIImageView *view = [[UIImageView alloc] init];
        view.frame = CGRectMake(width * i, 0, width, height);
        view.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:view];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.center = CGPointMake(width * (i + 0.5), height/2);
        [indicator startAnimating];
        [self.scrollView addSubview:indicator];
        
        [self processImageWithURLString:urls[i] completion:^(NSData *data){
            view.image = [UIImage imageWithData:data];
            [indicator stopAnimating];
        }];
    }
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(3 * width, 0);
    self.scrollView.contentOffset = CGPointMake(index * width, 0);
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidTap)];
    [self.scrollView addGestureRecognizer:gesture];
    
    [self.webView.superview addSubview:self.scrollView];
    [UIView  animateWithDuration:0.35 animations:^(){
        self.scrollView.frame = CGRectMake(0, 0, width, height);
    }];
}

- (void)imageDidTap {
    CGFloat width = self.webView.bounds.size.width;
    CGFloat height = self.webView.bounds.size.height;
    [UIView animateWithDuration:0.35 animations:^(){
        self.scrollView.frame = CGRectMake(width/2, height/2, 0, 0);
    } completion:^(BOOL finished){
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
    }];
}

- (void)processImageWithURLString:(NSString *)urlString completion:(void (^)(NSData *data))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(data);
        });
    });
}

@end