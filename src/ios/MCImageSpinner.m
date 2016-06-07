//
//  MCImageSpinner.m
//  每刻报销
//
//  Created by LinyunDong on 6/1/16.
//
//

#import "MCImageSpinner.h"

@protocol SpinnerItemDelegate <NSObject>

- (void)imageDidTap;

@end

@interface SpinnerItem : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, assign) id<SpinnerItemDelegate> spinnerDelegate;

@end

@implementation SpinnerItem

- (instancetype)initWithUrl:(NSString *)url {
    self = [self init];
    if (self) {
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.maximumZoomScale = 4;
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.imageView];
        
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.indicator startAnimating];
        [self addSubview:self.indicator];
      
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidTap)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [self processImageWithURLString:url completion:^(NSData *data){
            self.imageView.image = [UIImage imageWithData:data];
            [self.indicator stopAnimating];
        }];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    self.contentSize = CGSizeMake(width, height);
    self.imageView.frame = CGRectMake(0, 0, width, height);
    self.indicator.center = CGPointMake(width/2, height/2);
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)imageDidTap {
    [self.spinnerDelegate imageDidTap];
}

- (void)imageDidDoubleTap:(UIGestureRecognizer *)gesture {
    if (self.zoomScale == 1) {
        CGPoint center = [gesture locationInView:self];
        CGRect rect = [self zoomRectForScrollView:self withScale:2.5 withCenter:center];
        [self zoomToRect:rect animated:YES];
    } else {
        [self setZoomScale:1 animated:YES];
    }
}

@end

@interface MCImageSpinner() <SpinnerItemDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<SpinnerItem *> *items;

@property (nonatomic, strong) NSArray<NSString *> *urls;
@property (nonatomic, assign) NSInteger index;

@end

@implementation MCImageSpinner

- (instancetype)initWithUrls:(NSArray<NSString *> *)urls default:(NSInteger)index {
    self = [self init];
    if (self) {
        self.urls = urls;
        self.index = index;
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.delegate = self;
        
        self.items = [NSMutableArray array];
        for (int i = 0; i < urls.count; i++) {
            SpinnerItem *item = [[SpinnerItem alloc] initWithUrl:urls[i]];
            item.spinnerDelegate = self;
            [self.scrollView addSubview:item];
            [self.items addObject:item];
        }
        self.scrollView.pagingEnabled = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidTap)];
        [self.scrollView addGestureRecognizer:gesture];
        
        [self addSubview:self.scrollView];
    }
    return self;
}

-(void)layoutSubviews {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    self.scrollView.frame = CGRectMake(0, 0, width, height);
    
    for (int i = 0; i < self.urls.count; i++) {
        self.items[i].frame = CGRectMake(width * i, 0, width, height);
    }
    
    self.scrollView.contentSize = CGSizeMake(self.urls.count * width, 0);
    self.scrollView.contentOffset = CGPointMake(self.index * width, 0);
}

- (void)imageDidTap {
    [self.delegate imageDidTap];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    for (SpinnerItem *item in self.items) {
        if (item.zoomScale != 1)
            item.zoomScale = 1;
    }
}

@end
