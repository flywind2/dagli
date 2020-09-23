<#import "common.ftl" as t />
<@t.AutoGeneratedWarning />
package com.linkedin.dagli.tuple;

import java.util.Iterator;

/**
 * An ordered sequence of ${arity} elements.
 */
public interface <@t.Tuple arity /> extends Tuple, <#list 0..<arity as index><@t.TupleValue index /><#sep>, </#list> {
  <#list 0..<arity as index>
  /**
   * Gets element ${index} from the tuple
   *
   * @return the element value
   */
  @Override
  ${t.typeParameters[index]} get${index}();

  /**
   * Gets a new tuple containing the same elements as this tuple except for element ${index}, which will be set to the
    provided value.
   *
   * @param value the value that should replace element ${index} in the new tuple
   * @return a new tuple with the same elements as this one, but with element ${index} replaced with a new value
   */
  default <Z> <@t.TupleWithNewType arity index /> withValue${index}(Z value) {
    return of(<#list 0..<arity as i><#if i == index>value<#else>get${i}()</#if><#sep>, </#list>);
  }
  </#list>

  /**
   * @return ${arity}
   */
  @Override
  default int size() {
    return ${arity};
  }

  /**
   * Creates a new tuple that contains the given elements.
   *
   * @return a new tuple with the provided elements
   */
  static <<@t.TypeParameters arity />> <@t.Tuple arity /> of(<#list 0..<arity as index>${t.typeParameters[index]} element${index}<#sep>, </#list>) {
    return new FieldTuple${arity}<>(<#list 0..<arity as index>element${index}<#sep>, </#list>);
  }

  /**
   * Creates a new tuple that contains the given elements.  The tuple takes ownership of the provided array, which
   * should not be subsequently modified.  The array's length must be at least ${arity}.
   *
   * This method is "unsafe" because the arrays values cannot be type-checked to ensure that they conform to their
   * purported types.
   *
   * @return a new tuple with the provided elements
   */
  static <<@t.TypeParameters arity />> <@t.Tuple arity /> fromArrayUnsafe(Object[] elements) {
    return new ArrayTuple${arity}<>(elements);
  }

  /**
   * Creates a new tuple containing the first ${arity} elements of the provided iterable.
   *
   * This method is "unsafe" because the iterated values cannot be type-checked to ensure that they conform to their
   * purported types.
   *
   * @param elements the iterable containing the elements to copy into a new tuple.
   * @throws java.util.NoSuchElementException if there are fewer than ${arity} elements in the provided iterable.
   * @return a new tuple with the provided elements
   */
  static <<@t.TypeParameters arity />> <@t.Tuple arity /> fromIterableUnsafe(Iterable<?> elements) {
    Iterator<?> iterator = elements.iterator();
    if (iterator instanceof AutoCloseable) {
      try (AutoCloseable closeable = (AutoCloseable) iterator) {
        return fromIteratorUnsafe(iterator);
      } catch (RuntimeException e) {
        throw e; // rethrow unmodified
      } catch (Exception e) {
        // checked exceptions might be thrown when closing the iterator
        throw new RuntimeException(e);
      }
    }

    return fromIteratorUnsafe(elements.iterator());
  }

  /**
   * Creates a new tuple containing the first ${arity} elements of the provided iterator.
   *
   * This method is "unsafe" because the iterated values cannot be type-checked to ensure that they conform to their
   * purported types.
   *
   * @param elements the iterator containing the elements to copy into a new tuple.
   * @throws java.util.NoSuchElementException if there are fewer than ${arity} elements in the provided iterator.
   * @return a new tuple with the provided elements
   */
  @SuppressWarnings("unchecked")
  static <<@t.TypeParameters arity />> <@t.Tuple arity /> fromIteratorUnsafe(Iterator<?> elements) {
    return new FieldTuple${arity}<<@t.TypeParameters arity/>>(<#list 0..<arity as index>(${t.typeParameters[index]}) elements.next()<#sep>, </#list>);
  }
}