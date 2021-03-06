( function _gFunctional_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;
let Self = _global_.wTools;

// --
// scalar
// --

/**
 * Produce a single array from all arguments if cant return single argument as a scalar.
 * If {-scalarAppend-} gets a single argument it returns the argument as is.
 * If {-scalarAppend-} gets an argument and one or more undefined it returns the argument as is.
 * If {-scalarAppend-} gets more than one or less than one defined arguments then it returns array having all defined arguments.
 * If some argument is a Long ( for example array ) then each element of the Long is treated as an argument, not recursively.
 *
 * @function scalarAppend.
 * @memberof wTools
 */

function scalarAppend( dst, src )
{

  _.assert( arguments.length === 2 );

  if( dst === undefined )
  {
    if( _.longIs( src ) )
    {
      dst = [];
    }
    else
    {
      if( src === undefined )
      return [];
      else
      return src;
    }
  }

  if( _.longIs( dst ) )
  {

    if( !_.arrayIs( dst ) )
    dst = _.arrayFrom( dst );

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    _.arrayAppendArray( dst, src );
    else
    dst.push( src );

  }
  else
  {

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    dst = _.arrayAppendArray( [ dst ], src );
    else
    dst = [ dst, src ];

  }

  return dst;
}

//

function scalarAppendOnce( dst, src )
{

  _.assert( arguments.length === 2 );

  if( dst === undefined )
  {
    if( _.longIs( src ) )
    {
      dst = [];
    }
    else
    {
      if( src === undefined )
      return [];
      else
      return src;
    }
  }

  if( _.longIs( dst ) )
  {

    if( !_.arrayIs( dst ) )
    dst = _.arrayFrom( dst );

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    _.arrayAppendArrayOnce( dst, src );
    else
    _.arrayAppendElementOnce( dst, src );

  }
  else
  {

    if( src === undefined )
    {}
    else if( _.longIs( src ) )
    dst = _.arrayAppendArrayOnce( [ dst ], src );
    else
    dst = _.arrayAppendElementOnce( [ dst ], src );

  }

  return dst;
}

//

/**
 * The scalarToVector() routine returns a new array
 * which containing the static elements only type of Number.
 *
 * It takes two arguments (dst) and (length)
 * checks if the (dst) is a Number, If the (length) is greater than or equal to zero.
 * If true, it returns the new array of static (dst) numbers.
 * Otherwise, if the first argument (dst) is an Array,
 * and its (dst.length) is equal to the (length),
 * it returns the original (dst) Array.
 * Otherwise, it throws an Error.
 *
 * @param { ( Number | Array ) } dst - A number or an Array.
 * @param { Number } length - The length of the new array.
 *
 * @example
 * _.scalarToVector( 3, 7 );
 * // returns [ 3, 3, 3, 3, 3, 3, 3 ]
 *
 * @example
 * _.scalarToVector( [ 3, 7, 13 ], 3 );
 * // returns [ 3, 7, 13 ]
 *
 * @returns { Number[] | Array } - Returns the new array of static numbers or the original array.
 * @function scalarToVector
 * @throws { Error } If missed argument, or got less or more than two arguments.
 * @throws { Error } If type of the first argument is not a number or array.
 * @throws { Error } If the second argument is less than 0.
 * @throws { Error } If (dst.length) is not equal to the (length).
 * @memberof wTools
 */

// function arrayFromNumber( dst, length )
function scalarToVector( dst, length )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  // _.assert( _.numberIs( dst ) || _.arrayIs( dst ), 'Expects array of number as argument' );
  _.assert( dst !== undefined, 'Expects array or scalar' );
  _.assert( length >= 0 );

  if( _.arrayIs( dst ) )
  {
    _.assert( dst.length === length, () => 'Expects array of length ' + length + ' but got ' + dst.length );
  }
  else
  {
    dst = _.longFill( [], dst, [ 0, length ] );
  }

  return dst;
}

//

function scalarFrom( src )
{
  if( _.longIs( src ) && src.length === 1 )
  return src[ 0 ];
  return src;
}

//

function scalarFromOrNull( src )
{
  if( _.longIs( src ) )
  {
    if( src.length === 1 )
    return src[ 0 ];
    else if( src.length === 0 )
    return null;
  }
  return src;
}

// --
// multiplier
// --

