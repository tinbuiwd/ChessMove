//
//  ChessView.m
//  sumAllMyPractices
//
//  Created by Bui Van Tin on 9/6/17.
//  Copyright © 2017 Bui Van Tin. All rights reserved.
//

#import "ChessView.h"
#import "ChessObj.h"

@implementation ChessView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubviews];
    }
    
    return self;
}


- (void)addSubviews
{
    if (self.imageView == nil)
    {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
        
        [self addSubview:self.imageView];
    }
}

//Tính toán xem quân cờ có thể di chuyển được đến vị trí đích không
- (BOOL)calculatePositionWithCurrentPosition:(NSArray *)currentPosition
                      andDestinationPosition:(NSArray *)destinationPosition
{
    NSString *tempName = self.nameChess;
    NSRange textRange = [tempName rangeOfString:@"white"];
    tempName = [tempName substringFromIndex:textRange.length];
    
    //Kiểu di chuyển của quân cờ
    int type = [self jumpTypesWithCurrentPosition:currentPosition
                           andDestinationPosition:destinationPosition];
    
    ChessPieces chessPieces = Pawn;
    if ([tempName isEqualToString:@"King"])
    {
        chessPieces = King;
    }
    else if ([tempName isEqualToString:@"Queen"])
    {
        chessPieces = Queen;
    }
    else if ([tempName isEqualToString:@"Bishop"])
    {
        chessPieces = Bishop;
    }
    else if ([tempName isEqualToString:@"Knight"])
    {
        chessPieces = Knight;
    }
    else if ([tempName isEqualToString:@"Rook"])
    {
        chessPieces = Rook;
    }
    else if ([tempName isEqualToString:@"Pawn"])
    {
        chessPieces = Pawn;
    }
    
    switch (chessPieces)
    {
        case King:                  //Tướng
            if ((abs([currentPosition[0] intValue] - [destinationPosition[0] intValue]) > 1) || (((abs([currentPosition[1] intValue] - [destinationPosition [1] intValue]) > 1))))
            {
                return false;       // Tướng không thể đi nhiều hơn 1 ô
            }
            if (type == 2)
            {                       //Đi thẳng
                return [self checkStraightWithCurrentPosition:currentPosition andDestinationPosition:destinationPosition];
            }
            if (type == 1)
            {                       //Đi chéo
                return [self checkDiagonalWithCurrentPosition:currentPosition andDestinationPosition:destinationPosition];
            }
            break;
            
        case Queen:                 //Hậu
            if (type == 2)
            {                       //Đi thẳng
                return [self checkStraightWithCurrentPosition:currentPosition andDestinationPosition:destinationPosition];
            }
            if (type == 1)          //Đi chéo
            {
                return [self checkDiagonalWithCurrentPosition:currentPosition andDestinationPosition:destinationPosition];
            }
            break;
            
        case Rook:                  //Xe
            if (type == 2)
            {                       //Đi thẳng
                return [self checkStraightWithCurrentPosition:currentPosition andDestinationPosition:destinationPosition];
            }
            break;
            
        case Bishop:                //Tượng
            if (type == 1)          //Đi chéo
            {
                return [self checkDiagonalWithCurrentPosition:currentPosition andDestinationPosition:destinationPosition];
            }
            break;
            
        case Knight:                //Mã
            if (type == 0)
            {
                return true;
            }
            break;
            
        case Pawn:                  //Tốt
            if ([currentPosition[0] intValue] - [destinationPosition[0] intValue] == 2 && [currentPosition[0] intValue] == 6 && [destinationPosition[1] intValue] == [currentPosition[1] intValue])
            {
                return true;        // Tốt có thể tiến 2 ô từ vị trí ban đầu (hàng 6)
            }
            if ((abs([currentPosition[0] intValue] - [destinationPosition[0] intValue]) > 1) || (((abs([currentPosition[1] intValue] - [destinationPosition[1] intValue]) > 1))))
            {
                return false;       // Tốt không thể đi nhiều hơn 1 ô
            }
            if ([destinationPosition[0] intValue] == 0 && [currentPosition[0] intValue] == 1) //phong Hậu
            {
                if (self.nameChess != tempName)
                {
                    self.nameChess = @"whiteQueen";
                } else {
                    self.nameChess = @"Queen";
                }
                
                self.imageView.image = [UIImage imageNamed:self.nameChess];
            }
            if (type == 1)          //Đi chéo
            {
                if (![self.flagArray[[destinationPosition[0] intValue]][[destinationPosition[1] intValue]]  isEqual: @0])
                {
                    return true;    //Trường hợp vị trí đích đã tồn tại quân cờ => true
                }
                return false;
            }
            if (type == 2)          //Đi thẳng
            {
                if (![self.flagArray[[destinationPosition[0] intValue]][[destinationPosition[1] intValue]]  isEqual: @0])
                {
                    return false;   //Vị trí đích đã tồn tại quân cờ => False
                }
                
                return [self checkStraightWithCurrentPosition:currentPosition
                                       andDestinationPosition:destinationPosition ];
            }
            
            break;
            
        default: false;
            break;
    }
    return false;
    
}

