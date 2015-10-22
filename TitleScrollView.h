//
//  TitleScrollView.h
//  SUNCommonComponent
//

#import <UIKit/UIKit.h>

@protocol TitleScrollViewDelegate;
@interface TitleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_rootScrollView;                  //主视图
    UIScrollView *_topScrollView;                   //顶部页签视图
    
    CGFloat _userContentOffsetX;
    BOOL _isLeftScroll;                             //是否左滑动
    BOOL _isRootScroll;                             //是否主视图滑动
    BOOL _isBuildUI;                                //是否建立了ui
    
    NSInteger _userSelectedChannelID;               //点击按钮选择名字ID
    
    UIImageView *_shadowImageView;
    UIImage *_shadowImage;
    
    UIColor *_tabItemNormalColor;                   //正常时tab文字颜色
    UIColor *_tabItemSelectedColor;                 //选中时tab文字颜色
    UIImage *_tabItemNormalBackgroundImage;         //正常时tab的背景
    UIImage *_tabItemSelectedBackgroundImage;       //选中时tab的背景
    
    UIButton *_rigthSideButton;                     //右侧按钮
    
    __weak id<TitleScrollViewDelegate> _titleScrollViewDelegate;
}
@property (nonatomic, strong) IBOutlet UIScrollView *topScrollView;
@property (nonatomic, assign) CGFloat userContentOffsetX;
@property (nonatomic, assign) NSInteger userSelectedChannelID;
@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;
@property (nonatomic, weak) IBOutlet id<TitleScrollViewDelegate> titleScrollViewDelegate;
@property (nonatomic, strong) UIColor *tabItemNormalColor;
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
@property (nonatomic, strong) UIImage *tabItemNormalBackgroundImage;
@property (nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) IBOutlet UIButton *rigthSideButton;
@property NSArray *titleArray;
@property NSArray *imgNameArray;
@property int defaultIndex;

- (void)initValues;
- (void)setSelectedViewIndex:(NSInteger)selectedViewIndex andAnimation:(BOOL)animation;
@end

@protocol TitleScrollViewDelegate <NSObject>
- (void)titleScrollView:(TitleScrollView *)view didselectTab:(NSUInteger)number;
@end
