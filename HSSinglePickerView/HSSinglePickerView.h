#import <UIKit/UIKit.h>

@protocol HSSinglePickerViewDelegate;

@interface HSSinglePickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,weak) id <HSSinglePickerViewDelegate>delegate;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSString *selectedStr;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) UIPickerView *pickerView;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end

@protocol HSSinglePickerViewDelegate <NSObject>
@optional
- (void)confirmBtnClickedOfPickerView:(HSSinglePickerView *)pickerView;
- (void)cancelBtnClickedOfPickerView:(HSSinglePickerView *)pickerView;

@end
