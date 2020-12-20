//
//  TFLogManager.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/11/4.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFLogManager.h"
#import "NSString+TFEncrypt.h"
#import "NSDictionary+Ext.h"

#define DD_LEGACY_MACROS 0
#import "DDLog.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

#define TFLogDir @"TF/Files/Logs"

@interface TFLogFormatter : NSObject <DDLogFormatter> {
    // Direct accessors to be used only for performance
@public
    NSString *_message;
    DDLogLevel _level;
    DDLogFlag _flag;
    NSUInteger _context;
    NSString *_file;
    NSString *_fileName;
    NSString *_function;
    NSUInteger _line;
    id _tag;
    DDLogMessageOptions _options;
    NSDate *_timestamp;
    NSString *_threadID;
    NSString *_threadName;
    NSString *_queueLabel;
}
@end

@implementation TFLogFormatter

static NSDateFormatter *dateFormatter;

- (id)init {
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
            dateFormatter = [threadDictionary objectForKey:@"cachedDateFormatter"];
            if (dateFormatter == nil) {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setDateFormat: @"YYYY-MM-dd HH:mm:ss:SSS"];
                [threadDictionary setObject:dateFormatter forKey:@"cachedDateFormatter"];
            }
            
        });
    }
    
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSMutableDictionary *logDict = [NSMutableDictionary dictionary];
    //取得文件名
    NSString *locationString;
    NSArray *parts = [logMessage->_file componentsSeparatedByString:@"/"];
    if ([parts count] > 0) {
        locationString = [parts lastObject];
    }
    
    if ([locationString length] == 0) {
        locationString = @"No file";
    }
    
    //这里的格式: {"location":"myfile.m:120(void a::sub(int)"}， 文件名，行数和函数名是用的编译器宏 __FILE__, __LINE__, __PRETTY_FUNCTION__
    logDict[@"location"] = [NSString stringWithFormat:@"%@:%lu(%@)", locationString, (unsigned long)logMessage->_line, logMessage->_function];
    logDict[@"timestamp"] = [dateFormatter stringFromDate:(logMessage.timestamp)];
    logDict[@"message"] = logMessage.message;
    logDict[@"originalMessage"] = logMessage.message;// [logMessage.message XOR];
    
    //尝试将logDict内容转为字符串，其实这里可以直接构造字符串，但真实项目中，肯定需要很多其他的信息，不可能仅仅文件名、行数和函数名就够了的。
    NSString *jsonString = [logDict jsonString];
    if (jsonString) {
        return jsonString;
    }
    
    return @"{\"location\":\"error\"}";
}

@end

#pragma mark - TFDatabaseLogger

@interface TFDatabaseLogger:DDAbstractDatabaseLogger

@property (nonatomic, strong) NSMutableArray *logMessagesArray;

/**
 *  自定义保存日志回调方法
 */
@property (nonatomic, copy) void(^saveLogsBlock)(NSString *logString);

@end

@implementation TFDatabaseLogger

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithDeleteInterval:(NSTimeInterval)deleteInterval
                                maxAge:(NSTimeInterval)maxAge
                     deleteOnEverySave:(BOOL)deleteOnEverySave
                          saveInterval:(NSTimeInterval)saveInterval
                         saveThreshold:(NSUInteger)saveThreshold
                        saveLogCalback:(void(^)(NSString *logMessageString))saveLogCalback {
    if (self = [super init]) {
        self.deleteInterval = deleteInterval;
        self.maxAge = maxAge;
        self.deleteOnEverySave = deleteOnEverySave;
        self.saveInterval = saveInterval;
        self.saveThreshold = saveThreshold;
        _saveLogsBlock = saveLogCalback;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveOnSuspend)
                                                     name:@"UIApplicationWillResignActiveNotification"
                                                   object:nil];
    }
    
    return self;
}

- (void)saveOnSuspend {
    dispatch_async(_loggerQueue, ^{
        [self db_save];
    });
}

