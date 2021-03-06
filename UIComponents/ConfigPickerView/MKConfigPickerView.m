//
//  MKConfigPickerView.m
//  UIComponents
//
//  Created by mikazheng on 2021/11/18.
//

#import "MKConfigPickerView.h"

#import <MKUtils/MarcoConstant.h>
#import <MKUtils/UIView+Addition.h>
#import <MKUtils/UIColor+Addition.h>
#import <MKUtils/NSArray+Additions.h>

#import "MKConstant.h"

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
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
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
    self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
    _contentView.top = self.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        self.contentView.bottom = self.height;
    }];
}

- (void)removeFromSuperview {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
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
        _confirmBack(_seletedRow, [_contents safeObjectAtIndex:_seletedRow], [_values safeObjectAtIndex:_seletedRow]);
    }
    
    [self removeFromSuperview];
}

#pragma mark - Getter -
- (UIView *)toolBar {
    UIView* toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, UIScalePixel(50))];
    toolBar.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    
    UILabel* titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.text = _title;
    titleLab.font = UIScaleFont(16);
    titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleLab sizeToFit];
    titleLab.center = CGPointMake(toolBar.width/2, toolBar.height/2);
    [toolBar addSubview:titleLab];
    
    UIButton* cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UIScalePixel(52), toolBar.height)];
    [cancelBtn setTitle:@"??????" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(onCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#9B9B9B"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = UIScaleFont(14);
    [toolBar addSubview:cancelBtn];
    
    UIButton* confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - UIScalePixel(52), 0, UIScalePixel(52), toolBar.height)];
    [confirmBtn setTitle:@"??????" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(onConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
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
        _pickerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
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
    
    NSString* content = [_contents safeObjectAtIndex:row];
    UILabel* contentLab = [[UILabel alloc] initWithFrame:cell.bounds];
    contentLab.text = content;
    contentLab.font = UIScaleFont(16);
    contentLab.textColor = [UIColor colorWithHexString:@"#333333"];
    contentLab.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:contentLab];
    
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.seletedRow = row;
}

@end