function dup( ins, times, result )
{
  _.assert( arguments.length === 2 || arguments.length === 3, 'Expects two or three arguments' );
  _.assert( _.numberIs( times ) || _.longIs( times ), 'dup expects times as number or array' );

  if( _.numberIs( times ) )
  {
    if( !result )
    result = new Array( times );
    for( let t = 0 ; t < times ; t++ )
    result[ t ] = ins;
    return result;
  }
  else if( _.longIs( times ) )
  {
    _.assert( times.length === 2 );
    let l = times[ 1 ] - times[ 0 ];
    if( !result )
    result = new Array( times[ 1 ] );
    for( let t = 0 ; t < l ; t++ )
    result[ times[ 0 ] + t ] = ins;
    return result;
  }
  else _.assert( 0, 'unexpected' );

}

//

function multiple( src, times )
{
  _.assert( arguments.length === 2 );
  if( _.arrayLike( src ) )
  _.assert( src.length === times, () => 'Vector should have ' + times + ' elements, but have ' + src.length );
  else
  src = _.dup( src, times );
  return src;
}

//

function multipleAll( dsts )
{
  let length = undefined;

  _.assert( arguments.length === 1 );

  for( let d = 0 ; d < dsts.length ; d++ )
  if( _.arrayIs( dsts[ d ] ) )
  {
    length = dsts[ d ].length;
    break;
  }

  if( length === undefined )
  return dsts;

  for( let d = 0 ; d < dsts.length ; d++ )
  dsts[ d ] = _.multiple( dsts[ d ], length );

  return dsts;
}

// --
// entity iterator
// --

/**
 * Routine eachSample() accepts the container {-sets-} with scalar or vector elements.
 * Routine returns an array of vectors. Each vector is a unique combination of elements of vectors
 * that is passed in option {-sets-}.
 *
 * Routine eachSample() accepts the options map {-o-} or two arguments. If options map
 * is used, all parameters can be set. If passed two arguments, first of them is ( sets )
 * and second is ( onEach ).
 *
 * Routine eachSample() accepts the callback {-onEach-}. Callback accepts two arguments. The first is
 * template {-sample-} and second is index of vector in returned array. Callback can change template {-sample-}
 * and corrupt the building of vectors.
 *
 * @param {Array|Map} sets - Container with vector and scalar elements to combine new vectors.
 * @param {Routine|Null} onEach - Callback that accepts template {-sample-} and index of new vector.
 * @param {Array|Map} sample - Template for new vectors. If not passed, routine create empty container.
 * If sample.length > vector.length, then vector elements replace template elements with the same indexes.
 * @param {boolean} leftToRight - Sets the direction of reading {-sets-}. 1 - left to rigth, 0 - rigth to left. By default is 1.
 * @param {boolean} result - Sets retuned value. 1 - routine returns array with verctors, 0 - routine returns index of last element. By default is 1.
 *
 * @example
 * var got = _.eachSample( { sets : [ [ 0, 1 ], 2 ] });
 * console.log( got );
 * // log [ [ 0, 2 ], [ 1, 2 ] ]
 *
 * @example
 * var got = _.eachSample( { sets : [ [ 0, 1 ], [ 2, 3 ] ], result : 0 });
 * console.log( got );
 * // log 3
 *
 * @example
 * var got = _.eachSample( { sets : [ [ 0, 1 ], [ 2, 3 ] ] });
 * console.log( got );
 * // log [ [ 0, 2 ], [ 1, 2 ],
 *          [ 0, 3 ], [ 1, 3 ] ]
 *
 * @example
 * var got = _.eachSample( { sets : { a : [ 0, 1 ], b : [ 2, 3 ] } });
 * console.log( got );
 * // log [ { a : 0, b : 2}, { a : 1, b : 2},
 *          { a : 0, b : 3}, { a : 1, b : 3} ]
 *
 * @example
 * var got = _.eachSample( { sets : [ [ 0, 1 ], [ 2, 3 ] ], leftToRight : 0 } );
 * console.log( got );
 * // log [ [ 3, 0 ], [ 2, 0 ],
 *          [ 3, 1 ], [ 2, 1 ] ]
 *
 * @example
 * var got = _.eachSample
 * ({
 *   sets : [ [ 0, 1 ], [ 2, 3 ] ],
 *   sample : [ 2, 3, 4, 5 ]
 * });
 * console.log( got );
 * // log [ [ 3, 0, 4, 5 ], [ 2, 0, 4, 5 ],
 *          [ 3, 1, 4, 5 ], [ 2, 1, 4, 5 ] ]
 *
 * @example
 * function onEach( sample, i )
 * {
 *   _.arrayAppend( got, sample[ i ] );
 * }
 * var got = [];
 * _.eachSample
 * ({
 *   sets : [ [ 0, 1 ], [ 2, 3 ] ],
 *   onEach : onEach,
 *   sample : [ 'a', 'b', 'c', 'd' ]
 * });
 * console.log( got );
 * // log [ 0, 2, 'c', 'd' ]
 *
 * @function eachSample
 * @returns {Array} Returns array contained  check function.
 * @throws {exception} If ( arguments.length ) is less then one or more then two.
 * @throws {exception} If( onEach ) is not a Routine or null.
 * @throws {exception} If( o.sets ) is not array or objectLike.
 * @throws {exception} If ( sets ) is mapLike and ( onEach ) not passed.
 * @throws {exception} If( o.base ) or ( o.add) is undefined.
 * @memberof wTools
 */

