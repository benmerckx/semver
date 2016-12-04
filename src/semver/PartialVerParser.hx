package semver;

using tink.CoreApi;

class PartialVerParser extends SemVerParser {
    
  public function partial(): PartialVer {
    var version = new PartialVer();
    function done(remaining) {
      allowAny(remaining);
      return version;
    }
    version.major = optionalVersionNumber(true);
    if (version.major.match(None)) return done(2);
    version.minor = optionalVersionNumber(false);
    if (version.minor.match(None)) return done(1);
    version.patch = optionalVersionNumber(false);
    if (version.patch.match(None)) return version;
    version.prerelease = identifiers('-');
    version.metadata = identifiers('+');
    return version;
  }

  function allowAny(amount: Int)
    while (amount-- > 0)
      if (allowHere('.')) any()
      else break;

  function any()
    return allowHere('*') || allowHere('x') || allowHere('X');
  
  function optionalVersionNumber(first = false): Option<Int>
    return 
      if (done())
        None;
      else if (!first && !allowHere('.')) 
        None;
      else if (any())
        None;
      else
        Some(versionNumber(true));
    
}
