
/*
 * This file is part of Jkop for iOS
 * Copyright (c) 2016-2017 Job and Esther Technologies, Inc.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import <Foundation/Foundation.h>

@protocol CapeCharacterIterator;

/*
 * The String class provides all the common string manipulation functions,
 * including comparisons, concatenation, transformations to upper and lowercase,
 * getting substrings, finding characters or substrings, splitting the strings,
 * converting to byte buffers, etc.
 */

@interface CapeString : NSObject
- (CapeString*) init;

/*
 * Converts an arbitrary object to a string, if possible.
 */

+ (NSString*) asStringWithObject:(id)obj;

/*
 * Converts an integer to a string
 */

+ (NSString*) asStringWithSignedInteger:(int)value;

/*
 * Converts a double to a string
 */

+ (NSString*) asStringWithDouble:(double)value;

/*
 * Converts a buffer to a string
 */

+ (NSString*) asStringWithBuffer:(NSMutableData*)value;

/*
 * Converts a boolean to a string
 */

+ (NSString*) asStringWithBoolean:(BOOL)value;

/*
 * Converts a character to a string
 */

+ (NSString*) asStringWithCharacter:(int)value;

/*
 * Converts a float to a string
 */

+ (NSString*) asStringWithFloat:(float)value;

/*
 * Checks if a string is empty (ie., either the object is a null pointer or the
 * length of the string is less than one character).
 */

+ (BOOL) isEmpty:(NSString*)str;

/*
 * Constructs a new string, given a buffer of bytes and the name of the encoding.
 * Supported encodings: UTF8, UCS2 and ASCII
 */

+ (NSString*) forBuffer:(NSMutableData*)data encoding:(NSString*)encoding;

/*
 * Constructs a new string for a buffer of bytes, encoded using the ASCII character
 * set.
 */

+ (NSString*) forASCIIBuffer:(NSMutableData*)data;

/*
 * Constructs a new string for a buffer of bytes, encoded using the UTF8 character
 * encoding.
 */

+ (NSString*) forUTF8Buffer:(NSMutableData*)data;

/*
 * Constructs a new string for a buffer of bytes, encoded using the UCS2 character
 * encoding.
 */

+ (NSString*) forUCS2Buffer:(NSMutableData*)data;

/*
 * Constructs a new string for an array or characters.
 */

+ (NSString*) forCharArray:(NSMutableArray*)chars offset:(int)offset count:(int)count;

/*
 * Converts a boolean value to a string. The resulting string will be either "true"
 * or "false", depending of the boolean value.
 */

+ (NSString*) forBoolean:(BOOL)vv;

/*
 * Converts an integer value to a string. The resulting string will be a string
 * representation of the value of the integer using the "base-10" decimal notation.
 */

+ (NSString*) forInteger:(int)vv;

/*
 * Converts a long integer value to a string. The resulting string will be a string
 * representation of the value of the integer using the "base-10" decimal notation.
 */

+ (NSString*) forLong:(long long)vv;

/*
 * Converts an integer value to a string while ensuring that the length of the
 * resulting string will reach or exceed the given "length". If the length of the
 * string naturally is less than the given length, then "padding" characters will
 * be prepended to the string in order to make the string long enough. The default
 * padding character is "0", but can be customized with the "paddingString"
 * parameter. eg. String.forIntegerWithPadding(9, 3, "0") would yield "009". eg.
 * String.forIntegerWithPadding(10, 4, " ") would yield " 10".
 */

+ (NSString*) forIntegerWithPadding:(int)vv length:(int)length paddingString:(NSString*)paddingString;

/*
 * Converts an integer value to a string using the "base-16" or hexadecimal
 * notation.
 */

+ (NSString*) forIntegerHex:(int)vv;

/*
 * Converts a character to a string. The result will be a single-character string.
 */

+ (NSString*) forCharacter:(int)vv;

/*
 * Converts a floating point value to a string.
 */

+ (NSString*) forFloat:(float)vv;

/*
 * Converts a double-precision floating point value to a string.
 */

+ (NSString*) forDouble:(double)vv;

/*
 * Converts a string to a buffer of bytes, encoded using the UTF8 encoding.
 */