function eachSample( o )
{

  if( arguments.length === 2 || _.arrayLike( arguments[ 0 ] ) )
  {
    o =
    {
      sets : arguments[ 0 ],
      onEach : arguments[ 1 ],
    }
  }

  _.routineOptions( eachSample, o );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.routineIs( o.onEach ) || o.onEach === null );
  _.assert( _.longLike( o.sets ) || _.mapLike( o.sets ) );
  _.assert( o.base === undefined && o.add === undefined );

  /* sample */

  if( !o.sample )
  o.sample = _.entityMakeUndefined( o.sets );

  /* */

  let keys = _.longLike( o.sets ) ? _.longFromRange([ 0, o.sets.length ]) : _.mapKeys( o.sets );
  if( _.boolLikeTrue( o.result ) && !_.arrayIs( o.result ) )
  o.result = [];
  let len = [];
  let indexnd = [];
  let index = 0;
  let l = _.entityLength( o.sets );

  /* sets */

  let sindex = 0;

  o.sets = _.filter( o.sets, function( set, k )
  {
    _.assert( _.longIs( set ) || _.primitiveIs( set ) );

    if( _.primitiveIs( set ) )
    set = [ set ];

    len[ sindex ] = _.entityLength( o.sets[ k ] );
    indexnd[ sindex ] = 0;
    sindex += 1;

    return set;
  });

  /* */

  if( !firstSample() )
  return o.result;

  do
  {
    if( o.onEach )
    o.onEach.call( o.sample, o.sample, index );
  }
  while( iterate() );

  if( o.result )
  return o.result;
  else
  return index;

  /* */

  function firstSample()
  {
    let sindex = 0;

    _.each( o.sets, function( e, k )
    {
      o.sample[ k ] = o.sets[ k ][ indexnd[ sindex ] ];
      sindex += 1;
      if( !len[ k ] )
      return 0;
    });

    if( o.result )
    if( _.mapLike( o.sample ) )
    o.result.push( _.mapExtend( null, o.sample ) );
    else
    o.result.push( o.sample.slice() );

    return 1;
  }

  /* */

  function nextSample( i )
  {

    let k = keys[ i ];
    indexnd[ i ]++;

    if( indexnd[ i ] >= len[ i ] )
    {
      indexnd[ i ] = 0;
      o.sample[ k ] = o.sets[ k ][ indexnd[ i ] ];
    }
    else
    {
      o.sample[ k ] = o.sets[ k ][ indexnd[ i ] ];
      index += 1;

      if( o.result )
      if( _.mapLike( o.sample ) )
      o.result.push( _.mapExtend( null, o.sample ) );
      else
      o.result.push( o.sample.slice() );

      return 1;
    }

    return 0;
  }

  /* */

  function iterate()
  {

    if( o.leftToRight )
    for( let i = 0 ; i < l ; i++ )
    {
      if( nextSample( i ) )
      return 1;
    }
    else for( let i = l - 1 ; i >= 0 ; i-- )
    {
      if( nextSample( i ) )
      return 1;
    }

    return 0;
  }

}

