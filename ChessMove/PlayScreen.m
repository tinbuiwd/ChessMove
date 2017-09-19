//
//  PlayScreen.m
//  sumAllMyPractices
//
//  Created by Bui Van Tin on 9/5/17.
//  Copyright © 2017 Bui Van Tin. All rights reserved.
//

#import "PlayScreen.h"
#import "ChessView.h"
#import "ChessObj.h"

@interface PlayScreen ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *imgNextTurnPlayer;

@end

@implementation PlayScreen
{
    CGFloat margin;
    UIView *containerView;
    CGFloat kCellWidth;
    NSMutableArray *currentPosition;
    NSArray *arrayNamesWhite;
    NSArray *arrayNamesBlack;
    
    NSMutableArray *flagArray;
    NSString *subNamePlayer;
    NSString *subNameRival;
    UIView *previousChess;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupValue];
    [self setupTableChess];
    [self addChessPlayerWithTag:100 andSubName:subNamePlayer];
    [self addChessRivalWithTag:200 andSubName:subNameRival];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}


//vẽ bàn cờ
- (void)setupTableChess
{
    //self.labelPlayer.text = self.currentPlayer;
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - margin * 2.0, self.view.bounds.size.width - margin * 2.0)];
    
    [self.view addSubview:containerView];
    containerView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
    kCellWidth = (self.view.bounds.size.width - margin * 2.0)/8.0;
    for (int rowIndex = 0; rowIndex < 8; rowIndex++)
    {
        for (int colIndex = 0; colIndex < 8; colIndex++)
        {
            CGRect rect = CGRectMake((CGFloat)colIndex*kCellWidth, (CGFloat)rowIndex*kCellWidth, kCellWidth, kCellWidth);
            UIView *cell = [[UIView alloc] initWithFrame:rect];
            
            if (rowIndex % 2 == 0) {
                cell.backgroundColor = (colIndex % 2 == 0) ? [UIColor colorWithRed:255.0/255.0 green:206.0/255.0 blue:158.0/255.0 alpha:1] : [UIColor colorWithRed:209.0/255.0 green:139.0/255.0 blue:71.0/255.0 alpha:1];
            } else {
                cell.backgroundColor = (colIndex % 2 == 0) ? [UIColor colorWithRed:209.0/255.0 green:139.0/255.0 blue:71.0/255.0 alpha:1] : [UIColor colorWithRed:255.0/255.0 green:206.0/255.0 blue:158.0/255.0 alpha:1];
            }
            [containerView addSubview:cell];
        }
    }
}

// vẽ quân cờ người chơi
- (void)addChessPlayerWithTag: (int)tag
                   andSubName: (NSString*)subName
{
    for (int rowIndex = 6; rowIndex < 8; rowIndex++)
    {
        for (int colIndex = 0; colIndex < 8; colIndex++)
        {
            CGRect rect = CGRectMake((CGFloat)colIndex*kCellWidth, (CGFloat)rowIndex*kCellWidth, kCellWidth, kCellWidth);
            int tempCol = colIndex;
            if (tempCol > 4) {
                tempCol = (int)arrayNamesWhite.count - tempCol + 1;
            }
            NSString *name = @"";
            if (rowIndex == 7)
            {
                if ([subNamePlayer isEqualToString:@"white"])
                {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesWhite[tempCol]];
                } else {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesBlack[tempCol]];
                }
            } else {
                if ([subNamePlayer isEqualToString:@"white"])
                {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesWhite.lastObject];
                } else {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesBlack.lastObject];
                }
            }
            UIImage *img = [UIImage imageNamed:name];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
            imgView.image = img;
            
            ChessView *chess = [[ChessView alloc] initWithFrame:rect];
            chess.tag = tag + colIndex + rowIndex * 8;
            chess.nameChess = name;
            flagArray[rowIndex][colIndex] = @1;
            chess.flagArray = flagArray;
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            
            pan.delegate = self;
            chess.imageView.image = img;
            [chess addGestureRecognizer:pan];
            [containerView addSubview:chess];
            
            
        }
    }
}

// vẽ quân cờ của đối thủ từ hàng 0-1
- (void)addChessRivalWithTag: (int) tag
                  andSubName: (NSString*) subName
{
    for (int rowIndex = 0; rowIndex < 2; rowIndex++)
    {
        for (int colIndex = 0; colIndex < 8; colIndex++)
        {
            CGRect rect = CGRectMake((CGFloat)colIndex*kCellWidth, (CGFloat)rowIndex*kCellWidth, kCellWidth, kCellWidth);
            int tempCol = colIndex;
            NSString *name = @"";
            if(tempCol > 4)
            {
                tempCol = (int)arrayNamesWhite.count - tempCol + 1;
            }
            if(rowIndex == 0)
            {
                if ([subNamePlayer isEqualToString:@"white"])
                {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesWhite[tempCol]];
                } else {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesBlack[tempCol]];
                }
            }
            else {
                if ([subNamePlayer isEqualToString:@"white"])
                {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesWhite.lastObject];
                } else {
                    name = [NSString stringWithFormat:@"%@%@", subName, arrayNamesBlack.lastObject];
                }
            }
            UIImage *img = [UIImage imageNamed:name];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
            imgView.image = img;
            
            ChessView *chess = [[ChessView alloc] initWithFrame:rect];
            chess.tag = tag + colIndex + rowIndex * 8;
            chess.nameChess = name;
            flagArray[rowIndex][colIndex] = @1;
            chess.flagArray = flagArray;
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            
            pan.delegate = self;

            chess.imageView.image = img;
            [chess addGestureRecognizer:pan];
            [containerView addSubview:chess];
        }
    }
}

