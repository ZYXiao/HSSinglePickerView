#import "HSSinglePickerView.h"

@implementation HSSinglePickerView

#pragma mark - initial
- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = kUIColor(0, 0, 0, 0.4);
        self.hidden = YES;
        [self setup];
    }
    
    return self;
}

#pragma mark - load
- (void)setup
{
    // tap
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    _tap.enabled = NO;
    [self addGestureRecognizer:_tap];
    
    // pickerView
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(36);
        make.height.mas_equalTo(180);
    }];
    
    // topBar
    UIView *topBar = [[UIView alloc] init];
    topBar.backgroundColor = kUIColorFromRGB(0xFAFAFA);
    [self addSubview:topBar];
    [topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(_pickerView.mas_top);
        make.height.mas_equalTo(36);
    }];
    // line0
    UIImageView *line0 = [[UIImageView alloc] init];
    line0.backgroundColor = kUIColor(0, 0, 0, 0.2);
    [topBar addSubview:line0];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(topBar);
        make.height.mas_equalTo(0.5);
    }];
    // line1
    UIImageView *line1 = [[UIImageView alloc] init];
    line1.backgroundColor = kUIColorFromRGB(0xe1e1e1);
    [topBar addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(topBar);
        make.height.mas_equalTo(0.5);
    }];
    
    // cancelBtn
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [cancelBtn setTitleColor:kUIColorFromRGB(0x8F8E94) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[kUIColorFromRGB(0x8F8E94) colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    [topBar addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(topBar);
        make.width.mas_equalTo(60);
    }];
    
    // confirmBtn
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [confirmBtn setTitle:@"完成" forState:UIControlStateHighlighted];
    [confirmBtn setTitleColor:[AppConfig shareConfig].mainColor forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[AppConfig shareConfig].mainHighlightedColor forState:UIControlStateHighlighted];
    [topBar addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(topBar);
        make.width.mas_equalTo(60);
    }];
}

- (void)refresh {
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self.pickerView reloadAllComponents];
}


#pragma mark - custom setter
- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [self refresh];
}


#pragma mark - actions
- (void)cancelBtnClicked:(id)sender
{
    [self hide:YES];
    if ([self.delegate respondsToSelector:@selector(cancelBtnClickedOfPickerView:)]) {
        [self.delegate cancelBtnClickedOfPickerView:self];
    }
}

- (void)confirmBtnClicked:(id)sender
{
    [self hide:YES];
    NSInteger selectedIndex = [self.pickerView selectedRowInComponent:0];
    self.selectedStr = [self.dataSource objectAtIndex:selectedIndex];
    if ([self.delegate respondsToSelector:@selector(confirmBtnClickedOfPickerView:)]) {
        [self.delegate confirmBtnClickedOfPickerView:self];
    }
}

#pragma mark - gesture
- (void)handleTap
{
    [self hide:YES];
}

#pragma mark - animations
- (void)show:(BOOL)animated
{
    NSTimeInterval duration = 0;
    if (animated) {
        duration = 0.15;
    }
    self.hidden = NO; // 必须要先解除隐藏
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-180);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _tap.enabled = YES;
    }];
}

- (void)hide:(BOOL)animated
{
    NSTimeInterval duration = 0;
    if (animated) {
        duration = 0.15;
    }
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(36);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _tap.enabled = NO;
        self.hidden = YES;
    }];
}


#pragma mark - pickerView
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH;
}

// 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 40.0)];
    label.font = [UIFont systemFontOfSize:17.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kUIColor(0, 0, 0, 0.78);
    label.backgroundColor = [UIColor clearColor];
    label.text = [self.dataSource objectAtIndex:row];
    
    return label;
}



@end