eachSample.defaults =
{

  leftToRight : 1,
  onEach : null,

  sets : null,
  sample : null,

  result : 1,

}

//

function _entityFilterDeep( o )
{

  let result;
  let onEach = _._filter_functor( o.onEach, o.conditionLevels );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectLike( o.src ) || _.longIs( o.src ), 'entityFilter : expects objectLike or longIs src, but got', _.strType( o.src ) );
  _.assert( _.routineIs( onEach ) );

  /* */

  if( _.longIs( o.src ) )
  {
    result = _.longMake( o.src, 0 );
    let s, d;
    for( s = 0, d = 0 ; s < o.src.length ; s++ )
    // for( let s = 0, d = 0 ; s < o.src.length ; s++, d++ )
    {
      let r = onEach.call( o.src, o.src[ s ], s, o.src );

      if( _.unrollIs( r ) )
      {
        _.arrayAppendArray( result, r );
        d += r.length;
      }
      else if( r !== undefined )
      {
        result[ d ] = r;
        d += 1;
      }

      // if( r === undefined )
      // d--;
      // else
      // result[ d ] = r;

    }
    debugger;
    if( d < o.src.length )
    result = _.arraySlice( result, 0, d );
  }
  else
  {
    result = _.entityMakeUndefined( o.src );
    for( let s in o.src )
    {
      let r = onEach.call( o.src, o.src[ s ], s, o.src );
      // r = onEach.call( o.src, o.src[ s ], s, o.src );
      if( r !== undefined )
      result[ s ] = r;
    }
  }

  /* */

  return result;
}

_entityFilterDeep.defaults =
{
  src : null,
  onEach : null,
  conditionLevels : 1,
}

//

function entityFilterDeep( src, onEach )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  return _entityFilterDeep
  ({
    src,
    onEach,
    conditionLevels : 1024,
  });
}

//

function _entityIndex_functor( fop )
{

  fop = _.routineOptions( _entityIndex_functor, fop );

  let extendRoutine = fop.extendRoutine;

  return function entityIndex( src, onEach )
  {
    let result = Object.create( null );

    if( onEach === undefined )
    onEach = function( e, k )
    {
      if( k === undefined && extendRoutine )
      return { [ e ] : undefined };
      return k;
    }
    else if( _.strIs( onEach ) )
    {
      let selector = onEach;
      _.assert( _.routineIs( _.select ) );
      _.assert( _.strBegins( selector, '*/' ), () => `Selector should begins with "*/", but "${selector}" does not` );
      selector = _.strRemoveBegin( selector, '*/' );
      onEach = function( e, k )
      {
        return _.select( e, selector );
      }
    }

    _.assert( arguments.length === 1 || arguments.length === 2 );
    _.assert( _.routineIs( onEach ) );
    _.assert( src !== undefined, 'Expects src' );

    /* */

    if( _.mapLike( src ) )
    {

      for( let k in src )
      {
        let val = src[ k ];
        let r = onEach( val, k, src );
        extend( r, val );
      }

    }
    else if( _.longIs( src ) )
    {

      for( let k = 0 ; k < src.length ; k++ )
      {
        let val = src[ k ];
        let r = onEach( val, k, src );
        extend( r, val );
      }

    }
    else
    {

      let val = src;
      let r = onEach( val, undefined, undefined );
      extend( r, val );

    }

    return result;

    /* */

    function extend( res, val )
    {
      if( res === undefined )
      return;

      // if( _.unrollIs( res ) )
      // debugger;
      if( _.unrollIs( res ) )
      return res.forEach( ( res ) => extend( res, val ) );

      if( extendRoutine === null )
      {
        // if( res !== undefined ) // Dmytro : it's unnecessary condition, see 10 lines above
        result[ res ] = val;
      }
      else
      {
        if( _.mapLike( res ) )
        extendRoutine( result, res );
        // else if( res !== undefined ) // Dmytro : it's unnecessary condition, see 16 lines above
        else
        result[ res ] = val;
      }

    }

  }

}

_entityIndex_functor.defaults =
{
  extendRoutine : null,
}

//

