package semver;

import tink.parse.ParserBase;
import tink.parse.StringSlice;
import tink.parse.Char;
import tink.parse.Filter;

using tink.CoreApi;

class SemVerParser extends ParserBase<IntIterator, Error> {
  
  static var FILTER_IDENT: Filter<Int> = 
    Char.DIGIT || Char.LOWER || Char.UPPER || '-'.code;
  
  public function new(source: StringSlice)
    super(source);
    
  public function version(): SemVer
    return {
      major: versionNumber(true),
      minor: versionNumber(),
      patch: versionNumber(),
      prerelease: identifiers('-'),
      metadata: identifiers('+')
    }
  
  function versionNumber(first = false): Int {
    if (!first) expectHere('.');
    var buf = source[pos ... {
      doReadWhile(Char.DIGIT);
      pos;
    }];
    if (buf.length == 0)
      die('Integer expected');
    else if (buf.length > 1 && buf.fastGet(0) == '0'.code)
      die('Version must not contain leading zeroes');
    return Std.parseInt(buf);
  }

  function identifiers(prefix: String)
    return allowHere(prefix) ? Some(readIdentifiers()) : None;

  function readIdentifiers(): Array<String>
    return [
      do readWhile(FILTER_IDENT)
      while (allowHere('.'))
    ];
  
  override function makeError(message: String, pos: IntIterator)
    return new Error(
      '$message at ' +
      '"${source[pos]}"(${@:privateAccess pos.min}-${@:privateAccess pos.max})' +
      ' in "$source"'
    );
  
  override function doMakePos(from, to)
    return from ... to;
    
}