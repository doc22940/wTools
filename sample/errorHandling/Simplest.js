let _ = require( '../..' );
// _.include( 'wFiles' );
// uncomment to have source code in error report

try
{
  throw _.err( 'Simplest error sample' );
}
catch( err )
{
  throw err;
}

/*
  Simplest sample of throwing errors.
  Routune _.err generates stateful error object.
*/