//Kiểu di chuyển của quân cờ
- (int)jumpTypesWithCurrentPosition:(NSArray *)currentPosition
             andDestinationPosition:(NSArray *)destinationPosition
{
    if (((abs([currentPosition[1] intValue] - [destinationPosition[1] intValue]) == 1) && (abs([currentPosition[0] intValue] - [destinationPosition[0] intValue]) == 2)) || (((abs([currentPosition[1] intValue] - [destinationPosition[1] intValue]) == 2) && ((abs([currentPosition[0] intValue] - [destinationPosition[0] intValue]) == 1)))))
    {
        return 0;   // Quân mã
    } else if (abs([currentPosition[0] intValue] - [destinationPosition[0] intValue]) == abs([currentPosition[1] intValue] - [destinationPosition[1] intValue]))
    {
        return 1;   //Di chuyển chéo
    } else if ([currentPosition[0] intValue] == [destinationPosition[0] intValue] || [currentPosition[1] intValue] == [destinationPosition[1] intValue])
    {
        return 2;   // Di chuyển thẳng
    }
        return 3;   // Đi linh tinh
}

- (BOOL)checkDiagonalWithCurrentPosition:(NSArray *)currentPostion
                  andDestinationPosition:(NSArray *)destinationPosition
{
    //0:rightUp
    //1:rightDown
    //2:leftUp
    //3:leftDown
    
    if (abs([currentPostion[0] intValue] - [destinationPosition[0] intValue]) == 1 && abs([currentPostion[1] intValue] - [destinationPosition[1] intValue]) == 1 && [self.flagArray[[destinationPosition[0] intValue]][[destinationPosition[1] intValue]] isEqual: @0])
    {
        //
        return true;
    }
    if (destinationPosition[0] < currentPostion[0])
    {
        if (destinationPosition[1] > currentPostion[1])
        {
            //rightup
            return [self loopCheckDiagonalWithPointA:currentPostion
                                          withPointB:destinationPosition andWayToCheck:0];
        }
        if (destinationPosition[1] < currentPostion[1])
        {
            //leftUp
            return [self loopCheckDiagonalWithPointA:currentPostion
                                          withPointB :destinationPosition andWayToCheck:2];
        }
    }
    if (destinationPosition[0] > currentPostion[0])
    {
        if (destinationPosition[1] > currentPostion[1])
        {
            return [self loopCheckDiagonalWithPointA:currentPostion
                                          withPointB:destinationPosition andWayToCheck:1];
        }
        if (destinationPosition[1] < currentPostion[1])
        {
            return [self loopCheckDiagonalWithPointA:currentPostion
                                          withPointB:destinationPosition andWayToCheck:3];
        }
    }
    return false;
}

  //Kiểm tra khả năng di chuyển thẳng của quân cờ
