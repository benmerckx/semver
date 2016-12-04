package semver;

import tink.parse.Char;
import semver.Condition;

using tink.CoreApi;

class ConditionParser extends PartialVerParser {
  
  public function condition(): Condition
    return switch op() {
      case Some(op):
        Comparator(op, partial());
      case None:
        var from = partial();
        if (upNext('-'.code)) {
          expect('-');
          skipIgnored();
          Hyphen(from, partial());
        } else {
          Comparator(Eq, from);
        }
    }

  function op(): Option<Op> {
    return
      if (allow('>=')) Some(GtEq)
      else if (allow('<=')) Some(LtEq)
      else if (allow('=')) Some(Eq)
      else if (allow('>')) Some(Gt)
      else if (allow('<')) Some(Lt)
      else if (allow('~')) Some(Tilde)
      else if (allow('^')) Some(Caret)
      else None;
  }

  override function doSkipIgnored()
    doReadWhile(Char.WHITE);
    
}