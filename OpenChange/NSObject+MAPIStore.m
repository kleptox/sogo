/* NSObject+MAPIStore.m - this file is part of SOGo
 *
 * Copyright (C) 2011 Inverse inc
 *
 * Author: Wolfgang Sourdeau <wsourdeau@inverse.ca>
 *
 * This file is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#import <NGExtensions/NSObject+Logs.h>

#import "NSData+MAPIStore.h"
#import "NSCalendarDate+MAPIStore.h"
#import "NSValue+MAPIStore.h"
#import "NSString+MAPIStore.h"

#import "NSObject+MAPIStore.h"

#undef DEBUG
#include <mapistore/mapistore.h>

@implementation NSObject (MAPIStoreDataTypes)

- (enum MAPISTATUS) getMAPIValue: (void **) data
                          forTag: (enum MAPITAGS) propTag
                        inMemCtx: (TALLOC_CTX *) memCtx
{
  uint16_t valueType;
  enum MAPISTATUS rc;

  rc = MAPI_E_SUCCESS;

  // [self logWithFormat: @"property %.8x found", propTag];
  valueType = (propTag & 0xffff);
  switch (valueType)
    {
    case PT_NULL:
      *data = NULL;
      break;
    case PT_SHORT:
      *data = [(NSNumber *) self asShortInMemCtx: memCtx];
      break;
    case PT_LONG:
      *data = [(NSNumber *) self asLongInMemCtx: memCtx];
      break;
    case PT_BOOLEAN:
      *data = [(NSNumber *) self asBooleanInMemCtx: memCtx];
      break;
    case PT_DOUBLE:
      *data = [(NSNumber *) self asDoubleInMemCtx: memCtx];
      break;
    case PT_UNICODE:
    case PT_STRING8:
      *data = [(NSString *) self asUnicodeInMemCtx: memCtx];
      break;
    case PT_SYSTIME:
      *data = [(NSCalendarDate * ) self asFileTimeInMemCtx: memCtx];
      break;
    case PT_BINARY:
      *data = [(NSData *) self asShortBinaryInMemCtx: memCtx];
      break;
    case PT_CLSID:
      *data = [(NSData *) self asGUIDInMemCtx: memCtx];
      break;

    default:
      [self errorWithFormat: @"object type not handled: %d (0x%.4x)",
            valueType, valueType];
      *data = NULL;
      rc = MAPI_E_NO_SUPPORT;
    }

  return rc;
}

@end
