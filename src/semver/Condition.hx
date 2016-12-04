package semver;

enum Op {
  GtEq;
  LtEq;
  Eq;
  Gt;
  Lt;
  Tilde;
  Caret;
}

enum ConditionData {
    Hyphen(from: PartialVer, to: PartialVer);
    Comparator(op: Op, version: PartialVer);
}

abstract Condition(ConditionData) from ConditionData {

  public function test(version: SemVer)
    return switch this {
      case Hyphen(from, to):
        version >= from && version <= to;
      case Comparator(op, partial):
        switch op {
          case GtEq: version >= partial;
          case LtEq: version <= partial;
          case Eq: version == partial;
          case Gt: version > partial;
          case Lt: version < partial;
          case Tilde:
            if (partial.major.match(None)) {
              true;
            } else {
              var upper = partial.clone();
              switch partial.minor {
                case Some(v): upper.minor = Some(v+1);
                case None: switch partial.major {
                  case Some(v): upper.major = Some(v+1);
                  default:
                }
              }
              version >= partial && version < upper;
            }
          case Caret:
            if (partial.major.match(None)) {
              true;
            } else {
              var lower = partial.versions()
                .map(function (version)
                  return switch version {
                    case None: 0;
                    case Some(v): v;
                  }
                );
              var upper = [], end = false;
              for (version in lower)
                if (!end && version > 0) {
                  upper.push(version + 1);
                  end = true;
                } else {
                  upper.push(0);
                }
              
              var min: PartialVer = lower, max: PartialVer = upper;
              min.prerelease = max.prerelease = partial.prerelease;
              version >= min && version < max;
            }
        }
    }

  @:from
  static function fromString(str: String)
    return new ConditionParser(str).condition();
  
  @:to
  public function toString(): String
    return switch this {
      case Hyphen(from, to): '$from - $to';
      case Comparator(op, version): '${formatOp(op)}$version';
    }

  function formatOp(op: Op)
    return switch op {
      case GtEq: '>=';
      case LtEq: '<=';
      case Eq: '';
      case Gt: '>';
      case Lt: '<';
      case Tilde: '~';
      case Caret: '^';
    }
}