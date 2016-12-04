package semver;

import semver.RangeSet;

class RangeSetParser extends ConditionParser {

  public function rangeSet(): RangeSet
    return [
      do range()
      while (!done())
    ];
  
  public function range(): Range
    return [
      do condition()
      while (!allow('||') && !done())
    ];

}