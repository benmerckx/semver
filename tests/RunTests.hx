

import semver.RangeSet;
import semver.PartialVer;
import semver.Condition;
import tink.parse.StringSlice;

class RunTests {

  static function main() {
    trace(('1': PartialVer));
    trace(('1.2.x': PartialVer));
    trace(('1.2.1-alpha.1': PartialVer));
    trace(('1.2-abc': PartialVer));
    trace(('1 - 2': Condition));
    trace(('>=1.2': Condition));
    trace(('<2.3': Condition));
    trace(('=1.52.6': Condition));
    trace(('1.2.6': Condition));
    trace(('1': RangeSet));
    trace(('~1.2.6 ^12  || 1.2 - 5.3 > 5   ': RangeSet));
    travix.Logger.exit(0);
  }
  
}