#
#
#            Nim's Runtime Library
#        (c) Copyright 2016 Dominik Picheta
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#


import tables, httpcore, strutils
export httpcore

type
  ResponseHeaders* = object
    table: TableRef[string, seq[string]]


proc getTables*(headers: ResponseHeaders): TableRef[string, seq[string]] =
  headers.table

proc toCaseInsensitive(headers: ResponseHeaders, s: string): string {.inline.} =
  result = toLowerAscii(s)

proc initResponseHeaders*(): ResponseHeaders =
  ## Returns a new ``ResponseHeaders`` object.
  result.table = newTable[string, seq[string]]()

proc initResponseHeaders*(keyValuePairs:
    openArray[tuple[key: string, val: string]]): ResponseHeaders =
  ## Returns a new ``ResponseHeaders`` object from an array.
  result.table = newTable[string, seq[string]]()
  for pair in keyValuePairs:
    let key = result.toCaseInsensitive(pair.key)
    if key in result.table:
      result.table[key].add(pair.val)
    else:
      result.table[key] = @[pair.val]

proc `$`*(headers: ResponseHeaders): string =
  result = $headers.table

proc clear*(headers: ResponseHeaders) =
  headers.table.clear()

proc `[]`*(headers: ResponseHeaders, key: string): seq[string] =
  ## Returns the values associated with the given ``key``. If there are
  ## no values associated with the key, an exception is raised.
  ##
  ## To access multiple values of a key, use the overloaded ``[]`` below or
  ## to get all of them access the ``table`` field directly.
  result = headers.table[headers.toCaseInsensitive(key)]

proc `[]`*(headers: ResponseHeaders, key: string, i: int): string =
  ## Returns the ``i``'th value associated with the given key. If there are
  ## no values associated with the key or the ``i``'th value doesn't exist,
  ## an exception is raised.
  result = headers.table[key][i]

proc `[]=`*(headers: ResponseHeaders, key, value: string) =
  ## Sets the header entries associated with ``key`` to the specified value.
  ## Replaces any existing values.
  headers.table[headers.toCaseInsensitive(key)] = @[value]

proc `[]=`*(headers: ResponseHeaders, key: string, value: seq[string]) =
  ## Sets the header entries associated with ``key`` to the specified list of values.
  ## Replaces any existing values.
  headers.table[headers.toCaseInsensitive(key)] = value

proc add*(headers: ResponseHeaders, key, value: string) =
  ## Adds the specified value to the specified key. Appends to any existing
  ## values associated with the key.
  if not headers.table.hasKey(headers.toCaseInsensitive(key)):
    headers.table[headers.toCaseInsensitive(key)] = @[value]
  else:
    headers.table[headers.toCaseInsensitive(key)].add(value)

proc del*(headers: ResponseHeaders, key: string) =
  ## Delete the header entries associated with ``key``
  headers.table.del(headers.toCaseInsensitive(key))

iterator pairs*(headers: ResponseHeaders): tuple[key, value: string] =
  ## Yields each key, value pair.
  for k, v in headers.table:
    for value in v:
      yield (k, value)

proc hasKey*(headers: ResponseHeaders, key: string): bool =
  result = headers.table.hasKey(headers.toCaseInsensitive(key))

proc getOrDefault*(headers: ResponseHeaders, key: string,
    default = @[""]): seq[string] =
  ## Returns the values associated with the given ``key``. If there are no
  ## values associated with the key, then ``default`` is returned.
  if headers.hasKey(key):
    result = headers[key]
  else:
    result = default

proc len*(headers: ResponseHeaders): int = 
  result = headers.table.len
