//
//  ParseOperation.m
//  RSSFun
//
//  Created by Guilherme Andrade on 7/28/14.
//  Copyright (c) 2014 Unicamp. All rights reserved.
//

#import "ParseOperation.h"
#import "News.h"

@interface ParseOperation () <NSXMLParserDelegate>

@property (strong, nonatomic) News *currentNewsObject;
@property (strong, nonatomic) NSMutableString *currentParsedCharacterData;

@end

@implementation ParseOperation

{
	BOOL _accumulatingParsedCharacterData;
}

- (instancetype)initWithData:(NSData*)parseData{
	if( self = [super init] ){
		self.parseData = parseData;
	}
	return self;
}

- (void)main{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.parseData];
    [parser setDelegate:self];
    [parser parse];
}

#pragma mark - NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
		
	if( [elementName isEqualToString:@"item"] ){
		self.currentNewsObject = [[News alloc] init];
		_accumulatingParsedCharacterData = YES;
	}
	else if ( [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"title"] || [elementName isEqualToString:@"description"]){
		_accumulatingParsedCharacterData = YES;
		self.currentParsedCharacterData = [NSMutableString string];
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if(_accumulatingParsedCharacterData) [self.currentParsedCharacterData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if([elementName isEqualToString:@"link"]){
		self.currentNewsObject.link = self.currentParsedCharacterData;
	}
	else if([elementName isEqualToString:@"title"]){
		self.currentNewsObject.title = self.currentParsedCharacterData;
	}
	else if([elementName isEqualToString:@"description"]){
		self.currentNewsObject.description = self.currentParsedCharacterData;
		
		if(self.currentNewsObject){
			[[NSNotificationCenter defaultCenter] postNotificationName:@"newParsedObjectAvailable" object:self.currentNewsObject];
		}
		
	}
	
	_accumulatingParsedCharacterData = NO;
}


@end