- (BOOL)checkStraightWithCurrentPosition:(NSArray*)currentPosition
                  andDestinationPosition:(NSArray*)destinationPosition
{
    //0:Up
    //1:Down
    //2:Left
    //3:Right
    if (((abs([currentPosition[0] intValue] - [destinationPosition[0] intValue]) == 1)) && (![self.nameChess containsString:[self convertToString:Pawn]]) && [self.flagArray[[destinationPosition[0] intValue]][[destinationPosition[1] intValue]] isEqual: @0])
    {
        return true;                                                // Tiến/lùi 1 ô, không phải Tốt, và flag = 0
    }
    if ([destinationPosition[0] intValue] < [currentPosition[0] intValue])                //Tiến nhiều ô  //up
    {
        return [self loopCheckStraightWithPointA:currentPosition
                                      withPointB:destinationPosition andWayToCheck:0];
    }
    if ([destinationPosition[0] intValue] > [currentPosition[0] intValue])                //Lùi nhiều ô  /down
    {
        if ([self.nameChess containsString:[self convertToString:Pawn]])
        {
            return true;
        }
        return [self loopCheckStraightWithPointA:currentPosition
                                      withPointB:destinationPosition andWayToCheck:1];
    } else {
        if ([self.nameChess containsString:[self convertToString:Pawn]])
        {
            return false;                                           // Tốt không thể sang ngang
        }
        if ([destinationPosition[1] intValue] < [currentPosition[1] intValue])            //Sang trái
        {
            return [self loopCheckStraightWithPointA:currentPosition withPointB:destinationPosition andWayToCheck:3];
        } else if ([destinationPosition[1] intValue] > [currentPosition[1] intValue])     //Sang phải
        {
            return [self loopCheckStraightWithPointA:currentPosition withPointB:destinationPosition andWayToCheck:2];
        }
        return false;
    }
}

- (NSString *) convertToString:(ChessPieces) chessPieces
{
    NSString *result = nil;
    
    switch(chessPieces)
    {
        case King:
            result = @"King";
            break;
        case Queen:
            result = @"Queen";
            break;
        case Bishop:
            result = @"Bishop";
            break;
        case Knight:
            result = @"Knight";
            break;
        case Rook:
            result = @"Rook";
            break;
        case Pawn:
            result = @"Pawn";
            break;
        default:
            result = @"unknown";
            break;
    }
    
    return result;
}

//Kiểm tra xem trong khoảng từ vị trí hiện tại đến vị trí đích có quân cờ nào cản đường không
- (BOOL)loopCheckStraightWithPointA: (NSArray *)pointA
                         withPointB: (NSArray *)pointB
                      andWayToCheck: (int)wayToCheck
{
    int row = [pointA[0] intValue];
    int col = [pointA[1] intValue];
    //Up,Down,Right,Left
    
    switch (wayToCheck)
    {
        case 0:  //Up
            for (int i=row-1; i>[pointB[0] intValue]; i--)
            {
                if (![self.flagArray[i][col]  isEqual: @0])
                {
                    return false;
                }
            }
            break;
        case 1:  //Down
            for (int i=row+1; i<[pointB[0] intValue]; i++)
            {
                if (![self.flagArray[i][col]  isEqual: @0])
                {
                    return false;
                }
            }
            break;
        case 2:  //Right
            for (int i=col+1; i<[pointB[1] intValue]; i++)
            {
                if (![self.flagArray[row][i]  isEqual: @0])
                {
                    return false;
                }
            }
            break;
        case 3: //Left
            for (int i=col-1; i>[pointB[1] intValue]; i--)
            {
                if (![self.flagArray[row][i]  isEqual: @0])
                {
                    return false;
                }
            }
            break;
            
        default: {
            return true;
            break;
        }
    }
    return true;
}

//Kiểm tra xem trong khoảng từ vị trí hiện tại đến vị trí đích có quân cờ nào cản đường không
- (BOOL)loopCheckDiagonalWithPointA: (NSArray *)pointA
                         withPointB: (NSArray *)pointB
                      andWayToCheck:(int)wayToCheck
{
    int row = [pointA[0] intValue];
    int col = [pointA[1] intValue];
    //Up,Down,Right,Left
    
    switch (wayToCheck)
    {
        case 0: //rightUp
            for (int i=1; row - i >[pointB[0] intValue]; i++)
            {
                if (![self.flagArray[row-i][col+i]  isEqual: @0])
                {
                    return false;
                }
            }
            break;
        case 1: //rightDown
            for (int i=1; i+row<[pointB[0] intValue]; i++)
            {
                if (![self.flagArray[row+i][col+i]  isEqual: @0])
                {
                    return false;
                }
            }
            break;
        case 2: //leftUp
            for (int i=1; row-i>[pointB[0] intValue]; i++)
            {
                if (![self.flagArray[row-i][col-i]  isEqual: @0])
                {
                    return false;
                }
            }
            break;
        case 3: //leftDown
            for (int i=1; i+row<[pointB[0] intValue]; i++)
            {
                if (![self.flagArray[row+i][col-i]  isEqual: @0])
                {
                    return false;
                }
            }
            break;
            
        default: {
            return true;
            break;
        }
    }
    return true;
}

@end
