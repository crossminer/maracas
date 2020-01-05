package com.hubspot.algebra;

import java.lang.Override;
import java.lang.SuppressWarnings;
import java.util.Optional;
import java.util.function.Function;
import java.util.function.Supplier;

public final class Results {
  private Results() {
  }

  public static <SUCCESS_TYPE, ERROR_TYPE> Result<SUCCESS_TYPE, ERROR_TYPE> err(ERROR_TYPE err) {
    return new Err<>(err);
  }

  public static <SUCCESS_TYPE, ERROR_TYPE> Result<SUCCESS_TYPE, ERROR_TYPE> ok(SUCCESS_TYPE ok) {
    return new Ok<>(ok);
  }

  public static <SUCCESS_TYPE, ERROR_TYPE> Result<SUCCESS_TYPE, ERROR_TYPE> lazy(Supplier<Result<SUCCESS_TYPE, ERROR_TYPE>> result) {
    return new Lazy<>(result);
  }

  @SuppressWarnings("unchecked")
  public static <SUCCESS_TYPE, ERROR_TYPE> CasesMatchers.TotalMatcher_Err<SUCCESS_TYPE, ERROR_TYPE> cases() {
    return (CasesMatchers.TotalMatcher_Err<SUCCESS_TYPE, ERROR_TYPE>) CasesMatchers.totalMatcher_Err;
  }

  public static <SUCCESS_TYPE, ERROR_TYPE> CaseOfMatchers.TotalMatcher_Err<SUCCESS_TYPE, ERROR_TYPE> caseOf(Result<SUCCESS_TYPE, ERROR_TYPE> result) {
    return new CaseOfMatchers.TotalMatcher_Err<SUCCESS_TYPE, ERROR_TYPE>(result);
  }

  public static <SUCCESS_TYPE, ERROR_TYPE> Optional<ERROR_TYPE> getErr(Result<SUCCESS_TYPE, ERROR_TYPE> result) {
    return result.match((err) -> Optional.of(err),
    (ok) -> Optional.empty());}

  public static <SUCCESS_TYPE, ERROR_TYPE> Optional<SUCCESS_TYPE> getOk(Result<SUCCESS_TYPE, ERROR_TYPE> result) {
    return result.match((err) -> Optional.empty(),
    (ok) -> Optional.of(ok));}

  public static <SUCCESS_TYPE, ERROR_TYPE, RERROR_TYPE> Function<Result<SUCCESS_TYPE, ERROR_TYPE>, Result<SUCCESS_TYPE, RERROR_TYPE>> setErr(RERROR_TYPE newErr) {
    return modErr(__ -> newErr);
  }

  public static <SUCCESS_TYPE, ERROR_TYPE, RERROR_TYPE> Function<Result<SUCCESS_TYPE, ERROR_TYPE>, Result<SUCCESS_TYPE, RERROR_TYPE>> modErr(Function<ERROR_TYPE, RERROR_TYPE> errMod) {
    return result -> result.match((err) -> err(errMod.apply(err)),
        Results::ok);
  }

  public static <SUCCESS_TYPE, ERROR_TYPE, RSUCCESS_TYPE> Function<Result<SUCCESS_TYPE, ERROR_TYPE>, Result<RSUCCESS_TYPE, ERROR_TYPE>> setOk(RSUCCESS_TYPE newOk) {
    return modOk(__ -> newOk);
  }

  public static <SUCCESS_TYPE, ERROR_TYPE, RSUCCESS_TYPE> Function<Result<SUCCESS_TYPE, ERROR_TYPE>, Result<RSUCCESS_TYPE, ERROR_TYPE>> modOk(Function<SUCCESS_TYPE, RSUCCESS_TYPE> okMod) {
    return result -> result.match(Results::err,
        (ok) -> ok(okMod.apply(ok)));
  }

  private static final class Err<SUCCESS_TYPE, ERROR_TYPE> extends Result<SUCCESS_TYPE, ERROR_TYPE> {
    private final ERROR_TYPE err;

    Err(ERROR_TYPE err) {
      this.err = err;
    }

