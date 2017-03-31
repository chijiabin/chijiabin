#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

                        
                                              
@interface RecordCell : UITableViewCell           
                                                  
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *uid;
@property (strong, nonatomic) IBOutlet UILabel *money;
@property (strong, nonatomic) IBOutlet UILabel *list_id;
@property (strong, nonatomic) IBOutlet UILabel *mark;
@property (strong, nonatomic) IBOutlet UILabel *status_info;
@property (strong, nonatomic) IBOutlet UILabel *is_hidden;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *timer;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *add_time;

@property (weak, nonatomic) IBOutlet UIImageView *recoderImageMake;


- (void)recordData:(NSDictionary *)data;

@end                                                          
