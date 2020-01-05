package com.hubspot.algebra;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.hubspot.immutables.exceptions.InvalidImmutableStateException;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import java.util.Objects;
import java.util.Optional;
import javax.annotation.Generated;
import javax.annotation.Nullable;
import javax.annotation.ParametersAreNonnullByDefault;
import javax.annotation.concurrent.Immutable;
import javax.annotation.concurrent.NotThreadSafe;

/**
 * Immutable implementation of {@link AbstractHttpResultWrapper}.
 * <p>
 * Use the builder to create immutable instances:
 * {@code HttpResultWrapper.<T, E>builder()}.
 */
@SuppressWarnings("all")
@SuppressFBWarnings
@ParametersAreNonnullByDefault
@Generated({"Immutables.generator", "AbstractHttpResultWrapper<T, E>"})
@Immutable
public final class HttpResultWrapper<T, E> extends AbstractHttpResultWrapper<T, E> {
  private final @Nullable T okResultMaybe;
  private final @Nullable E errResultMaybe;
  private final int httpStatusCode;

  private HttpResultWrapper(HttpResultWrapper.Builder<T, E> builder) {
    this.okResultMaybe = builder.okResultMaybe;
    this.errResultMaybe = builder.errResultMaybe;
    this.httpStatusCode = builder.httpStatusCodeIsSet()
        ? builder.httpStatusCode
        : super.getHttpStatusCode();
  }

  private HttpResultWrapper(
      @Nullable T okResultMaybe,
      @Nullable E errResultMaybe,
      int httpStatusCode) {
    this.okResultMaybe = okResultMaybe;
    this.errResultMaybe = errResultMaybe;
    this.httpStatusCode = httpStatusCode;
  }

  /**
   * @return The value of the {@code okResultMaybe} attribute
   */
  @JsonProperty
  @Override
  public Optional<T> getOkResultMaybe() {
    return Optional.ofNullable(okResultMaybe);
  }

  /**
   * @return The value of the {@code errResultMaybe} attribute
   */
  @JsonProperty
  @Override
  public Optional<E> getErrResultMaybe() {
    return Optional.ofNullable(errResultMaybe);
  }

  /**
   * @return The value of the {@code httpStatusCode} attribute
   */
  @JsonProperty
  @Override
  public int getHttpStatusCode() {
    return httpStatusCode;
  }

  /**
   * Copy the current immutable object by setting a <i>present</i> value for the optional {@link AbstractHttpResultWrapper#getOkResultMaybe() okResultMaybe} attribute.
   * @param value The value for okResultMaybe, {@code null} is accepted as {@code java.util.Optional.empty()}
   * @return A modified copy of {@code this} object
   */
  public final HttpResultWrapper<T, E> withOkResultMaybe(@Nullable T value) {
    @Nullable T newValue = value;
    if (this.okResultMaybe == newValue) return this;
    return validate(new HttpResultWrapper<T, E>(newValue, this.errResultMaybe, this.httpStatusCode));
  }

  /**
   * Copy the current immutable object by setting an optional value for the {@link AbstractHttpResultWrapper#getOkResultMaybe() okResultMaybe} attribute.
   * A shallow reference equality check is used on unboxed optional value to prevent copying of the same value by returning {@code this}.
   * @param optional A value for okResultMaybe
   * @return A modified copy of {@code this} object
   */
  public final HttpResultWrapper<T, E> withOkResultMaybe(Optional<T> optional) {
    @Nullable T value = optional.orElse(null);
    if (this.okResultMaybe == value) return this;
    return validate(new HttpResultWrapper<T, E>(value, this.errResultMaybe, this.httpStatusCode));
  }

  /**
   * Copy the current immutable object by setting a <i>present</i> value for the optional {@link AbstractHttpResultWrapper#getErrResultMaybe() errResultMaybe} attribute.
   * @param value The value for errResultMaybe, {@code null} is accepted as {@code java.util.Optional.empty()}
   * @return A modified copy of {@code this} object
   */
  public final HttpResultWrapper<T, E> withErrResultMaybe(@Nullable E value) {
    @Nullable E newValue = value;
    if (this.errResultMaybe == newValue) return this;
    return validate(new HttpResultWrapper<T, E>(this.okResultMaybe, newValue, this.httpStatusCode));
  }

  /**
   * Copy the current immutable object by setting an optional value for the {@link AbstractHttpResultWrapper#getErrResultMaybe() errResultMaybe} attribute.
   * A shallow reference equality check is used on unboxed optional value to prevent copying of the same value by returning {@code this}.
   * @param optional A value for errResultMaybe
   * @return A modified copy of {@code this} object
   */
  public final HttpResultWrapper<T, E> withErrResultMaybe(Optional<E> optional) {
    @Nullable E value = optional.orElse(null);
    if (this.errResultMaybe == value) return this;
    return validate(new HttpResultWrapper<T, E>(this.okResultMaybe, value, this.httpStatusCode));
  }

