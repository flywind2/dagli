<#import "../common.ftl" as c />
<@c.AutoGeneratedWarning />
package com.linkedin.dagli.transformer;

import com.linkedin.dagli.annotation.equality.ValueEquality;
import com.linkedin.dagli.objectio.ObjectReader;
import com.linkedin.dagli.preparer.Preparer${arity};
import com.linkedin.dagli.preparer.PreparerContext;
import com.linkedin.dagli.producer.internal.ChildProducerInternalAPI;
import com.linkedin.dagli.reducer.Reducer;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

<#assign preparedTransformerType><@c.PreparedTransformer arity /></#assign>
<#macro WrapperTransformer prepared>WrapperTransformer${arity}<#if prepared>.Prepared</#if><<@c.InputGenericArguments arity />, R, S></#macro>

<#macro Common prepared>
  <#assign wrappedType><#if prepared><@c.PreparedTransformer arity /><#else><@c.PreparableTransformer arity "?" /></#if></#assign>
  <#assign looseWrappedType><#if prepared><@c.LoosePreparedTransformer arity /><#else><@c.LoosePreparableTransformer arity "?" /></#if></#assign>
  <#assign wrapperTypeName><#if prepared>Prepared<#else>WrapperTransformer${arity}</#if></#assign>

  private static final long serialVersionUID = 1;

  protected ${wrappedType} _wrappedTransformer = null;

  @Override
  public void validate() {
    super.validate();
    _wrappedTransformer.validate();
  }

  @Override
  protected Collection<? extends Reducer<? super S>> getGraphReducers() {
    // replace the wrapper transformer with the wrapped transformer
    return Collections.singletonList((wrapper, context) -> context.replace(wrapper,
        ChildProducerInternalAPI.withInputsUnsafe(wrapper._wrappedTransformer, context.getParents(wrapper))));
  }

  @Override
  protected boolean hasAlwaysConstantResult() {
    return _wrappedTransformer.internalAPI().hasAlwaysConstantResult();
  }

  /**
   * Constructs a new instance that will wrap the provided transformer.
   *
   * The new instance will inherit the wrapped transformer's inputs.
   *
   * @param wrappedTransformer the transformer to wrap
   */
  public ${wrapperTypeName}(${looseWrappedType} wrappedTransformer) {
    setWrappedTransformer(wrappedTransformer);
  }

  /**
   * Constructs a new instance that will initially lack a wrapped transformer (this should be set during the derived
   * class' constructor using {@link #setWrappedTransformer(<#if prepared>Prepared<#else>Preparable</#if>Transformer${arity})}
   */
  public ${wrapperTypeName}() {
  }

  /**
   * Constructs a new instance that will wrap the provided transformer.
   *
   * The new instance will inherit the wrapped transformer's inputs.
   *
   * @param wrapped the transformer to wrap
   */
  protected <@WrapperTransformer prepared /> withWrappedTransformer(${looseWrappedType} wrapped) {
    return clone(c -> c.setWrappedTransformer(wrapped));
  }

  /**
   * Sets the wrapped transformer and inherits its inputs (which become this instance's inputs).   This method should
   * <strong>only</strong> be called on new instances before they are returned to the client (e.g. during a
   * constructor).
   *
   * @param wrapped the wrapped transformer
   */
  protected void setWrappedTransformer(${looseWrappedType} wrapped) {
    _wrappedTransformer = <#if prepared>PreparedTransformer${arity}.cast<#else>PreparableTransformer${arity}.castWithGenericPrepared</#if>(wrapped);
    <#list 1..arity as index>
    _input${index} = _wrappedTransformer.internalAPI().getInput${index}();
    </#list>
    // replace _wrapped's inputs with placeholders to avoid storing references to the original inputs when/if the
    // wrapper transformer's inputs change
    _wrappedTransformer = Transformer.withPlaceholderInputs(_wrappedTransformer);
  }
</#macro>

/**
 * Base class for a preparable transformer that wraps another transformer of the same arity (number of inputs).
 *
 * The primary use case for wrapped transformers is "decorating" another transformer to give it more descriptive names
 * for its {@code withInput(...)} methods or other "syntactic sugar".  This is especially useful for creating a
 * user-friendly transformer from a DAG.
 *
<@c.TransformerParameterJavadoc arity />
 * @param <S> the type of the transformer deriving from this base class
 */
@ValueEquality
public class WrapperTransformer${arity}<<@c.InputGenericArguments arity />, R, S extends <@WrapperTransformer false />> extends
      <@c.AbstractPreparableTransformer arity preparedTransformerType "S" /> {

  <@Common false />

  @Override
  protected boolean hasIdempotentPreparer() {
    return _wrappedTransformer.internalAPI().hasIdempotentPreparer();
  }

  @Override
  protected <@c.Preparer arity preparedTransformerType /> getPreparer(PreparerContext context) {
    return Preparer${arity}.cast(_wrappedTransformer.internalAPI().getPreparer(context));
  }

  /**
   * Base class for a prepared transformer that wraps another transformer of the same arity (number of inputs).
   *
   * The primary use case for wrapped transformers is "decorating" another transformer to give it more descriptive names
   * for its {@code withInput(...)} methods or other "syntactic sugar".  This is especially useful for creating a
   * user-friendly transformer from a DAG.
   *
  <@c.TransformerParameterJavadoc arity />
   * @param <S> the type of the transformer deriving from this base class
   */
    @ValueEquality
    public static abstract class Prepared<<@c.InputGenericArguments arity />, R, S extends <@WrapperTransformer true />> extends
      AbstractPreparedStatefulTransformer${arity}<<@c.InputGenericArguments arity />, R, Object, S> {
    <@Common true />

    @Override
    public R apply(<@c.InputSuffixedParameters "value" arity />) {
      return _wrappedTransformer.apply(<@c.InputSuffixedList "value" arity />);
    }

    @Override
    public ObjectReader<R> applyAll(<@c.ValuesArguments "Iterable" arity />) {
      return _wrappedTransformer.applyAll(<@c.InputSuffixedList "values" arity />);
    }

    @Override
    protected R apply(Object executionCache, <@c.InputSuffixedParameters "value" arity />) {
      return _wrappedTransformer.internalAPI().apply(executionCache, <@c.InputSuffixedList "value" arity />);
    }

    @Override
    protected void applyAll(Object executionCache, <@c.ValuesArguments "List" arity />, List<? super R> results) {
      _wrappedTransformer.internalAPI().applyAllUnsafe(executionCache, values1.size(),
          Arrays.asList(<@c.InputSuffixedList "values" arity />), results);
    }

    @Override
    protected Object createExecutionCache(long exampleCountGuess) {
      return _wrappedTransformer.internalAPI().createExecutionCache(exampleCountGuess);
    }

    @Override
    protected int getPreferredMinibatchSize() {
      return super.getPreferredMinibatchSize();
    }
  }
}
