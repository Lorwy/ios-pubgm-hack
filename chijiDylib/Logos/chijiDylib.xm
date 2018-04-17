#import <Metal/Metal.h>
#import <objc/runtime.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

NSUInteger value;
NSTimer *timer;

@interface IOSViewController : UIViewController{

}
- (void) dragMoving: (UIControl *) c withEvent:ev;
- (void) dragEnded: (UIControl *) c withEvent:ev;

- (void)switchValueChanged:(id)sender;
- (void)autoSwitchValueChanged:(id)sender;
- (void)autoChangValue;

@end

%group addUISwitch
%hook IOSViewController
- (void)loadView {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        UISwitch *mSwitch = [UISwitch new];
        mSwitch.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 115, 140);
        [mSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        mSwitch.on = NO;
        value = 100;
        [self.view addSubview:mSwitch];
        NSLog(@"+============开关添加成功");

        UISwitch *autoSwitch = [UISwitch new];
        autoSwitch.center = CGPointMake(40, 140);
        [autoSwitch addTarget:self action:@selector(autoSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        autoSwitch.on = NO;
        [self.view addSubview:autoSwitch];
        NSLog(@"+============自动开关添加成功");
    });
}

%new
-(void)switchValueChanged:(id)sender{
    UISwitch *mSwitch = (UISwitch *)sender;
    if(mSwitch.on){
        value = 1;
    } else {
        value = 100;
    }
}

%new
-(void)autoSwitchValueChanged:(id)sender{

    if(!timer) {
        timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(autoChangValue) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    UISwitch *mSwitch = (UISwitch *)sender;
    if(mSwitch.on) {
        //开启定时器
    } else {
        //关闭定时器
        [timer invalidate];
        timer = nil;
    }
}

%new
-(void)autoChangValue{
    if(value == 100){
        value = 1;
    } else {
        value = 100;
    }
}

%end

%end

%group A7
%hook AGXA7FamilyRenderContext

- (void)drawIndexedPrimitives:(MTLPrimitiveType)primitiveType indexCount:(NSUInteger)indexCount indexType:(MTLIndexType)indexType indexBuffer:(id<MTLBuffer>)indexBuffer indexBufferOffset:(NSUInteger)indexBufferOffset instanceCount:(NSUInteger)instanceCount baseVertex:(NSInteger)baseVertex baseInstance:(NSUInteger)baseInstance{
    if(instanceCount > value && value > 0){
        return;
    }

    return %orig;
}

%end
%end

%group A8
%hook AGXA8FamilyRenderContext

- (void)drawIndexedPrimitives:(MTLPrimitiveType)primitiveType indexCount:(NSUInteger)indexCount indexType:(MTLIndexType)indexType indexBuffer:(id<MTLBuffer>)indexBuffer indexBufferOffset:(NSUInteger)indexBufferOffset instanceCount:(NSUInteger)instanceCount baseVertex:(NSInteger)baseVertex baseInstance:(NSUInteger)baseInstance{
    if(instanceCount > value && value > 0){
        return;
    }

    return %orig;
}

%end
%end

%group A9
%hook AGXA9FamilyRenderContext

- (void)drawIndexedPrimitives:(MTLPrimitiveType)primitiveType indexCount:(NSUInteger)indexCount indexType:(MTLIndexType)indexType indexBuffer:(id<MTLBuffer>)indexBuffer indexBufferOffset:(NSUInteger)indexBufferOffset instanceCount:(NSUInteger)instanceCount baseVertex:(NSInteger)baseVertex baseInstance:(NSUInteger)baseInstance{
    if(instanceCount > value &&value > 0){
        return;
    }

    return %orig;
}

%end
%end

%group A10
%hook AGXA10FamilyRenderContext

- (void)drawIndexedPrimitives:(MTLPrimitiveType)primitiveType indexCount:(NSUInteger)indexCount indexType:(MTLIndexType)indexType indexBuffer:(id<MTLBuffer>)indexBuffer indexBufferOffset:(NSUInteger)indexBufferOffset instanceCount:(NSUInteger)instanceCount baseVertex:(NSInteger)baseVertex baseInstance:(NSUInteger)baseInstance{
    if(instanceCount > value &&value > 0){
        return;
    }

    return %orig;
}

%end
%end

%group A11
%hook AGXA11FamilyRenderContext

//祝我吃鸡吧
- (void)drawIndexedPrimitives:(MTLPrimitiveType)primitiveType indexCount:(NSUInteger)indexCount indexType:(MTLIndexType)indexType indexBuffer:(id<MTLBuffer>)indexBuffer indexBufferOffset:(NSUInteger)indexBufferOffset instanceCount:(NSUInteger)instanceCount baseVertex:(NSInteger)baseVertex baseInstance:(NSUInteger)baseInstance{

    if(instanceCount > value &&value > 0){
        return;
    }

    return %orig;
}

%end
%end

void hook_metal(){
    while(true){
        if(objc_getClass("AGXA7FamilyRenderContext")){
            %init(A7)
            NSLog(@"+============A7");

            break;
        }else if(objc_getClass("AGXA8FamilyRenderContext")){
            %init(A8)
            NSLog(@"+============A8");

            break;
        }else if(objc_getClass("AGXA9FamilyRenderContext")){
            %init(A9)
            NSLog(@"+============A9");

            break;
        }else if(objc_getClass("AGXA10FamilyRenderContext")){
            %init(A10)
            NSLog(@"+============A10");

            break;
        }else if(objc_getClass("AGXA11FamilyRenderContext")){
            %init(A11)
            NSLog(@"+============A11");

            break;
        }
    }
}

%ctor{
    NSLog(@"大吉大利，晚上吃鸡！");
    //
    %init(addUISwitch)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"6秒后hook");
        hook_metal();
    });
}