/**
 * The routine entityIndex() returns a new pure map. The values of the map defined by elements of provided
 * entity {-src-} and keys defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns index of element.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityIndex( null );
 * // returns {}
 *
 * @example
 * _.entityIndex( null, ( el ) => el );
 * // returns { 'null' : null }
 *
 * @example
 * _.entityIndex( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndex( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '1' : 1, '3' : 2, '5' : 3, '7' : 4 }
 *
 * @example
 * _.entityIndex( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityIndex( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { '1' : 1, '2' : 2, '3' : 3 }
 *
 * @example
 * _.entityIndex( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { '1' : { f1 : 1, f2 : 3 }, '2' : { f1 : 2, f2 : 4 } }
 *
 * @returns { PureMap } - Returns the pure map. Values of the map defined by elements of provided entity {-src-}
 * and keys defined by results of callback execution on corresponding elements.
 * @function entityIndex
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @memberof wTools
 */

let entityIndex = _entityIndex_functor({ extendRoutine : null });

//

/**
 * The routine entityIndexSupplementing() returns a new pure map. The pairs key-value of the map formed by results
 * of callback execution on the entity elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine does not change existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns index of element.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityIndexSupplementing( null );
 * // returns { 'null' : undefined }
 *
 * @example
 * _.entityIndexSupplementing( null, ( el ) => el );
 * // returns { 'null' : null }
 *
 * @example
 * _.entityIndexSupplementing( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexSupplementing( [ 1, 2, 3, 4 ], ( el, key ) => key > 2 ? key : 1 );
 * // returns { '1' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexSupplementing( { a : 1, b : 1, c : 1 } );
 * // returns { a : 1, b : 1, c : 1 }
 *
 * @example
 * _.entityIndexSupplementing( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityIndexSupplementing( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : key, 'x' : el } } );
 * // returns { a : 'a', x : 1, b : 'b', c : 'c' }
 *
 * @example
 * _.entityIndexSupplementing( { a : { f1 : 1, f2 : 3 }, b : { f1 : 1, f2 : 4 } }, '*\/f1' );
 * // returns { '1' : { f1 : 1, f2 : 4 } }
 *
 * @returns { PureMap } - Returns the pure map. Values of the map defined by elements of provided entity {-src-}
 * and keys of defines by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine does not replaces the previous value with the new one.
 * @function entityIndexSupplementing
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @memberof wTools
 */

let entityIndexSupplementing = _entityIndex_functor({ extendRoutine : _.mapSupplement });

//

/**
 * The routine entityIndexExtending() returns a new pure map. The pairs key-value of the map formed by results
 * of callback execution on the entity elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine replaces existed value to the new.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns index of element.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityIndexExtending( null );
 * // returns { 'null' : undefined }
 *
 * @example
 * _.entityIndexExtending( null, ( el ) => el );
 * // returns { 'null' : null }
 *
 * @example
 * _.entityIndexExtending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexExtending( [ 1, 2, 3, 4 ], ( el, key ) => key > 2 ? key : 1 );
 * // returns { '1' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexExtending( { a : 1, b : 1, c : 1 } );
 * // returns { a : 1, b : 1, c : 1 }
 *
 * @example
 * _.entityIndexExtending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityIndexExtending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : key, 'x' : el } } );
 * // returns { a : 'a', x : 3, b : 'b', c : 'c' }
 *
 * @example
 * _.entityIndexExtending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 1, f2 : 4 } }, '*\/f1' );
 * // returns { '1' : { f1 : 1, f2 : 4 } }
 *
 * @returns { PureMap } - Returns the pure map. Values of the map defined by elements of provided entity {-src-}
 * and keys of defines by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine replaces the previous value with the new one.
 * @function entityIndexExtending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @memberof wTools
 */

let entityIndexExtending = _entityIndex_functor({ extendRoutine : _.mapExtend });

//

