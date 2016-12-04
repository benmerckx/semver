import semver.SemVer;
import semver.RangeSet;
import semver.PartialVer;
import semver.Condition;

class RunTests {

  static function main() {
    trace(('': PartialVer));
    trace(('0.0.1': PartialVer));
    trace(('1.2.1-alpha.1': PartialVer));
    trace(('1.2-abc': PartialVer));
    trace(('1 - 2': Condition));
    trace(('1.2 5': RangeSet));
    trace(('< 2.3': Condition));
    trace(('=1.52.6': Condition));
    trace(('1.2.6': Condition));
    trace(('1': RangeSet));
    trace(('~1.2.6 ^12  || 1.2 - 5.3 > 5   ': RangeSet));
    
    var range: RangeSet = '^0.1.0';
    trace(range.satisfies('0.2.1'));
    travix.Logger.exit(0);
  }
  
}