- (void)setupValue
{
    margin = 10.0;
    
    currentPosition= [[NSMutableArray alloc] initWithObjects:@0, @0, nil];
    arrayNamesWhite = @[@"Rook", @"Knight", @"Bishop", @"Queen", @"King", @"Pawn"];
    arrayNamesBlack = @[@"Rook", @"Knight", @"Bishop", @"King", @"Queen", @"Pawn"];
    
    if ([self.colorPlayer isEqualToString:@"white"])
    {
        subNamePlayer = self.colorPlayer;
        subNameRival = @"";
    } else {
        //Trong THop self.colorPlayer chua co gia tri
        subNameRival = @"";
        subNamePlayer = @"white";
    }
    
    //Mảng đánh dấu vị trí bàn cờ: 0 - Chưa có quân cờ, 1- Đã có quân cờ
    flagArray = [[NSMutableArray alloc] initWithObjects:
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 [NSMutableArray arrayWithObjects:@0, @0, @0, @0, @0, @0, @0, @0, nil],
                 nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    //Vị trí quân cờ mà người dùng chọn
    CGPoint position = [touch locationInView:containerView];
    currentPosition[0] = [NSNumber numberWithFloat:floor(position.y/kCellWidth)];
    currentPosition[1] = [NSNumber numberWithFloat:floor(position.x/kCellWidth)];
    return true;
}


- (void)handlePan: (UIGestureRecognizer*)pan
{
    ChessView *chess = (ChessView*)[pan view];
    chess.flagArray = flagArray;
    CGPoint position = [pan locationInView:containerView];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        //Di chuyển quân cờ theo tác động Pan của người chơi
        chess.center = position;
        if (pan.state == UIGestureRecognizerStateBegan)
        {
            chess.layer.zPosition = 1;
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded)
    {
        int col = ceil(position.x/kCellWidth - 1); //Toạ độ cột mà quân cờ di chuyển đến
        int row = ceil(position.y/kCellWidth - 1); //Toạ độ hàng mà quân cờ di chuyển đến
        int tag = 200 + col + row*8; //Tag của quân đối thủ: Xử lí ăn
        
        
        //Trường hợp vị trí đích nằm trong bàn cờ, và quân cờ có thể di chuyển đến vị trí đó
        if ((col < 8 && row < 8) && (col >= 0 && row >= 0) && (([chess calculatePositionWithCurrentPosition:currentPosition andDestinationPosition:@[[NSNumber numberWithInt:row], [NSNumber numberWithInt:col]]] == true)))
        {
            //Trường hợp vị trí đích chưa có quân cờ nào => Di chuyển OK
            if ([flagArray[row][col]  isEqual: @0])
            {
                flagArray[[currentPosition[0] intValue]] [[currentPosition[1] intValue]] = @0;
                chess.center= CGPointMake((CGFloat)col * kCellWidth + kCellWidth/2, (CGFloat)row * kCellWidth + kCellWidth/2);
                flagArray[row][col] = @1;
                //Trường hợp vị trí đích đã tồn tại 1 quân cờ
            } else {
                //Trường hợp quân cờ là quân của đối thủ => Ăn
                ChessView *chessRemove = [self.view viewWithTag:tag];
                if (chessRemove)
                {
                    [chessRemove removeFromSuperview];
                    flagArray[[currentPosition[0] intValue]][[currentPosition[1] intValue]] = @0;
                    chess.center= CGPointMake((CGFloat)col * kCellWidth + kCellWidth/2, (CGFloat)row * kCellWidth + kCellWidth/2);
                    //Trường hợp quân cờ này là quân mình => Về vị trí cũ
                } else {
                    chess.center= CGPointMake((CGFloat)([currentPosition[1] intValue]) * kCellWidth + kCellWidth/2, (CGFloat)([currentPosition[0] intValue]) * kCellWidth + kCellWidth/2);
                }
            }
            //Trường hợp quân cờ không thể di chuyển đến vị trí đó => Về vị trí ban đầu
        } else {
            chess.center= CGPointMake((CGFloat)([currentPosition[1] intValue]) * kCellWidth + kCellWidth/2, (CGFloat)([currentPosition[0] intValue]) * kCellWidth + kCellWidth/2);
        }
    }
}

@end