+ (NSMutableData*) toUTF8Buffer:(NSString*)str;

/*
 * Converts a string to a buffer of bytes, encoded using the specified "charset" as
 * the character set or encoding. Vaid options for "charset" are platform
 * dependent, and would includes values such as UTF8, UTF16, UCS2 and ASCII. UTF8
 * encoding, however, is implemented for all platforms, and is therefore the
 * recommended character set to use.
 */

+ (NSMutableData*) toBuffer:(NSString*)str charset:(NSString*)charset;

/*
 * Gets the length of a string, representing the number of characters composing the
 * string (note: This is not the same as the number of bytes allocated to hold the
 * memory for the string).
 */

+ (int) getLength:(NSString*)str;

/*
 * Appends a string "str2" to the end of another string "str1". Either one of the
 * values may be null: If "str1" is null, the value of "str2" is returned, and if
 * "str2" is null, the value of "str1" is returned.
 */

+ (NSString*) appendStringAndString:(NSString*)str1 str2:(NSString*)str2;

/*
 * Appends an integer value "intvalue" to the end of string "str". If the original
 * string is null, then a new string is returned, representing only the integer
 * value.
 */

+ (NSString*) appendStringAndSignedInteger:(NSString*)str intvalue:(int)intvalue;

/*
 * Appends a character value "charvalue" to the end of string "str". If the
 * original string is null, then a new string is returned, representing only the
 * character value.
 */

+ (NSString*) appendStringAndCharacter:(NSString*)str charvalue:(int)charvalue;

/*
 * Appends a floating point value "floatvalue" to the end of string "str". If the
 * original string is null, then a new string is returned, representing only the
 * floating point value.
 */

+ (NSString*) appendStringAndFloat:(NSString*)str floatvalue:(float)floatvalue;

/*
 * Appends a double-precision floating point value "doublevalue" to the end of
 * string "str". If the original string is null, then a new string is returned,
 * representing only the floating point value.
 */

+ (NSString*) appendStringAndDouble:(NSString*)str doublevalue:(double)doublevalue;

/*
 * Appends a boolean value "boolvalue" to the end of string "str". If the original
 * string is null, then a new string is returned, representing only the boolean
 * value.
 */

+ (NSString*) appendStringAndBoolean:(NSString*)str boolvalue:(BOOL)boolvalue;

/*
 * Converts all characters of a string to lowercase.
 */

+ (NSString*) toLowerCase:(NSString*)str;

/*
 * Converts all characters of a string to uppercase.
 */

+ (NSString*) toUpperCase:(NSString*)str;

/*
 * Gets a character with the specified index "index" from the given string. This
 * method is deprecated: Use getChar() instead.
 */

+ (int) charAt:(NSString*)str index:(int)index;

/*
 * Gets a character with the specified index "index" from the given string.
 */

+ (int) getChar:(NSString*)str index:(int)index;

/*
 * Compares two strings, and returns true if both strings contain exactly the same
 * contents (even though they may be represented by different objects). Either of
 * the strings may be null, in which case the comparison always results to false.
 */

+ (BOOL) equals:(NSString*)str1 str2:(NSString*)str2;

/*
 * Compares two strings for equality (like equals()) while considering uppercase
 * and lowercase versions of the same character as equivalent. Eg. strings
 * "ThisIsAString" and "thisisastring" would be considered equivalent, and the
 * result of comparison would be "true".
 */

+ (BOOL) equalsIgnoreCase:(NSString*)str1 str2:(NSString*)str2;

/*
 * Compares two strings, and returns an integer value representing their sorting
 * order. The return value 0 indicates that the two strings are equivalent. A
 * negative return value (< 0) indicates that "str1" is less than "str2", and a
 * positive return value (> 0) indicates that "str1" is greater than "str2". If
 * either "str1" or "str2" is null, the comparison yields the value 0.
 */

+ (int) compare:(NSString*)str1 str2:(NSString*)str2;

/*
 * Compares strings exactly like compareTo(), but this method considers uppercase
 * and lowercase versions of each character as equivalent.
 */

+ (int) compareToIgnoreCase:(NSString*)str1 str2:(NSString*)str2;

/*
 * Gets a hash code version of the string as an integer.
 */