/**
 *  每次打log时，db_log: 会被调用
 *  在这个函数里，将log发给formatter，将返回的log消息体字符串保存在缓冲中。 
 *  db_log的返回值告诉DDLog该条log是否成功保存进缓存
 */
- (BOOL)db_log:(DDLogMessage *)logMessage {
    // 是否指定formatter判定
    if (!_logFormatter) {
        return NO;
    }
    
    // saveThreshold为500，一般情况下够了
    if (!_logMessagesArray) {
        _logMessagesArray = [NSMutableArray arrayWithCapacity:500];
    }
    
    // 如果段时间内进入大量log，并且迟迟没有处理，可以判断哪里出了问题，在这之后的 log 暂时不处理了。
    // 但依然要告诉DDLog这个存进去了。
    if ([_logMessagesArray count] > 2000) {
        return YES;
    }
    
    //利用formatter得到消息字符串，添加到缓存
    [_logMessagesArray addObject:[_logFormatter formatLogMessage:logMessage]];
    
    return YES;
}

/**
 *  当1分钟或者未写入 log 数达到 500 时， db_save 就会被调用，在这里，将缓存的数据进行处理：如上传、保存文件等
 */
- (void)db_save {
    //判断是否在logger自己的GCD队列中
    if (![self isOnInternalLoggerQueue]) {
        NSAssert(NO, @"db_saveAndDelete should only be executed on the internalLoggerQueue thread, if you're seeing this, your doing it wrong.");
    }
    
    //如果缓存内没数据，啥也不做
    if ([_logMessagesArray count] == 0) {
        return;
    }
    
    // 获取缓存中所有数据，之后将缓存清空
    NSArray *oldLogMessagesArray = [_logMessagesArray copy];
    _logMessagesArray = [NSMutableArray arrayWithCapacity:0];
    
    //用换行符，把所有的数据拼成一个大字符串
    NSString *logMessagesString = [oldLogMessagesArray componentsJoinedByString:@"\n"];
    
    // 发送日志
    if (self.saveLogsBlock) {
        self.saveLogsBlock(logMessagesString);
    }
}

@end

#pragma mark - TFLogFileManagerDefault

@interface TFLogFileManagerDefault:DDLogFileManagerDefault

@end

@implementation TFLogFileManagerDefault

