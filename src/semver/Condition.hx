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
          case Tilde: throw 'Todo';
          case Caret: throw 'Todo';
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