    @Override
    public <R> R match(Function<ERROR_TYPE, R> err, Function<SUCCESS_TYPE, R> ok) {
      return err.apply(this.err);
    }
  }

  private static final class Ok<SUCCESS_TYPE, ERROR_TYPE> extends Result<SUCCESS_TYPE, ERROR_TYPE> {
    private final SUCCESS_TYPE ok;

    Ok(SUCCESS_TYPE ok) {
      this.ok = ok;
    }

    @Override
    public <R> R match(Function<ERROR_TYPE, R> err, Function<SUCCESS_TYPE, R> ok) {
      return ok.apply(this.ok);
    }
  }

  private static final class Lazy<SUCCESS_TYPE, ERROR_TYPE> extends Result<SUCCESS_TYPE, ERROR_TYPE> {
    private volatile Supplier<Result<SUCCESS_TYPE, ERROR_TYPE>> expression;

    private Result<SUCCESS_TYPE, ERROR_TYPE> evaluation;

    Lazy(Supplier<Result<SUCCESS_TYPE, ERROR_TYPE>> result) {
      this.expression = result;
    }

    private synchronized Result<SUCCESS_TYPE, ERROR_TYPE> _evaluate() {
      Supplier<Result<SUCCESS_TYPE, ERROR_TYPE>> e = expression;
      if (e != null) {
        evaluation = e.get();
        expression = null;
      }
      return evaluation;
    }

    @Override
    public <R> R match(Function<ERROR_TYPE, R> err, Function<SUCCESS_TYPE, R> ok) {
      return (this.expression == null ? this.evaluation : _evaluate()).match(err, ok);
    }
  }

  public static class CasesMatchers {
    private static final TotalMatcher_Err<?, ?> totalMatcher_Err = new TotalMatcher_Err<>();

    private CasesMatchers() {
    }

    public static final class TotalMatcher_Err<SUCCESS_TYPE, ERROR_TYPE> {
      TotalMatcher_Err() {
      }

      public final <R> TotalMatcher_Ok<SUCCESS_TYPE, ERROR_TYPE, R> err(Function<ERROR_TYPE, R> err) {
        return new TotalMatcher_Ok<>(err);
      }

      public final <R> TotalMatcher_Ok<SUCCESS_TYPE, ERROR_TYPE, R> err_(R r) {
        return this.err((err) -> r);
      }

      public final <R> PartialMatcher<SUCCESS_TYPE, ERROR_TYPE, R> ok(Function<SUCCESS_TYPE, R> ok) {
        return new PartialMatcher<>(null, ok);
      }

      public final <R> PartialMatcher<SUCCESS_TYPE, ERROR_TYPE, R> ok_(R r) {
        return this.ok((ok) -> r);
      }
    }

    public static final class TotalMatcher_Ok<SUCCESS_TYPE, ERROR_TYPE, R> extends PartialMatcher<SUCCESS_TYPE, ERROR_TYPE, R> {
      TotalMatcher_Ok(Function<ERROR_TYPE, R> err) {
        super(err, null);
      }

      public final Function<Result<SUCCESS_TYPE, ERROR_TYPE>, R> ok(Function<SUCCESS_TYPE, R> ok) {
        Function<ERROR_TYPE, R> err = super.err;
        return result -> result.match(err, ok);
      }

      public final Function<Result<SUCCESS_TYPE, ERROR_TYPE>, R> ok_(R r) {
        return this.ok((ok) -> r);
      }
    }

    public static class PartialMatcher<SUCCESS_TYPE, ERROR_TYPE, R> {
      private final Function<ERROR_TYPE, R> err;

      private final Function<SUCCESS_TYPE, R> ok;

      PartialMatcher(Function<ERROR_TYPE, R> err, Function<SUCCESS_TYPE, R> ok) {
        this.err = err;
        this.ok = ok;
      }

      public final Function<Result<SUCCESS_TYPE, ERROR_TYPE>, R> otherwise(Supplier<R> otherwise) {
        Function<ERROR_TYPE, R> err = (this.err != null) ? this.err : (err_) -> otherwise.get();
        Function<SUCCESS_TYPE, R> ok = (this.ok != null) ? this.ok : (ok_) -> otherwise.get();
        return result -> result.match(err, ok);
      }

