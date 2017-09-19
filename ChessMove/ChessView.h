//
//  ChessView.h
//  sumAllMyPractices
//
//  Created by Bui Van Tin on 9/6/17.
//  Copyright © 2017 Bui Van Tin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    King,
    Queen,
    Bishop,
    Knight,
    Rook,
    Pawn
} ChessPieces;

@interface ChessView : UIView

@property(nonatomic, strong) NSArray *flagArray;
@property(nonatomic, strong) NSDictionary *chessPosition;
@property(nonatomic, strong) NSString *playerMove;
@property(nonatomic, strong) NSString *nameChess;
@property(nonatomic, strong) UIImageView *imageView;

- (BOOL)calculatePositionWithCurrentPosition:(NSArray *)currentPosition
                      andDestinationPosition:(NSArray *)destinationPosition;

- (NSString*) convertToString:(ChessPieces) chessPieces;

@end