/**
 * The routine entityIndexPrepending() returns a new pure map. The pairs key-value of the map formed by results
 * of callback execution on the entity elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine prepends new values to the existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns index of element.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityIndexPrepending( null );
 * // returns { 'null' : undefined }
 *
 * @example
 * _.entityIndexPrepending( null, ( el ) => el );
 * // returns { 'null' : null }
 *
 * @example
 * _.entityIndexPrepending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexPrepending( [ 1, 2, 3, 4 ], ( el, key ) => key > 2 ? key : 1 );
 * // returns { '1' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexPrepending( { a : 1, b : 1, c : 1 } );
 * // returns { a : 1, b : 1, c : 1 }
 *
 * @example
 * _.entityIndexPrepending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityIndexPrepending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : key, 'x' : el } } );
 * // returns { a : 'a', x : [ 3, 2, 1 ], b : 'b', c : 'c' }
 *
 * @example
 * _.entityIndexPrepending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 1, f2 : 4 } }, '*\/f1' );
 * // returns { '1' : { f1 : 1, f2 : 4 } }
 *
 * @returns { PureMap } - Returns the pure map. Values of the map defined by elements of provided entity {-src-}
 * and keys of defines by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine prepends new value to the previous.
 * @function entityIndexPrepending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @memberof wTools
 */

let entityIndexPrepending = _entityIndex_functor({ extendRoutine : _.mapExtendPrepending });

//

/**
 * The routine entityIndexAppending() returns a new pure map. The pairs key-value of the map formed by results
 * of callback execution on the entity elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine appends new values to the existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns index of element.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityIndexAppending( null );
 * // returns { 'null' : undefined }
 *
 * @example
 * _.entityIndexAppending( null, ( el ) => el );
 * // returns { 'null' : null }
 *
 * @example
 * _.entityIndexAppending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexAppending( [ 1, 2, 3, 4 ], ( el, key ) => key > 2 ? key : 1 );
 * // returns { '1' : 3, '3' : 4 }
 *
 * @example
 * _.entityIndexAppending( { a : 1, b : 1, c : 1 } );
 * // returns { a : 1, b : 1, c : 1 }
 *
 * @example
 * _.entityIndexAppending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityIndexAppending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : key, 'x' : el } } );
 * // returns { a : 'a', x : [ 1, 2, 3 ], b : 'b', c : 'c' }
 *
 * @example
 * _.entityIndexAppending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 1, f2 : 4 } }, '*\/f1' );
 * // returns { '1' : { f1 : 1, f2 : 4 } }
 *
 * @returns { PureMap } - Returns the pure map. Values of the map defined by elements of provided entity {-src-}
 * and keys of defines by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine appends new value to the previous.
 * @function entityIndexAppending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @memberof wTools
 */

let entityIndexAppending = _entityIndex_functor({ extendRoutine : _.mapExtendAppending });

//

function _entityRemap_functor( fop )
{

  fop = _.routineOptions( _entityRemap_functor, fop );

  let extendRoutine = fop.extendRoutine;

  return function entityRemap( src, onEach )
  {
    let result = Object.create( null );

    if( onEach === undefined )
    onEach = function( e, k )
    {
      if( e === undefined && extendRoutine )
      return { [ k ] : e };
      return e;
    }
    else if( _.strIs( onEach ) )
    {
      let selector = onEach;
      _.assert( _.routineIs( _.select ) );
      _.assert( _.strBegins( selector, '*/' ), () => `Selector should begins with "*/", but "${selector}" does not` );
      selector = _.strRemoveBegin( selector, '*/' );
      onEach = function( e, k )
      {
        return _.select( e, selector );
      }
    }

    _.assert( arguments.length === 1 || arguments.length === 2 );
    _.assert( _.routineIs( onEach ) );
    _.assert( src !== undefined, 'Expects src' );

    /* */

    if( _.mapLike( src ) )
    {

      for( let k in src )
      {
        let val = src[ k ];
        let r = onEach( val, k, src );
        extend( r, k );
      }

    }
    else if( _.longIs( src ) )
    {

      for( let k = 0 ; k < src.length ; k++ )
      {
        let val = src[ k ];
        let r = onEach( val, k, src );
        extend( r, k );
      }

    }
    else
    {

      let val = src;
      let r = onEach( val, undefined, undefined );
      extend( r, undefined );

    }

    return result;

    /* */

    function extend( res, key )
    {
      if( res === undefined )
      return;

      if( _.unrollIs( res ) )
      return res.forEach( ( res ) => extend( res, key ) );

      if( extendRoutine === null )
      {
        if( key !== undefined )
        result[ key ] = res;
      }
      else
      {
        if( _.mapLike( res ) )
        extendRoutine( result, res );
        else if( key !== undefined )
        result[ key ] = res;
      }

    }

  }

}

_entityRemap_functor.defaults =
{
  extendRoutine : null,
}

//

