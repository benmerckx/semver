

import semver.SemVer;
import semver.PartialVer;
import tink.parse.StringSlice;

class RunTests {

  static function main() {
    var slice: StringSlice = 'abc';
    trace(('1.2.* ': PartialVer));
    travix.Logger.exit(0);
  }
  
}