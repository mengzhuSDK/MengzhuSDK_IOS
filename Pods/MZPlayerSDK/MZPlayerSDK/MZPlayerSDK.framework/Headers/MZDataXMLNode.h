//
//  MZDataXMLNode.h
//  YueTao_iOS
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/xmlstring.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>


#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_4) || defined(MZData_TARGET_NAMESPACE)
  // we need NSInteger for the 10.4 SDK, or we're using target namespace macros
  #import "MZDataDefines.h"
#endif

#undef _EXTERN
#undef _INITIALIZE_AS
#ifdef MZDataXMLNODE_DEFINE_GLOBALS
#define _EXTERN
#define _INITIALIZE_AS(x) =x
#else
#define _EXTERN extern
#define _INITIALIZE_AS(x)
#endif

// when no namespace dictionary is supplied for XPath, the default namespace
// for the evaluated tree is registered with the prefix _def_ns
_EXTERN const char* kMZDataXMLXPathDefaultNamespacePrefix _INITIALIZE_AS("_def_ns");

// Nomenclature for method names:
//
// Node = MZData node
// XMLNode = xmlNodePtr
//
// So, for example:
//  + (id)nodeConsumingXMLNode:(xmlNodePtr)theXMLNode;

@class NSArray, NSDictionary, NSError, NSString, NSURL;
@class MZDataXMLElement, MZDataXMLDocument;

enum {
  MZDataXMLInvalidKind = 0,
  MZDataXMLDocumentKind,
  MZDataXMLElementKind,
  MZDataXMLAttributeKind,
  MZDataXMLNamespaceKind,
  MZDataXMLProcessingInstructionKind,
  MZDataXMLCommentKind,
  MZDataXMLTextKind,
  MZDataXMLDTDKind,
  MZDataXMLEntityDeclarationKind,
  MZDataXMLAttributeDeclarationKind,
  MZDataXMLElementDeclarationKind,
  MZDataXMLNotationDeclarationKind
};

typedef NSUInteger MZDataXMLNodeKind;

@interface MZDataXMLNode : NSObject {
@protected
  // NSXMLNodes can have a namespace URI or prefix even if not part
  // of a tree; xmlNodes cannot.  When we create nodes apart from
  // a tree, we'll store the dangling prefix or URI in the xmlNode's name,
  // like
  //   "prefix:name"
  // or
  //   "{http://uri}:name"
  //
  // We will fix up the node's namespace and name (and those of any children)
  // later when adding the node to a tree with addChild: or addAttribute:.
  // See fixUpNamespacesForNode:.

  xmlNodePtr xmlNode_; // may also be an xmlAttrPtr or xmlNsPtr
  BOOL shouldFreeXMLNode_; // if yes, xmlNode_ will be free'd in dealloc

  // cached values
  NSString *cachedName_;
  NSArray *cachedChildren_;
  NSArray *cachedAttributes_;
}

+ (MZDataXMLElement *)elementWithName:(NSString *)name;
+ (MZDataXMLElement *)elementWithName:(NSString *)name stringValue:(NSString *)value;
+ (MZDataXMLElement *)elementWithName:(NSString *)name URI:(NSString *)value;

+ (id)attributeWithName:(NSString *)name stringValue:(NSString *)value;
+ (id)attributeWithName:(NSString *)name URI:(NSString *)attributeURI stringValue:(NSString *)value;

+ (id)namespaceWithName:(NSString *)name stringValue:(NSString *)value;

+ (id)textWithStringValue:(NSString *)value;

- (NSString *)stringValue;
- (void)setStringValue:(NSString *)str;

- (NSUInteger)childCount;
- (NSArray *)children;
- (MZDataXMLNode *)childAtIndex:(unsigned)index;

- (NSString *)localName;
- (NSString *)name;
- (NSString *)prefix;
- (NSString *)URI;

- (MZDataXMLNodeKind)kind;

- (NSString *)XMLString;

+ (NSString *)localNameForName:(NSString *)name;
+ (NSString *)prefixForName:(NSString *)name;

// This is the preferred entry point for nodesForXPath.  This takes an explicit
// namespace dictionary (keys are prefixes, values are URIs).
- (NSArray *)nodesForXPath:(NSString *)xpath namespaces:(NSDictionary *)namespaces error:(NSError **)error;

// This implementation of nodesForXPath registers namespaces only from the
// document's root node.  _def_ns may be used as a prefix for the default
// namespace, though there's no guarantee that the default namespace will
// be consistenly the same namespace in server responses.
- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error;

// access to the underlying libxml node; be sure to release the cached values
// if you change the underlying tree at all
- (xmlNodePtr)XMLNode;
- (void)releaseCachedValues;

@end


@interface MZDataXMLElement : MZDataXMLNode

- (id)initWithXMLString:(NSString *)str error:(NSError **)error;

- (NSArray *)namespaces;
- (void)setNamespaces:(NSArray *)namespaces;
- (void)addNamespace:(MZDataXMLNode *)aNamespace;

- (void)addChild:(MZDataXMLNode *)child;
- (void)removeChild:(MZDataXMLNode *)child;

- (NSArray *)elementsForName:(NSString *)name;
- (NSArray *)elementsForLocalName:(NSString *)localName URI:(NSString *)URI;

- (NSArray *)attributes;
- (MZDataXMLNode *)attributeForName:(NSString *)name;
- (MZDataXMLNode *)attributeForLocalName:(NSString *)name URI:(NSString *)attributeURI;
- (void)addAttribute:(MZDataXMLNode *)attribute;

- (NSString *)resolvePrefixForNamespaceURI:(NSString *)namespaceURI;

@end

@interface MZDataXMLDocument : NSObject {
@protected
  xmlDoc* xmlDoc_; // strong; always free'd in dealloc
}

- (id)initWithXMLString:(NSString *)str options:(unsigned int)mask error:(NSError **)error;
- (id)initWithData:(NSData *)data options:(unsigned int)mask error:(NSError **)error;
- (id)initWithRootElement:(MZDataXMLElement *)element;

- (MZDataXMLElement *)rootElement;

- (NSData *)XMLData;

- (void)setVersion:(NSString *)version;
- (void)setCharacterEncoding:(NSString *)encoding;

// This is the preferred entry point for nodesForXPath.  This takes an explicit
// namespace dictionary (keys are prefixes, values are URIs).
- (NSArray *)nodesForXPath:(NSString *)xpath namespaces:(NSDictionary *)namespaces error:(NSError **)error;

// This implementation of nodesForXPath registers namespaces only from the
// document's root node.  _def_ns may be used as a prefix for the default
// namespace, though there's no guarantee that the default namespace will
// be consistenly the same namespace in server responses.
- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error;

- (NSString *)description;
@end
