//
//  TitleScrollView.m
//  SUNCommonComponent
//

#import "TitleScrollView.h"

const CGFloat kHeightOfTopScrollView = 44.0f;
const CGFloat kWidthOfButtonMargin = 0.0f;
const CGFloat kFontSizeOfTabButton = 17.0f;
const NSUInteger kTagOfRightSideButton = 999;

@implementation TitleScrollView

#pragma mark - 初始化参数

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)initValues
{
    _userSelectedChannelID = 100;

    [self buildUI];
}

- (void)buildUI
{
    self.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    //创建顶部可滑动的tab
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeightOfTopScrollView)];
    _topScrollView.scrollsToTop = NO;
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor clearColor];
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:_topScrollView.frame];
    backImg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    backImg.image = [[UIImage imageNamed:@"navigation_bar"] stretchableImageWithLeftCapWidth:100 topCapHeight:10];
    [self addSubview:backImg];
    [self addSubview:_topScrollView];
    
    _shadowImageView = [[UIImageView alloc] init];
    [_shadowImageView setImage:_shadowImage];
    [_topScrollView addSubview:_shadowImageView];
    
    //顶部tabbar的总长度
    CGFloat topScrollViewContentWidth = kWidthOfButtonMargin;
    //每个tab偏移量
    CGFloat xOffset = kWidthOfButtonMargin;
    NSUInteger number = [_titleArray count];
    for (int i = 0; i < number; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize textSize;
        //累计每个tab文字的长度
        textSize.width = kScreenWidth/number;
        topScrollViewContentWidth += kWidthOfButtonMargin+textSize.width;
        //设置按钮尺寸
        [button setFrame:CGRectMake(xOffset,0,
                                    textSize.width, kHeightOfTopScrollView)];
        //计算下一个tab的x偏移量
        xOffset += textSize.width + kWidthOfButtonMargin;
        
        [button setTag:i+100];
        if (i == 0) {
            _shadowImageView.frame = CGRectMake(kWidthOfButtonMargin, 0, textSize.width, kHeightOfTopScrollView/*_shadowImage.size.height*/);
            button.selected = YES;
        }
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSizeOfTabButton];
        [button setTitleColor:self.tabItemNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.tabItemSelectedColor forState:UIControlStateSelected];
        [button setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
        [button setBackgroundImage:self.tabItemSelectedBackgroundImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
    }
    //设置顶部滚动视图的内容总尺寸
    _topScrollView.contentSize = CGSizeMake(topScrollViewContentWidth, kHeightOfTopScrollView);
}

#pragma mark - 顶部滚动视图逻辑方法

/**
 * @method 选中tab时间
 * @abstract
 * @discussion
 * @param 按钮
 * @result
 */
- (void)selectNameButton:(UIButton *)sender
{
    
    //如果更换按钮
    if (sender.tag != _userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID
        _userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [_shadowImageView setFrame:CGRectMake(sender.frame.origin.x, 0, sender.frame.size.width, kHeightOfTopScrollView/*_shadowImage.size.height*/)];
            
        } completion:^(BOOL finished) {
            if (finished) {
                _isRootScroll = NO;
                if (self.titleScrollViewDelegate && [self.titleScrollViewDelegate respondsToSelector:@selector(titleScrollView:didselectTab:)]) {
                    [self.titleScrollViewDelegate titleScrollView:self didselectTab:_userSelectedChannelID - 100];
                }
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        if (self.titleScrollViewDelegate && [self.titleScrollViewDelegate respondsToSelector:@selector(titleScrollView:didselectTab:)]) {
            [self.titleScrollViewDelegate titleScrollView:self didselectTab:_userSelectedChannelID - 100];
        }
    }
}


- (void)setSelectedViewIndex:(NSInteger)selectedViewIndex andAnimation:(BOOL)animation{
    NSInteger butTag = 100+selectedViewIndex;
    UIButton* button = (UIButton*)[_topScrollView viewWithTag:butTag];
    if (button)
    {
        if (animation) {
            [self selectNameButton:button];
        }
        else{
            //如果更换按钮
            if (button.tag != _userSelectedChannelID) {
                //取之前的按钮
                UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
                lastButton.selected = NO;
                //赋值按钮ID
                _userSelectedChannelID = button.tag;
            }
            
            //按钮选中状态
            if (!button.selected) {
                button.selected = YES;
                [_shadowImageView setFrame:CGRectMake(button.frame.origin.x, 0, button.frame.size.width, kHeightOfTopScrollView/*_shadowImage.size.height*/)];
                
                _isRootScroll = NO;
                if (self.titleScrollViewDelegate && [self.titleScrollViewDelegate respondsToSelector:@selector(titleScrollView:didselectTab:)]) {
                    [self.titleScrollViewDelegate titleScrollView:self didselectTab:_userSelectedChannelID - 100];
                }
            }
        }
    }
}
@end