  /**
   * Copy the current immutable object by setting a value for the {@link AbstractHttpResultWrapper#getHttpStatusCode() httpStatusCode} attribute.
   * A value equality check is used to prevent copying of the same value by returning {@code this}.
   * @param httpStatusCode A new value for httpStatusCode
   * @return A modified copy of the {@code this} object
   */
  public final HttpResultWrapper<T, E> withHttpStatusCode(int httpStatusCode) {
    if (this.httpStatusCode == httpStatusCode) return this;
    return validate(new HttpResultWrapper<T, E>(this.okResultMaybe, this.errResultMaybe, httpStatusCode));
  }

  /**
   * This instance is equal to all instances of {@code HttpResultWrapper} that have equal attribute values.
   * @return {@code true} if {@code this} is equal to {@code another} instance
   */
  @Override
  public boolean equals(@Nullable Object another) {
    if (this == another) return true;
    return another instanceof HttpResultWrapper<?, ?>
        && equalTo((HttpResultWrapper<?, ?>) another);
  }

  private boolean equalTo(HttpResultWrapper<?, ?> another) {
    return Objects.equals(okResultMaybe, another.okResultMaybe)
        && Objects.equals(errResultMaybe, another.errResultMaybe)
        && httpStatusCode == another.httpStatusCode;
  }

  /**
   * Computes a hash code from attributes: {@code okResultMaybe}, {@code errResultMaybe}, {@code httpStatusCode}.
   * @return hashCode value
   */
  @Override
  public int hashCode() {
    int h = 31;
    h = h * 17 + Objects.hashCode(okResultMaybe);
    h = h * 17 + Objects.hashCode(errResultMaybe);
    h = h * 17 + httpStatusCode;
    return h;
  }

  /**
   * Prints the immutable value {@code HttpResultWrapper} with attribute values.
   * @return A string representation of the value
   */
  @Override
  public String toString() {
    StringBuilder builder = new StringBuilder("HttpResultWrapper{");
    if (okResultMaybe != null) {
      builder.append("okResultMaybe=").append(okResultMaybe);
    }
    if (errResultMaybe != null) {
      if (builder.length() > 18) builder.append(", ");
      builder.append("errResultMaybe=").append(errResultMaybe);
    }
    if (builder.length() > 18) builder.append(", ");
    builder.append("httpStatusCode=").append(httpStatusCode);
    return builder.append("}").toString();
  }

