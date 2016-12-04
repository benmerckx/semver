package semver;

using tink.CoreApi;

typedef Range = Array<Condition>;

@:forward
abstract RangeSet(Array<Range>) from Array<Range> {

  public function new()
    this = [];

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