/**
 * The routine entityRemap() returns a new pure map. The keys of the map defined by keys of provided
 * entity {-src-} and values defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns map with pair key-value for Longs
 * and maps or element for other types.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityRemap( null );
 * // returns {}
 *
 * @example
 * _.entityRemap( null, ( el ) => el );
 * // returns {}
 *
 * @example
 * _.entityRemap( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityRemap( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '0' : 1, '1' : 3, '2' : 5, '3' : 7 }
 *
 * @example
 * _.entityRemap( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemap( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 'a', b : 'b', c : 'c' }
 *
 * @example
 * _.entityRemap( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { a : 1, b : 2 }
 *
 * @returns { PureMap } - Returns the pure map. Keys of the map defined by keys of provided entity {-src-}
 * and values defined by results of callback execution on corresponding elements.
 * @function entityRemap
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @memberof wTools
 */

let entityRemap = _entityRemap_functor({ extendRoutine : null });

//

/**
 * The routine entityRemapSupplementing() returns a new pure map. The keys of the map defined by keys of provided
 * entity {-src-} and values defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine does not change existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns map with pair key-value for Longs
 * and maps or element for other types.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityRemapSupplementing( null );
 * // returns {}
 *
 * @example
 * _.entityRemapSupplementing( null, ( el ) => el );
 * // returns {}
 *
 * @example
 * _.entityRemapSupplementing( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityRemapSupplementing( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '0' : 1, '1' : 3, '2' : 5, '3' : 7 }
 *
 * @example
 * _.entityRemapSupplementing( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapSupplementing( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 'a', b : 'b', c : 'c' }
 *
 * @example
 * _.entityRemapSupplementing( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : el, x : el } } );
 * // returns { a : 1, x : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapSupplementing( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { a : 1, b : 2 }
 *
 * @returns { PureMap } - Returns the pure map. Keys of the map defined by keys of provided entity {-src-}
 * and values defined by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine does not replaces the previous value with the new one.
 * @function entityRemapSupplementing
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @memberof wTools
 */


let entityRemapSupplementing = _entityRemap_functor({ extendRoutine : _.mapSupplement });

//

/**
 * The routine entityRemapExtending() returns a new pure map. The keys of the map defined by keys of provided
 * entity {-src-} and values defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine does change existed value to the new one.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns map with pair key-value for Longs
 * and maps or element for other types.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityRemapExtending( null );
 * // returns {}
 *
 * @example
 * _.entityRemapExtending( null, ( el ) => el );
 * // returns {}
 *
 * @example
 * _.entityRemapExtending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityRemapExtending( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '0' : 1, '1' : 3, '2' : 5, '3' : 7 }
 *
 * @example
 * _.entityRemapExtending( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapExtending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 'a', b : 'b', c : 'c' }
 *
 * @example
 * _.entityRemapExtending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : el, x : el } } );
 * // returns { a : 1, x : 3, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapExtending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { a : 1, b : 2 }
 *
 * @returns { PureMap } - Returns the pure map. Keys of the map defined by keys of provided entity {-src-}
 * and values defined by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine replaces the previous value with the new one.
 * @function entityRemapExtending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @memberof wTools
 */

let entityRemapExtending = _entityRemap_functor({ extendRoutine : _.mapExtend });

//

/**
 * The routine entityRemapPrepending() returns a new pure map. The keys of the map defined by keys of provided
 * entity {-src-} and values defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine prepends new values to the existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns map with pair key-value for Longs
 * and maps or element for other types.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityRemapPrepending( null );
 * // returns {}
 *
 * @example
 * _.entityRemapPrepending( null, ( el ) => el );
 * // returns {}
 *
 * @example
 * _.entityRemapPrepending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityRemapPrepending( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '0' : 1, '1' : 3, '2' : 5, '3' : 7 }
 *
 * @example
 * _.entityRemapPrepending( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapPrepending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 'a', b : 'b', c : 'c' }
 *
 * @example
 * _.entityRemapPrepending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : el, x : el } } );
 * // returns { a : 1, x : [ 3, 2, 1 ], b : 2, c : 3 }
 *
 * @example
 * _.entityRemapPrepending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { a : 1, b : 2 }
 *
 * @returns { PureMap } - Returns the pure map. Keys of the map defined by keys of provided entity {-src-}
 * and values defined by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine prepends new values to the existed value.
 * @function entityRemapPrepending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @memberof wTools
 */

