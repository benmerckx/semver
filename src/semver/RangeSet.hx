package semver;

using tink.CoreApi;
using Lambda;

@:forward
abstract Range(Array<Condition>) from Array<Condition> {

  public function test(version: SemVer)
    return this.fold(function(condition, prev) 
      return prev && condition.test(version),
    true);

}

@:forward
abstract RangeSet(Array<Range>) from Array<Range> {

  public function new()
    this = [];

  public function satisfies(version: SemVer)
    return this.fold(function(range, prev) 
      return prev || range.test(version), 
    false);

  @:from
  static function fromString(str: String)
    return new RangeSetParser(str).rangeSet();
  
  @:to
  public function toString(): String
    return this
      .map(function(range) 
        return range.map(function(condition)
          return condition.toString()
        ).join(' '))
      .join(' || ');

}