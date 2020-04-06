//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by Gavin on 2020/4/2.
//  Copyright © 2020 GSNICE. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *labelView;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIView *blueView;
@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // RACSignal
//    [self RACsignal];
    
    // RACSubject
//    [self RACSubject];
    
    // RACReplaySubject
//    [self RACReplaySubject];
    
    // RACSequence 和 RACTuple
//    [self ArrayTuple];
//    [self DictionaryTuple];
//    [self DictionaryToModel];
    
    // RACMulticastConnection
//    [self RACMulticastConnection];
    
    // RACCommand
//    [self RACCommand];
    
    //  RAC(TARGET, [KEYPATH, [NIL_VALUE]])：用于给某个对象的某个属性绑定。
//    [self test1];
    
    // RACObserve(self, name)：监听某个对象的某个属性，返回的是信号。
//    [self test2];
    
    // RACTuplePack：把数据包装成 RACTuple（元组类）。
//    [self test3];
    
    // RACTupleUnpack：把 RACTuple（元组类）解包成对应的数据。
//    [self test4];
    
    // rac_signalForSelector：用于代替代理。
//    [self test5];
    
    // rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
//    [self test6];
    
    // rac_signalForControlEvents：用于监听某个事件。
//    [self test7];
    
    // rac_textSignal：只要文本框发出改变就会发出这个信号。
//    [self test8];
    
}

#pragma mark - RACSignal
- (void)RACsignal {
    // 三步骤:创建信号，订阅信号，发送信号
    
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        // 3.发送信号
        [subscriber sendNext:@1];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"默认信号发送完毕被取消");
        }];
    }];

    // 2.订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    // 取消订阅
    [disposable dispose];
}

#pragma mark - RACSubject
- (void)RACSubject {
    // 信号提供者，自己可以充当信号，又能发送信号。
    
    // 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者一%@",x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"订阅者二%@",x);
    }];

    // 发送信号
    [subject sendNext:@"111"];
}

#pragma mark - RACReplaySubject
- (void)RACReplaySubject {
    // 创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];

    // 发送信号
    [replaySubject sendNext:@"222"];
    [replaySubject sendNext:@"333"];

    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];

   // 如果想一个信号被订阅，就重复播放之前所有值，需要先发送信号，再订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
}

#pragma mark - RACSequence 和 RACTuple
- (void)ArrayTuple {
    NSArray *array = @[@1,@2,@3];
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}
- (void)DictionaryTuple {
    NSDictionary *dict = @{@"name":@"张三",@"age":@"20",@"sex":@"男"};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        // RACTupleUnpack 这是个宏，后面会介绍
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"%@---%@",key,value);
        /*
         相当于：
         NSString *key = x[0];
         NSString *value = x[1];
         */
    }];
}

#pragma mark 使用场景：将字典转为数据模型
- (void)DictionaryToModel {
    // RAC 高级写法:
//    [AFNHelper get:kUrl parameter:nil success:^(id responseObject) {
//        NSArray *array = responseObject;
//        // map：映射的意思，目的：把原始值 value 映射成一个新值
//        // array: 把集合转换成数组
//        // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
//      NSArray *musicArray = [[array.rac_sequence map:^id(id value) {
//          Music *music = [Music fetchMusicModelWithDict:value ];
//            return music;
//        }] array];
//        NSLog(@"--------%@",musicArray);
//    } faliure:^(id error) {
//        NSLog(@"%@",error);
//    }];
}

#pragma mark - RACMulticastConnection
- (void)RACMulticastConnection {
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id subscriber) {
       NSLog(@"请求一次");
       //5.发送信号
       [subscriber sendNext:@"2"];
       return nil;
    }];
    // 2.把信号转化为连接类
    RACMulticastConnection *connection = [signal publish];
    // 3.订阅连接类信号
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@",x);
    }];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"第三个订阅者%@",x);
    }];

    // 4.链接信号
    [connection connect];
}

#pragma mark - RACCommand
- (void)RACCommand {
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // 命令内部传递的参数
        NSLog(@"input===%@",input);
        // 2.返回一个信号，可以返回一个空信号 [RACSignal empty];
        return [RACSignal createSignal:^RACDisposable *(id subscriber) {
            NSLog(@"发送数据");
            // 发送信号
            [subscriber sendNext:@"22"];
            // 注意：数据传递完，最好调用 sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // 拿到返回信号方式二：
    // command.executionSignals 信号中的信号 switchToLatest 转化为信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"拿到信号的方式二%@",x);
    }];

    // 拿到返回信号方式一：
    RACSignal *signal =  [command execute:@"11"];

    [signal subscribeNext:^(id x) {
        NSLog(@"拿到信号的方式一%@",x);
    }];
    
    // 3.执行命令
    [command execute:@"11"];
    
    // 监听命令是否执行完毕
    [command.executing subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            NSLog(@"命令正在执行");
        }
        else {
            NSLog(@"命令完成/没有执行");
        }
    }];
}

#pragma mark - RAC(TARGET, [KEYPATH, [NIL_VALUE]])：用于给某个对象的某个属性绑定。
- (void)test1 {
    // 只要文本框文字改变，就会修改 label 的文字
    RAC(self.labelView,text) = _textField.rac_textSignal;
}

#pragma mark - RACObserve(self, name)：监听某个对象的某个属性，返回的是信号。
- (void)test2 {
    [RACObserve(self.view, center) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - RACTuplePack：把数据包装成 RACTuple（元组类）。
- (void)test3 {
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@10,@20);
    NSLog(@"tuple = %@",tuple);
}

#pragma mark - RACTupleUnpack：把 RACTuple（元组类）解包成对应的数据。
- (void)test4 {
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@"NAME",@25);
    NSLog(@"tuple = %@",tuple);
    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
    // name = @"NAME" age = @25
    RACTupleUnpack(NSString *name,NSNumber *age) = tuple;
    NSLog(@"name = %@,age = %@",name,age);
}

#pragma mark - rac_signalForSelector：用于代替代理。
- (void)test5 {
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5"];
    [[array rac_signalForSelector:@selector(objectAtIndex:)]
    subscribeNext:^(id x) {
        NSLog(@"做额外操作");
    }];
    NSLog(@"NSArray index_3:%@",[array objectAtIndex:3]);
}

#pragma mark - rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
- (void)test6 {
    [[self.blueView rac_valuesAndChangesForKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"%@",x);
    }];
    [self.blueView setBackgroundColor:[UIColor redColor]];
}

#pragma mark - rac_signalForControlEvents：用于监听某个事件。
- (void)test7 {
    // 监听事件
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了按扭");
    }];
}

#pragma mark - rac_textSignal：只要文本框发出改变就会发出这个信号。
- (void)test8 {
    // 监听文本框的文字改变
    @weakify(self);
    [self.textField.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"%@",x);
        self.labelView.text = x;
    }];
}

@end
