//
//  MKConfigPickerView.m
//  UIComponents
//
//  Created by mikazheng on 2021/11/18.
//

#import "MKConfigPickerView.h"
#import "MKConstant.h"
#import <MKUtils/UIView+Addition.h>
#import <MKUtils/MarcoConstant.h>

@interface MKConfigPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, strong) UIPickerView* pickerView;
@property (nonatomic, assign) NSInteger seletedRow;

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSArray* contents;
@property (nonatomic, copy) NSArray* values;
@property (nonatomic, copy) void(^confirmBack)(NSInteger row, NSString *content, id value);

@end

@implementation MKConfigPickerView

- (instancetype)initWithTitle:(NSString *)title contents:(NSArray *)contents values:(NSArray *)values confirmBack:(void (^)(NSInteger, NSString *, id))confirmBack {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.title = title;
        self.contents = contents;
        self.values = values;
        self.confirmBack = confirmBack;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    self.backgroundColor = UIColorWithRGBA(0x000000, 0.6);
    [self addTarget:self action:@selector(onCancelAction:)];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, UIScalePixel(240))];
    contentView.bottom = self.height;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    [self.contentView addSubview:[self toolBar]];
    [self.contentView addSubview:self.pickerView];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    
    [self showAnimation];
}

- (void)show {
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    
    [self showAnimation];
}

- (void)showAnimation {
    self.backgroundColor = UIColorWithRGBA(0x000000, 0);
    _contentView.top = self.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = UIColorWithRGBA(0x000000, 0.6);
        self.contentView.bottom = self.height;
    }];
}

- (void)removeFromSuperview {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = UIColorWithRGBA(0x000000, 0);
        self.contentView.top = self.height;
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

#pragma mark - Action -
- (void)onCancelAction:(UIButton *)btn {
    [self removeFromSuperview];
}

- (void)onConfirmAction:(UIButton *)btn {
    if (_confirmBack) {
        _confirmBack(_seletedRow, [_contents objectAtIndex:_seletedRow], [_values objectAtIndex:_seletedRow]);
    }
    
    [self removeFromSuperview];
}

#pragma mark - Getter -
- (UIView *)toolBar {
    UIView* toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, UIScalePixel(50))];
    toolBar.backgroundColor = UIColorWithRGB(0xF7F7F7);
    
    UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.text = _title;
    titleLab.font = UIScaleFont(16);
    titleLab.textColor = UIColorWithRGB(0x333333);
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleLab sizeToFit];
    titleLab.center = CGPointMake(toolBar.width/2, toolBar.height/2);
    [toolBar addSubview:titleLab];
    
    UIButton* cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UIScalePixel(52), toolBar.height)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:UIColorWithRGB(0x9B9B9B) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = UIScaleFont(14);
    [toolBar addSubview:cancelBtn];
    
    UIButton* confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - UIScalePixel(52), 0, UIScalePixel(52), toolBar.height)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(onConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    confirmBtn.titleLabel.font =  UIScaleFont(14);
    [toolBar addSubview:confirmBtn];
    
    return toolBar;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, UIScalePixel(50), self.width, UIScalePixel(132))];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = NO;
        _pickerView.backgroundColor = UIColorWithRGB(0xFFFFFF);
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource -
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return UIScalePixel(44);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _contents.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView* cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, UIScalePixel(44))];
    
    NSString* content = [_contents objectAtIndex:row];
    UILabel* contentLab = [[UILabel alloc] initWithFrame:cell.bounds];
    contentLab.text = content;
    contentLab.font = UIScaleFont(16);
    contentLab.textColor = UIColorWithRGB(0x333333);
    contentLab.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:contentLab];
    
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.seletedRow = row;
}

@end