+ (int) getHashCode:(NSString*)str;

/*
 * Gets the first index of a given character "c" in string "str", starting from
 * index "start". This method is deprecated, use getIndexOf() instead.
 */

+ (int) indexOfWithStringAndCharacterAndSignedInteger:(NSString*)str c:(int)c start:(int)start;

/*
 * Gets the first index of a given character "c" in string "str", starting from
 * index "start".
 */

+ (int) getIndexOfWithStringAndCharacterAndSignedInteger:(NSString*)str c:(int)c start:(int)start;

/*
 * Gets the first index of a given substring "s" in string "str", starting from
 * index "start". This method is deprecated, use getIndexOf() instead.
 */

+ (int) indexOfWithStringAndStringAndSignedInteger:(NSString*)str s:(NSString*)s start:(int)start;

/*
 * Gets the first index of a given substring "s" in string "str", starting from
 * index "start".
 */

+ (int) getIndexOfWithStringAndStringAndSignedInteger:(NSString*)str s:(NSString*)s start:(int)start;

/*
 * Gets the last index of a given character "c" in string "str", starting from
 * index "start". This method is deprecated, use getLastIndexOf() instead.
 */

+ (int) lastIndexOfWithStringAndCharacterAndSignedInteger:(NSString*)str c:(int)c start:(int)start;

/*
 * Gets the last index of a given character "c" in string "str", starting from
 * index "start".
 */

+ (int) getLastIndexOfWithStringAndCharacterAndSignedInteger:(NSString*)str c:(int)c start:(int)start;

/*
 * Gets the last index of a given substring "s" in string "str", starting from
 * index "start". This method is deprecated, use getLastIndexOf() instead.
 */

+ (int) lastIndexOfWithStringAndStringAndSignedInteger:(NSString*)str s:(NSString*)s start:(int)start;

/*
 * Gets the last index of a given substring "s" in string "str", starting from
 * index "start".
 */

+ (int) getLastIndexOfWithStringAndStringAndSignedInteger:(NSString*)str s:(NSString*)s start:(int)start;

/*
 * Gets a substring of "str", starting from index "start". This method is
 * deprecated, use getSubString() instead.
 */

+ (NSString*) subStringWithStringAndSignedInteger:(NSString*)str start:(int)start;

/*
 * Gets a substring of "str", starting from index "start".
 */

+ (NSString*) getSubStringWithStringAndSignedInteger:(NSString*)str start:(int)start;

/*
 * Gets a substring of "str", starting from index "start" and with a maximum length
 * of "length". This method is deprecated, use getSubString() instead.
 */

+ (NSString*) subStringWithStringAndSignedIntegerAndSignedInteger:(NSString*)str start:(int)start length:(int)length;

/*
 * Gets a substring of "str", starting from index "start" and with a maximum length
 * of "length".
 */

+ (NSString*) getSubStringWithStringAndSignedIntegerAndSignedInteger:(NSString*)str start:(int)start length:(int)length;

/*
 * Checks is the string "str1" contains a substring "str2". Returns true if the
 * substring is found.
 */

+ (BOOL) contains:(NSString*)str1 str2:(NSString*)str2;

/*
 * Checks if the string "str1" starts with the complete contents of "str2". If the
 * "offset" parameter is supplied an is greater than zero, the checking does not
 * start from the beginning of "str1" but from the given character index.
 */

+ (BOOL) startsWith:(NSString*)str1 str2:(NSString*)str2 offset:(int)offset;

/*
 * Checks if the string "str1" ends with the complete contents of "str2".
 */

+ (BOOL) endsWith:(NSString*)str1 str2:(NSString*)str2;

/*
 * Strips (or trims) the given string "str" by removing all blank characters from
 * both ends (the beginning and the end) of the string.
 */

+ (NSString*) strip:(NSString*)str;

/*
 * Replaces all instances of "oldChar" with the value of "newChar" in the given
 * string "str". The return value is a new string where the changes have been
 * effected. The original string remains unchanged.
 */

+ (NSString*) replaceStringAndCharacterAndCharacter:(NSString*)str oldChar:(int)oldChar newChar:(int)newChar;