  /**
   * Utility type used to correctly read immutable object from JSON representation.
   * @deprecated Do not use this type directly, it exists only for the <em>Jackson</em>-binding infrastructure
   */
  @Deprecated
  @JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.NONE)
  static final class Json<T, E> extends AbstractHttpResultWrapper<T, E> {
    Optional<T> okResultMaybe = Optional.empty();
    Optional<E> errResultMaybe = Optional.empty();
    int httpStatusCode;
    boolean httpStatusCodeIsSet;
    @JsonProperty
    public void setOkResultMaybe(Optional<T> okResultMaybe) {
      this.okResultMaybe = okResultMaybe;
    }
    @JsonProperty
    public void setErrResultMaybe(Optional<E> errResultMaybe) {
      this.errResultMaybe = errResultMaybe;
    }
    @JsonProperty
    public void setHttpStatusCode(int httpStatusCode) {
      this.httpStatusCode = httpStatusCode;
      this.httpStatusCodeIsSet = true;
    }
    @Override
    public Optional<T> getOkResultMaybe() { throw new UnsupportedOperationException(); }
    @Override
    public Optional<E> getErrResultMaybe() { throw new UnsupportedOperationException(); }
    @Override
    public int getHttpStatusCode() { throw new UnsupportedOperationException(); }
  }

  /**
   * @param <T> generic parameter T
   * @param <E> generic parameter E
   * @param json A JSON-bindable data structure
   * @return An immutable value type
   * @deprecated Do not use this method directly, it exists only for the <em>Jackson</em>-binding infrastructure
   */
  @Deprecated
  @JsonCreator
  static <T, E> HttpResultWrapper<T, E> fromJson(Json<T, E> json) {
    HttpResultWrapper.Builder<T, E> builder = HttpResultWrapper.<T, E>builder();
    if (json.okResultMaybe != null) {
      builder.setOkResultMaybe(json.okResultMaybe);
    }
    if (json.errResultMaybe != null) {
      builder.setErrResultMaybe(json.errResultMaybe);
    }
    if (json.httpStatusCodeIsSet) {
      builder.setHttpStatusCode(json.httpStatusCode);
    }
    return builder.build();
  }

  private static <T, E> HttpResultWrapper<T, E> validate(HttpResultWrapper<T, E> instance) {
    instance.checkIsOkOrErr();
    return instance;
  }

  /**
   * Creates an immutable copy of a {@link AbstractHttpResultWrapper} value.
   * Uses accessors to get values to initialize the new immutable instance.
   * If an instance is already immutable, it is returned as is.
   * @param <T> generic parameter T
   * @param <E> generic parameter E
   * @param instance The instance to copy
   * @return A copied immutable HttpResultWrapper instance
   */
  public static <T, E> HttpResultWrapper<T, E> copyOf(AbstractHttpResultWrapper<T, E> instance) {
    if (instance instanceof HttpResultWrapper<?, ?>) {
      return (HttpResultWrapper<T, E>) instance;
    }
    return HttpResultWrapper.<T, E>builder()
        .from(instance)
        .build();
  }

  /**
   * Creates a builder for {@link HttpResultWrapper HttpResultWrapper}.
   * @param <T> generic parameter T
   * @param <E> generic parameter E
   * @return A new HttpResultWrapper builder
   */
  public static <T, E> HttpResultWrapper.Builder<T, E> builder() {
    return new HttpResultWrapper.Builder<T, E>();
  }

  /**
   * Builds instances of type {@link HttpResultWrapper HttpResultWrapper}.
   * Initialize attributes and then invoke the {@link #build()} method to create an
   * immutable instance.
   * <p><em>{@code Builder} is not thread-safe and generally should not be stored in a field or collection,
   * but instead used immediately to create instances.</em>
   */
  @NotThreadSafe
  public static final class Builder<T, E> {
    private static final long OPT_BIT_HTTP_STATUS_CODE = 0x1L;
    private long optBits;

    private @Nullable T okResultMaybe;
    private @Nullable E errResultMaybe;
    private int httpStatusCode;

    private Builder() {
    }

    /**
     * Fill a builder with attribute values from the provided {@code AbstractHttpResultWrapper} instance.
     * Regular attribute values will be replaced with those from the given instance.
     * Absent optional values will not replace present values.
     * @param instance The instance from which to copy values
     * @return {@code this} builder for use in a chained invocation
     */
    public final Builder<T, E> from(AbstractHttpResultWrapper<T, E> instance) {
      Objects.requireNonNull(instance, "instance");
      Optional<T> okResultMaybeOptional = instance.getOkResultMaybe();
      if (okResultMaybeOptional.isPresent()) {
        setOkResultMaybe(okResultMaybeOptional);
      }
      Optional<E> errResultMaybeOptional = instance.getErrResultMaybe();
      if (errResultMaybeOptional.isPresent()) {
        setErrResultMaybe(errResultMaybeOptional);
      }
      setHttpStatusCode(instance.getHttpStatusCode());
      return this;
    }

    /**
     * Initializes the optional value {@link AbstractHttpResultWrapper#getOkResultMaybe() okResultMaybe} to okResultMaybe.
     * @param okResultMaybe The value for okResultMaybe, {@code null} is accepted as {@code java.util.Optional.empty()}
     * @return {@code this} builder for chained invocation
     */
    public final Builder<T, E> setOkResultMaybe(@Nullable T okResultMaybe) {
      this.okResultMaybe = okResultMaybe;
      return this;
    }

    /**
     * Initializes the optional value {@link AbstractHttpResultWrapper#getOkResultMaybe() okResultMaybe} to okResultMaybe.
     * @param okResultMaybe The value for okResultMaybe
     * @return {@code this} builder for use in a chained invocation
     */
    public final Builder<T, E> setOkResultMaybe(Optional<T> okResultMaybe) {
      this.okResultMaybe = okResultMaybe.orElse(null);
      return this;
    }

    /**
     * Initializes the optional value {@link AbstractHttpResultWrapper#getErrResultMaybe() errResultMaybe} to errResultMaybe.
     * @param errResultMaybe The value for errResultMaybe, {@code null} is accepted as {@code java.util.Optional.empty()}
     * @return {@code this} builder for chained invocation
     */
    public final Builder<T, E> setErrResultMaybe(@Nullable E errResultMaybe) {
      this.errResultMaybe = errResultMaybe;
      return this;
    }

    /**
     * Initializes the optional value {@link AbstractHttpResultWrapper#getErrResultMaybe() errResultMaybe} to errResultMaybe.
     * @param errResultMaybe The value for errResultMaybe
     * @return {@code this} builder for use in a chained invocation
     */
    public final Builder<T, E> setErrResultMaybe(Optional<E> errResultMaybe) {
      this.errResultMaybe = errResultMaybe.orElse(null);
      return this;
    }

    /**
     * Initializes the value for the {@link AbstractHttpResultWrapper#getHttpStatusCode() httpStatusCode} attribute.
     * <p><em>If not set, this attribute will have a default value as returned by the initializer of {@link AbstractHttpResultWrapper#getHttpStatusCode() httpStatusCode}.</em>
     * @param httpStatusCode The value for httpStatusCode 
     * @return {@code this} builder for use in a chained invocation
     */
    public final Builder<T, E> setHttpStatusCode(int httpStatusCode) {
      this.httpStatusCode = httpStatusCode;
      optBits |= OPT_BIT_HTTP_STATUS_CODE;
      return this;
    }

    /**
     * Builds a new {@link HttpResultWrapper HttpResultWrapper}.
     * @return An immutable instance of HttpResultWrapper
     * @throws com.hubspot.immutables.exceptions.InvalidImmutableStateException if any required attributes are missing
     */
    public HttpResultWrapper<T, E> build() throws InvalidImmutableStateException {
      return HttpResultWrapper.validate(new HttpResultWrapper<T, E>(this));
    }

    private boolean httpStatusCodeIsSet() {
      return (optBits & OPT_BIT_HTTP_STATUS_CODE) != 0;
    }
  }
}
