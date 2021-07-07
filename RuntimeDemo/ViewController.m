//
//  ViewController.m
//  RuntimeDemo
//
//  Created by zhang jb on 2020/7/2.
//  Copyright © 2020 tayo.com. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+image.h"
//#import "UIButton+button.h"
#import "Cat.h"
#import "SourceBlock.h"
#import <objc/runtime.h>


@implementation Person

- (void)fun {
    NSLog(@"person fun");
}

@end


@interface ViewController ()

@property(nonatomic,strong)  UIImageView *imageview;

@property (nonatomic,strong) SourceBlock *sourceBlock;

@property (nonatomic ,strong)NSTimer  *timer;

@property (strong,nonatomic)dispatch_source_t sourceTimer;

@property(strong,nonatomic)NSThread   *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IMP imp1 = class_getMethodImplementation(objc_getClass("ViewController"), @selector(timerRun));
    Method m1 = class_getClassMethod(objc_getClass("ViewController"), @selector(timerRun));
    method_setImplementation(m1, imp1);
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    /*
     消息机制是运行时里面最重要的机制,每个方法在运行时会被动态转化为消息发送，即：objc_msgSend(receiver, selector)
     */
    self.imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 100, 50, 50)];
    
    UIImage *ima=[UIImage imageNamed:@"6"];
    NSLog(@"%s", sel_getName(@selector(imageNamed:)));
    self.imageview.image=ima;
    //中心点
    [self.view addSubview:self.imageview];
    // 消息动态解析
    [[Cat new] performSelector:@selector(eat:) withObject:@"啥都吃"];
    
     //消息接受者重定向
     // 执行 fun 方法
    [self performSelector:@selector(fun)];
    
    NSString *(^block)(NSString *)=^NSString *(NSString *str){
        
        
        return [str stringByAppendingString:@"block实现了"];
    };
    NSLog(@"%@", block(@"我调用block！！"));
    
     __weak __typeof(self) weakSelf = self;
    //在block内部使用 弱指针引用，不会造成循环引用
    self.sourceBlock=[[SourceBlock alloc]initWithMyBlock:^(NSString *myBlockStr) {
        NSLog(@"MyBlockblock 监听 ：%@",myBlockStr);
    } withVoidBlock:^(NSString *voidBlockStr){
        NSLog(@"voidBlockStr 监听 ：%@",voidBlockStr);
    }];
    [weakSelf.sourceBlock userMyBolck:@"123" voidBlock:@"456"];
    
//
//    self.timer=[NSTimer timerWithTimeInterval:10.0 target:weakSelf selector:@selector(timerRun) userInfo:nil repeats:YES];
//
//    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    /**
     RunLoop 5种 Mode
     
     NSDefaultRunLoopMode
     NSConnectionReplyMode
     NSModalPanelRunLoopMode
     NSEventTrackingRunLoopMode
     NSRunLoopCommonModes
     
     滚动Scrollview的时候，RunLoop会切换到UITrackingRunLoopMode 模式，而定时器运行在defaultMode下面，系统一次只能处理一种模式的RunLoop，所以导致defaultMode下的定时器失效。
     
     解决：   把timer注册到NSRunLoopCommonModes，它包含了defaultMode和trackingMode两种模式。
     
     [[NSRunLoop currentRunLoop] addTimer:timer  forMode:NSRunLoopCommonModes];
     
     */
    
    
    /*
    //使用GCD创建定时器，GCD创建的定时器不会受RunLoop的影响
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 比当前时间晚1秒开始执行
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    
    //每隔一秒执行一次
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.sourceTimer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.sourceTimer, ^{
        NSLog(@"------------%@", [NSThread currentThread]);

    });
    //销毁定时器
    //dispatch_source_cancel(_sourceTimer);
    // 启动定时器
    dispatch_resume(self.sourceTimer);
    */
    
    //RunLoop使用
    [self start];
    [self btnSetting];
}

-(void)btnSetting{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    
//    [btn setAcceptEventInterval:2];
//    [btn setAcceptEventTime:1];
    btn.frame=CGRectMake(50, 50, 50, 50);
    [btn setTitle:@"btn" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

+(BOOL)resolveInstanceMethod:(SEL)sel {
    return YES; // 为了进行下一步 消息接受者重定向
}

// 消息接受者重定向
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(fun)) {
        return [[Person alloc] init];
        // 返回 Person 对象，让 Person 对象接收这个消息
    }
    return [super forwardingTargetForSelector:aSelector];
}

//下面两种添加定时器的方法效果相同，都是在主线程中添加定时器
- (void)timer1 {
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timer2 {
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
}


- (void)timerRun {
    NSLog(@"%s", __func__);
}



- (void)dealloc {
    [self.timer invalidate];
    NSLog(@"%s", __func__);
}


//RunLoop 的实际应用举例
//创建常驻线程
+ (void)networkRequestThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"AFNetworking"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}
+ (NSThread *)networkRequestThread {
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint:) object:nil];
        [_networkRequestThread start];
    });
    return _networkRequestThread;
}
//使用常驻线程
- (void)start {
    
    [self performSelector:@selector(timerRun) onThread:[[self class] networkRequestThread] withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode] ];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        NSLog(@"1");
        //1 2 3
        //[self performSelector:@selector(timerRun) withObject:nil];
        
        //1 3  要开启runloop 不然不执行
       // [self performSelector:@selector(timerRun) withObject:nil afterDelay:0];
       //[[NSRunLoop currentRunLoop] run];
        
        
        //yes: 123   no:1 3
        //任务添加到runloop 中 runloop ：timerRun
        //同一个线程，yes(消息调度) no:（runloop 添加）
        //不同线程，yes: no (是否等待任务执行后继续执行)
        [self performSelector:@selector(timerRun) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
        //[[NSRunLoop currentRunLoop] run];
        
        NSLog(@"3");
    });
    
}
@end