      public final Function<Result<SUCCESS_TYPE, ERROR_TYPE>, R> otherwise_(R r) {
        return this.otherwise(() -> r);
      }

      public final Function<Result<SUCCESS_TYPE, ERROR_TYPE>, Optional<R>> otherwiseEmpty() {
        Function<ERROR_TYPE, Optional<R>> err = (this.err != null) ? (err_) -> Optional.of(this.err.apply(err_))
            : (err_) -> Optional.empty();
        Function<SUCCESS_TYPE, Optional<R>> ok = (this.ok != null) ? (ok_) -> Optional.of(this.ok.apply(ok_))
            : (ok_) -> Optional.empty();
        return result -> result.match(err, ok);
      }
    }
  }

  public static class CaseOfMatchers {
    private CaseOfMatchers() {
    }

    public static final class TotalMatcher_Err<SUCCESS_TYPE, ERROR_TYPE> {
      private final Result<SUCCESS_TYPE, ERROR_TYPE> _result;

      TotalMatcher_Err(Result<SUCCESS_TYPE, ERROR_TYPE> _result) {
        this._result = _result;
      }

      public final <R> TotalMatcher_Ok<SUCCESS_TYPE, ERROR_TYPE, R> err(Function<ERROR_TYPE, R> err) {
        return new TotalMatcher_Ok<>(this._result, err);
      }

      public final <R> TotalMatcher_Ok<SUCCESS_TYPE, ERROR_TYPE, R> err_(R r) {
        return this.err((err) -> r);
      }

      public final <R> PartialMatcher<SUCCESS_TYPE, ERROR_TYPE, R> ok(Function<SUCCESS_TYPE, R> ok) {
        return new PartialMatcher<>(this._result, null, ok);
      }

      public final <R> PartialMatcher<SUCCESS_TYPE, ERROR_TYPE, R> ok_(R r) {
        return this.ok((ok) -> r);
      }
    }

    public static final class TotalMatcher_Ok<SUCCESS_TYPE, ERROR_TYPE, R> extends PartialMatcher<SUCCESS_TYPE, ERROR_TYPE, R> {
      TotalMatcher_Ok(Result<SUCCESS_TYPE, ERROR_TYPE> _result, Function<ERROR_TYPE, R> err) {
        super(_result, err, null);
      }

      public final R ok(Function<SUCCESS_TYPE, R> ok) {
        Function<ERROR_TYPE, R> err = super.err;
        return ((PartialMatcher<SUCCESS_TYPE, ERROR_TYPE, R>) this)._result.match(err, ok);
      }

      public final R ok_(R r) {
        return this.ok((ok) -> r);
      }
    }

    public static class PartialMatcher<SUCCESS_TYPE, ERROR_TYPE, R> {
      private final Result<SUCCESS_TYPE, ERROR_TYPE> _result;

      private final Function<ERROR_TYPE, R> err;

      private final Function<SUCCESS_TYPE, R> ok;

      PartialMatcher(Result<SUCCESS_TYPE, ERROR_TYPE> _result, Function<ERROR_TYPE, R> err,
          Function<SUCCESS_TYPE, R> ok) {
        this._result = _result;
        this.err = err;
        this.ok = ok;
      }

      public final R otherwise(Supplier<R> otherwise) {
        Function<ERROR_TYPE, R> err = (this.err != null) ? this.err : (err_) -> otherwise.get();
        Function<SUCCESS_TYPE, R> ok = (this.ok != null) ? this.ok : (ok_) -> otherwise.get();
        return this._result.match(err, ok);
      }

      public final R otherwise_(R r) {
        return this.otherwise(() -> r);
      }

      public final Optional<R> otherwiseEmpty() {
        Function<ERROR_TYPE, Optional<R>> err = (this.err != null) ? (err_) -> Optional.of(this.err.apply(err_))
            : (err_) -> Optional.empty();
        Function<SUCCESS_TYPE, Optional<R>> ok = (this.ok != null) ? (ok_) -> Optional.of(this.ok.apply(ok_))
            : (ok_) -> Optional.empty();
        return this._result.match(err, ok);
      }
    }
  }
}