let entityRemapPrepending = _entityRemap_functor({ extendRoutine : _.mapExtendPrepending });

//

/**
 * The routine entityRemapAppending() returns a new pure map. The keys of the map defined by keys of provided
 * entity {-src-} and values defined by result of callback execution on the correspond elements.
 * If callback returns undefined, then element will not exist in resulted map.
 * If callback returns map with key existed in resulted map, then routine appends new values to the existed value.
 *
 * @param { * } src - Any entity to make map of indexes.
 * @param { String|Function } onEach - The callback executed on elements of entity.
 * If {-onEach-} is not defined, then routine uses callback that returns map with pair key-value for Longs
 * and maps or element for other types.
 * If {-onEach-} is a string, then routine searches elements with equal key. String value should has
 * prefix "*\/" ( asterisk + slash ).
 * By default, {-onEach-} applies three parameters: element, key, container. If entity is primitive, then
 * routine applies only element value, other parameters is undefined.
 *
 * @example
 * _.entityRemapAppending( null );
 * // returns {}
 *
 * @example
 * _.entityRemapAppending( null, ( el ) => el );
 * // returns {}
 *
 * @example
 * _.entityRemapAppending( [ 1, 2, 3, 4 ] );
 * // returns { '0' : 1, '1' : 2, '2' : 3, '3' : 4 }
 *
 * @example
 * _.entityRemapAppending( [ 1, 2, 3, 4 ], ( el, key ) => el + key );
 * // returns { '0' : 1, '1' : 3, '2' : 5, '3' : 7 }
 *
 * @example
 * _.entityRemapAppending( { a : 1, b : 2, c : 3 } );
 * // returns { a : 1, b : 2, c : 3 }
 *
 * @example
 * _.entityRemapAppending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => container.a > 0 ? key : el );
 * // returns { a : 'a', b : 'b', c : 'c' }
 *
 * @example
 * _.entityRemapAppending( { a : 1, b : 2, c : 3 }, ( el, key, container ) => { return { [ key ] : el, x : el } } );
 * // returns { a : 1, x : [ 3, 2, 1 ], b : 2, c : 3 }
 *
 * @example
 * _.entityRemapAppending( { a : { f1 : 1, f2 : 3 }, b : { f1 : 2, f2 : 4 } }, '*\/f1' );
 * // returns { a : 1, b : 2 }
 *
 * @returns { PureMap } - Returns the pure map. Keys of the map defined by keys of provided entity {-src-}
 * and values defined by results of callback execution on corresponding elements. If the callback returns map
 * with existed key, then routine appends new values to the existed value.
 * @function entityRemapAppending
 * @throws { Error } If arguments.length is less then one or more then two.
 * @throws { Error } If {-src-} has value undefined.
 * @throws { Error } If {-onEach-} is not undefined, not a function, not a String.
 * @throws { Error } If {-onEach-} is a String, but has not prefix '*\/' ( asterisk + slash ).
 * @memberof wTools
 */

let entityRemapAppending = _entityRemap_functor({ extendRoutine : _.mapExtendAppending });

// --
// fields
// --

let Fields =
{
}

// --
// routines
// --

let Routines =
{

  eachSample,

  _entityFilterDeep,
  entityFilterDeep,
  filterDeep : entityFilterDeep,

  _entityIndex_functor,
  entityIndex,
  index : entityIndex,
  entityIndexSupplementing,
  indexSupplementing : entityIndexSupplementing,
  entityIndexExtending,
  indexExtending : entityIndexExtending,
  entityIndexPrepending,
  indexPrepending : entityIndexPrepending,
  entityIndexAppending,
  indexAppending : entityIndexAppending,

  _entityRemap_functor,
  entityRemap,
  remap : entityRemap,
  entityRemapSupplementing,
  remapSupplementing : entityRemapSupplementing,
  entityRemapExtending,
  remapExtending : entityRemapExtending,
  entityRemapPrepending,
  remapPrepending : entityRemapPrepending,
  entityRemapAppending,
  remapAppending : entityRemapAppending,

}

//

Object.assign( Self, Routines );
Object.assign( Self, Fields );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