/*
 * Replaces all instances of the substring "target" with the value of "replacement"
 * in the given string "str". The return value is a new string where the changes
 * have been effected. The original string remains unchanged.
 */

+ (NSString*) replaceStringAndStringAndString:(NSString*)str target:(NSString*)target replacement:(NSString*)replacement;

/*
 * Converts the string "str" to an array of characters.
 */

+ (NSMutableArray*) toCharArray:(NSString*)str;

/*
 * Splits the string "str" to a vector of strings, cutting the original string at
 * each instance of the character "delim". If the value of "max" is supplied and is
 * given a value greater than 0, then the resulting vector will only have a maximum
 * of "max" entries. If the delimiter character appears beyond the maximum entries,
 * the last entry in the vector will be the complete remainder of the original
 * string, including the remaining delimiter characters.
 */

+ (NSMutableArray*) split:(NSString*)str delim:(int)delim max:(int)max;

/*
 * Checks if the given string is fully an integer (no other characters appear in
 * the string).
 */

+ (BOOL) isInteger:(NSString*)str;

/*
 * Converts the string to an integer. If the string does not represent a valid
 * integer, than the value "0" is returned. Eg. toInteger("99") = 99 Eg.
 * toInteger("asdf") = 0
 */

+ (int) toInteger:(NSString*)str;

/*
 * Converts the string to a long integer. If the string does not represent a valid
 * integer, than the value "0" is returned. Eg. toLong("99") = 99 Eg.
 * toLong("asdf") = 0
 */

+ (long long) toLong:(NSString*)str;

/*
 * Converts the string to an integer, while treating the string as a hexadecimal
 * representation of a number, eg. toIntegerFromHex("a") = 10
 */

+ (int) toIntegerFromHex:(NSString*)str;

/*
 * Converts the string to a double-precision floating point number. If the string
 * does not contain a valid representation of a floating point number, then the
 * value "0.0" is returned.
 */

+ (double) toDouble:(NSString*)str;

/*
 * Iterates the string "string" character by character by using an instance of
 * CharacterIterator.
 */

+ (id<CapeCharacterIterator>) iterate:(NSString*)_x_string;

/*
 * Creates a new string that contains the same contents as "string", but with all
 * characters appearing in reverse order.
 */

+ (NSString*) reverse:(NSString*)_x_string;

/*
 * Iterates the string "string" in reverse order (starting from the end, moving
 * towards the beginning).
 */

+ (id<CapeCharacterIterator>) iterateReverse:(NSString*)_x_string;

/*
 * Creates a new string based on "string" that is at least "length" characters
 * long. If the original string is shorter, it will be padded to the desired length
 * by adding instances of paddingCharacter (default of which is the space
 * character). The "aling" attribute may be either -1, 0 or 1, and determines if
 * the padding characters willb e added to the end, both sides or to the beginning,
 * respectively.
 */

+ (NSString*) padToLength:(NSString*)_x_string length:(int)length align:(int)align paddingCharacter:(int)paddingCharacter;

/*
 * Splits the given string "str" to a vector of multiple strings, cutting the
 * string at each instance of the "delim" character where the delim does not appear
 * enclosed in either double quotes or single quotes. Eg.
 * quotedStringToVector("first 'second third'", ' ') => [ "first", "second third" ]
 */

+ (NSMutableArray*) quotedStringToVector:(NSString*)str delim:(int)delim;

/*
 * Parses the string "str", splitting it to multiple strings using
 * quotedStringToVector(), and then further processing it to key/value pairs,
 * splitting each string at the equal sign '=' and adding the entries to a map.
 */

+ (NSMutableDictionary*) quotedStringToMap:(NSString*)str delim:(int)delim;

/*
 * Combines a vector of strings to a single string, incorporating the "delim"
 * character between each string in the vector. If the "unique" variable is set to
 * "true", only one instance of each unique string will be appended to the
 * resulting string.
 */

+ (NSString*) combine:(NSMutableArray*)strings delim:(int)delim unique:(BOOL)unique;

/*
 * Vaidates a string character-by-character, calling the supplied function to
 * determine the validity of each character. Returns true if the entire string was
 * validated, false if not.
 */

+ (BOOL) validateCharacters:(NSString*)str validator:(BOOL(^)(int))validator;
@end
