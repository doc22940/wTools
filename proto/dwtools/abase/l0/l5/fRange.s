( function _fRange_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;

// --
// range
// --

/* qqq : use _.pair as example to make the same thing */


function fromLeft( range )
{
  _.assert( arguments.length === 1 );
  if( _.numberIs( range ) )
  return [ range, Infinity ];
  _.assert( _.longIs( range ) );
  _.assert( range.length === 1 || range.length === 2 );
  _.assert( range[ 0 ] === undefined || _.numberIs( range[ 0 ] ) );
  _.assert( range[ 1 ] === undefined || _.numberIs( range[ 1 ] ) );
  if( range[ 0 ] === undefined )
  return [ 0, range[ 1 ] ];
  if( range[ 1 ] === undefined )
  return [ range[ 0 ], Infinity ];
  return range;
}

//

/* aaa Dmytro : this routine is identical to rangeFromLeft. Is it correct? */
/* aaa : not really */
/* Dmytro : new feature is tested */

function fromRight( range )
{
  _.assert( arguments.length === 1 );
  if( _.numberIs( range ) )
  return [ 0, range ];
  _.assert( _.longIs( range ) );
  _.assert( range.length === 1 || range.length === 2 );
  _.assert( range[ 0 ] === undefined || _.numberIs( range[ 0 ] ) );
  _.assert( range[ 1 ] === undefined || _.numberIs( range[ 1 ] ) );
  if( range[ 0 ] === undefined )
  return [ 0, range[ 1 ] ];
  if( range[ 1 ] === undefined )
  return [ range[ 0 ], Infinity ];
  return range;
}

//

function fromSingle( range )
{
  _.assert( arguments.length === 1 );
  if( _.numberIs( range ) )
  return [ range, range + 1 ];

  _.assert( _.longIs( range ) );
  _.assert( range.length === 1 || range.length === 2 );
  _.assert( range[ 0 ] === undefined || _.numberIs( range[ 0 ] ) );
  _.assert( range[ 1 ] === undefined || _.numberIs( range[ 1 ] ) );

  if( range[ 0 ] === undefined )
  if( range[ 1 ] !== undefined )
  return [ range[ 1 ]-1, range[ 1 ] ];
  else
  return [ 0, 1 ];

  if( range[ 1 ] === undefined )
  return [ range[ 0 ], range[ 0 ] + 1 ];
  return range;
}

//

/* qqq : teach to accept number in second argument */

function clamp( dstRange, clampRange )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.rangeIs( dstRange ) );
  _.assert( _.rangeIs( clampRange ) );

  if( dstRange[ 0 ] < clampRange[ 0 ] )
  dstRange[ 0 ] = clampRange[ 0 ];
  else if( dstRange[ 0 ] > clampRange[ 1 ] )
  dstRange[ 0 ] = clampRange[ 1 ];

  if( dstRange[ 1 ] < clampRange[ 0 ] )
  dstRange[ 1 ] = clampRange[ 0 ];
  else if( dstRange[ 1 ] > clampRange[ 1 ] )
  dstRange[ 1 ] = clampRange[ 1 ];

  return dstRange;
}

//

function countElements( range, increment )
{

  _.assert( _.rangeIs( range ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( increment === undefined )
  increment = 1;

  _.assert( _.numberIs( increment ), 'Increment should has a number value' );

  return increment ? ( range[ 1 ]-range[ 0 ] ) / increment : 0;
}

//

function firstGet( range, options )
{

  var options = options || Object.create( null ); // Dmytro : it's unnecessary to create new container.
  if( options.increment === undefined )
  options.increment = 1;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( _.longIs( range ) )
  {
    _.assert( _.rangeIs( range ) );
    return range[ 0 ];
  }
  else if( _.mapIs( range ) )
  {
    return range.first
  }
  _.assert( 0, 'unexpected type of range',_.strType( range ) );

}

//

function lastGet( range, options )
{

  var options = options || Object.create( null ); // Dmytro : it's unnecessary to create new container.
  if( options.increment === undefined )
  options.increment = 1;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( _.longIs( range ) )
  {
    _.assert( _.rangeIs( range ) );
    return range[ 1 ];
  }
  else if( _.mapIs( range ) )
  {
    return range.last
  }
  _.assert( 0, 'unexpected type of range',_.strType( range ) );

}

//

function toStr( range )
{
  _.assert( _.rangeIs( range ) );
  _.assert( arguments.length === 1 );
  return range[ 0 ] + '..' + range[ 1 ];
}

// --
// define
// --

class Range 
{
}

let Handler =
{
  construct( original, args )
  {
    return Pair.make( ... args );
  }
};

let Self = new Proxy( Range, Handler );
Self.original = Range;

// --
// routines
// --

let Extension =
{

  fromLeft,
  fromRight,
  fromSingle,

  clamp,
  countElements,
  firstGet,
  lastGet,

  toStr,

}

//

_.mapSupplement( Self, Extension );
_.assert( _.range === undefined );
_.range = Self;

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
})();
