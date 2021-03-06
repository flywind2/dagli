// AUTOGENERATED CODE.  DO NOT MODIFY DIRECTLY!  Instead, please modify the transformer/TupledX.ftl file.
// See the README in the module's src/template directory for details.
package com.linkedin.dagli.transformer;

import com.linkedin.dagli.annotation.equality.ValueEquality;
import com.linkedin.dagli.producer.Producer;
import com.linkedin.dagli.tuple.Tuple8;


/**
 * A transformer that produces a tuple of the values it receives as inputs.
 */
@ValueEquality
public class Tupled8<A, B, C, D, E, F, G, H>
    extends
    AbstractPreparedTransformer8<A, B, C, D, E, F, G, H, Tuple8<A, B, C, D, E, F, G, H>, Tupled8<A, B, C, D, E, F, G, H>> {
  private static final long serialVersionUID = 1;

  /**
   * Creates a new instance with the specified inputs.
   */
  public Tupled8(Producer<? extends A> input1, Producer<? extends B> input2, Producer<? extends C> input3,
      Producer<? extends D> input4, Producer<? extends E> input5, Producer<? extends F> input6,
      Producer<? extends G> input7, Producer<? extends H> input8) {
    super(input1, input2, input3, input4, input5, input6, input7, input8);
  }

  @Override
  public Tuple8<A, B, C, D, E, F, G, H> apply(A value1, B value2, C value3, D value4, E value5, F value6, G value7,
      H value8) {
    return Tuple8.of(value1, value2, value3, value4, value5, value6, value7, value8);
  }
}
