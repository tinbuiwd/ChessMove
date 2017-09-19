//
//  ChessObj.h
//  sumAllMyPractices
//
//  Created by Bui Van Tin on 9/6/17.
//  Copyright © 2017 Bui Van Tin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChessObj : NSObject

- (instancetype)initWithNameChess: (NSString *)name
                withChessPosition: (NSArray *)chessPosition
        withPreviousChessPosition: (NSArray *)prePosition
                   withPlayerMove: (NSString *)playerMove
                     andFlagArray: (NSArray *)flagArray;
@end
