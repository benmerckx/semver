package semver;

import tink.parse.Char;
import tink.parse.Filter;

using tink.CoreApi;

class PartialVerParser extends SemVerParser {
    
  public function partial(): PartialVer {
    var version = new PartialVer();
    version.major = optionalVersionNumber(true);
    if (version.major.match(None)) return version;
    version.minor = optionalVersionNumber(false);
    if (version.minor.match(None)) return version;
    version.patch = optionalVersionNumber(false);
    if (version.patch.match(None)) return version;
    version.prerelease = identifiers('-');
    return version;
  }
  
  function optionalVersionNumber(first = false): Option<Int>
    return 
      if (!first && !allow('.')) 
        None;
      else if (allow('*') || allow('x') || allow('X'))
        None;
      else if (is(' '.code) || pos == max)
        None;
      else
        Some(versionNumber(true));
    
}