- (NSString *)generateShortUUID {
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
    [threadUnsafeDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    NSString *dateFormatString = @"yyyy-MM-dd";
    [threadUnsafeDateFormatter setDateFormat:dateFormatString];
    NSString *filename = [threadUnsafeDateFormatter stringFromDate:date];
    
    return filename;
}

- (NSString *)createNewLogFileWithError:(NSError *__autoreleasing  _Nullable *)error {
    NSString *logsDirectory = [self logsDirectory];
    int index = 1;
    NSString *fileName = [NSString stringWithFormat:@"tf-log-%@.txt", [self generateShortUUID]];
    
    do {
        NSString *filePath = [logsDirectory stringByAppendingPathComponent:fileName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
            // Since we just created a new log file, we may need to delete some old log files
            //[self deleteOldLogFiles];
            NSLog(@"create file:%@",fileName);
            
            return filePath;
        }
        else
        {
            NSString *strFile = [filePath stringByDeletingPathExtension];
            NSString *strFileName = [strFile lastPathComponent];
            NSString *strFileNameFormat = [self isContainCharacter:strFileName];
            if (strFileNameFormat) {
                strFileName = strFileNameFormat;
            }
            
            fileName =[NSString stringWithFormat:@"%@(%d).%@",strFileName,index,[filePath pathExtension]];
            index++;
        }
    } while(YES);
}

- (NSString*)isContainCharacter:(NSString*)fileName{
    NSString *strCharachter = @"(";
    NSRange foundPer=[fileName rangeOfString:strCharachter options:NSCaseInsensitiveSearch];
    if(foundPer.length>0) {
        NSRange rang;
        rang.location = 0;
        rang.length = foundPer.location;
        NSString *strRes = [fileName substringWithRange:rang];
        return strRes;
    }
    else {
        return nil;
    }
}

- (BOOL)isLogFile:(NSString *)fileName{
    if (fileName && [fileName length]>3) {
        NSRange rang;
        rang.location = [fileName length] - 4;
        rang.length = 4;
        NSString *strTmpName = [fileName substringWithRange:rang];
        
        if ([strTmpName isEqualToString:@".txt"]) {
            rang.location = 0;
            rang.length = 4;
            strTmpName = [fileName substringWithRange:rang];
            
            if ([@"tf-" isEqualToString:strTmpName]) {
                return YES;
            }
        }
    }
    
    return NO;
}

@end

#pragma mark - DBSDDLogFileManagerDefault

@interface TFFileLogger:DDFileLogger

@property (nonatomic, strong) NSString *logDir;

@end

@implementation TFFileLogger
- (id)initWithLogDir:(NSString *)logDir {
    _logDir = logDir;
    TFLogFileManagerDefault *defaultLogFileManager = [[TFLogFileManagerDefault alloc] initWithLogsDirectory:[self getTFCacheLogsDir]];
    return [self initWithLogFileManager:defaultLogFileManager];
}

/**
 *  获取缓存日志文件路径
 */
- (NSString*)getTFCacheLogsDir {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *cachedLogDir=[dir stringByAppendingPathComponent:(self.logDir) ? self.logDir : TFLogDir];
    
    return cachedLogDir;
}

@end

#pragma mark - TFLogManager

@implementation TFLogManager

+ (void)load {
    [super load];
    
    // required, setup DDLog
    // 日志语句将被发送到Console.app和Xcode控制台（就像标准的NSLog）
    // Use DDOSLogger for iOS 10 and later, or DDTTYLogger and DDASLLogger for earlier versions to begin logging messages.
    
//    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    [DDLog addLogger:[DDOSLogger sharedInstance]]; // Uses os_log
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    
    [[DDTTYLogger sharedInstance] setLogFormatter:[TFLogFormatter new]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    // set color
    /*
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:LOG_FLAG_DEBUG];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor orangeColor] backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor redColor] backgroundColor:nil forFlag:LOG_FLAG_WARN];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:LOG_FLAG_INFO];
     */
}

+ (instancetype) sharedManager {
    static TFLogManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFLogManager alloc] init];
    });
    
    return sharedInstance;
}

- (void)logWithDeleteInterval:(NSTimeInterval)deleteInterval
                       maxAge:(NSTimeInterval)maxAge
            deleteOnEverySave:(BOOL)deleteOnEverySave
                 saveInterval:(NSTimeInterval)saveInterval
                saveThreshold:(NSUInteger)saveThreshold
               saveLogCalback:(void (^)(NSString *))saveLogCalback {
    TFDatabaseLogger *logger = [[TFDatabaseLogger alloc] initWithDeleteInterval:deleteInterval
                                                                         maxAge:maxAge
                                                              deleteOnEverySave:deleteOnEverySave
                                                                   saveInterval:saveInterval
                                                                  saveThreshold:saveThreshold
                                                                 saveLogCalback:saveLogCalback];
    [logger setLogFormatter:[TFLogFormatter new]];
    [DDLog addLogger:logger];
}

- (void)logWithMaximumFileSize:(long long)maximumFileSize
              rollingFrequency:(long long)rollingFrequency
       maximumNumberOfLogFiles:(NSInteger)maximumNumberOfLogFiles
                        logDir:(NSString *)logDir {
    TFFileLogger *fileLogger = [[TFFileLogger alloc] initWithLogDir:logDir];
    fileLogger.maximumFileSize = 1024 * 1024 * maximumFileSize;   // 1024 * 1 KB
    fileLogger.rollingFrequency = rollingFrequency;     // 60*60*60 Seconds
    fileLogger.logFileManager.maximumNumberOfLogFiles = maximumNumberOfLogFiles;
    [DDLog addLogger:fileLogger];
}

@end
