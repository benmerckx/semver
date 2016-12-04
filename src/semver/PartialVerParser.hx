package semver;

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
    version.metadata = identifiers('+');
    return version;
  }
  
  function optionalVersionNumber(first = false): Option<Int>
    return 
      if (done())
        None;
      else if (!first && !allowHere('.')) 
        None;
      else if (allowHere('*') || allowHere('x') || allowHere('X'))
        None;
      else
        Some(versionNumber(true));
    
}