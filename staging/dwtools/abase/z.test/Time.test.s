( function _Time_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    require( '../../Base.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wTesting' );

}

var _ = wTools;

// debugger;
//
// var t = _.timeOutError( 5000 );
// t.error( 'Stop timer' );
//
// debugger;
// return;

//

function timeOut( test )
{
  var delay = 300;
  var testCon = new wConsequence().give()

  /* */

  .doThen( function()
  {
    test.description = 'delay only';
    var timeBefore = _.timeNow();
    return _.timeOut( delay )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.shouldBe( _.routineIs( got ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine';
    var timeBefore = _.timeNow();
    return _.timeOut( delay, () => {} )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.identical( err, null );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    return _.timeOut( delay, () => value )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, value );
      test.identical( err, null );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    return _.timeOut( delay, () => _.timeOut( delay ) )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
      test.shouldBe( _.routineIs( got ) );
      test.identical( err, null );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    return _.timeOut( delay, () => { _.timeOut( delay ) } )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( err, null );
      test.identical( got, undefined );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    return _.timeOut( delay, undefined, r, [ delay ] )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, delay / 2 );
      test.identical( err, null );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + consequence';
    var timeBefore = _.timeNow();

    return _.timeOut( delay, _.timeOut( delay * 2 ) )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
      test.shouldBe( _.routineIs( got ) );
      test.identical( err, null );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'stop timer with error';
    var timeBefore = _.timeNow();

    var t = _.timeOut( delay );
    t.doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
      test.identical( err, null );
      test.identical( got, 'stop' )
    })
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return t;
  })

  /* */

  .doThen( function()
  {
    test.description = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( delay, () => { called = true } );
    t.doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
      test.identical( got, 'stop' );
      test.identical( called, false );
      test.identical( err, null )
    })
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return t;
  })

  /* */

  .doThen( function()
  {
    test.description = 'give err after timeOut';
    var timeBefore = _.timeNow();

    var t = _.timeOut( delay, () => {} );
    t.got( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.identical( err, null );
    })

    return _.timeOut( delay + 50, function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
    })

    return t;
  })

  return testCon;
}

//

function timeOutAsync( test )
{
  var delay = 300;
  function setAsync( giving, taking )
  {
    wConsequence.prototype.asyncGiving = giving;
    wConsequence.prototype.asyncTaking = taking;
  }
  var testCon = new wConsequence().give()

  /* asyncGiving : 1, asyncTaking : 0 */

  .doThen( () => setAsync( 1, 0 ) )
  .doThen( function()
  {
    test.description = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( _.routineIs( got ) );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( delay, () => value );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === value );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => _.timeOut( delay ) );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
        test.shouldBe( _.routineIs( got ));
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => { _.timeOut( delay ) } );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.timeOut( delay, undefined, r, [ delay ] );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === delay / 2 );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.shouldBe( got === 'stop' );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( delay, () => { called = true } );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.identical( got, 'stop' );
        test.identical( called, false );
        test.identical( err, null )
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );

    var con = new wConsequence();
    con.first( t );
    con.doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.identical( got, undefined );
        test.identical( err, null );
      })
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen(function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })

    return _.timeOut( delay + 50, function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .doThen( function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    });
  })

  /* asyncGiving : 0, asyncTaking : 1 */

  .doThen( () => setAsync( 0, 1 ) )
  .doThen( function()
  {
    test.description = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( _.routineIs( got ) );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( delay, () => value );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === value );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => _.timeOut( delay ) );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
        test.shouldBe( _.routineIs( got ));
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => { _.timeOut( delay ) } );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.timeOut( delay, undefined, r, [ delay ] );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === delay / 2 );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.shouldBe( got === 'stop' );
        test.shouldBe( err === null );
        test.identical( t.messagesGet().length, 0 );
        test.identical( t.correspondentsEarlyGet().length, 0 );
      });

      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( delay, () => { called = true } );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.identical( got, 'stop' );
        test.identical( called, false );
        test.identical( err, null );
        test.identical( t.messagesGet().length, 0 );
        test.identical( t.correspondentsEarlyGet().length, 0 );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );

    var con = new wConsequence();
    con.first( t );
    con.doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.identical( got, undefined );
        test.identical( err, null );
      })
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
    .doThen( function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    });

    return con;
  })

  /* asyncGiving : 1, asyncTaking : 1 */

  .doThen( () => setAsync( 1, 1 ) )
  .doThen( function()
  {
    test.description = 'delay only';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( _.routineIs( got ) );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1, function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    var t = _.timeOut( delay, () => value );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === value );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => _.timeOut( delay ) );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
        test.shouldBe( _.routineIs( got ));
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => { _.timeOut( delay ) } );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === undefined );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    var t = _.timeOut( delay, undefined, r, [ delay ] );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.shouldBe( got === delay / 2 );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );
    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.shouldBe( got === 'stop' );
        test.shouldBe( err === null );
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOut( delay, () => { called = true } );
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return new wConsequence().first( t )
    .doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
        test.identical( got, 'stop' );
        test.identical( called, false );
        test.identical( err, null )
      });
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
  })

  /**/

  .doThen( function()
  {
    test.description = 'give err after timeOut';
    var timeBefore = _.timeNow();
    var t = _.timeOut( delay, () => {} );

    var con = new wConsequence();
    con.first( t );
    con.doThen( function()
    {
      t.got( function( err, got )
      {
        test.shouldBe( _.timeNow() - timeBefore >= delay );
        test.identical( got, undefined );
        test.identical( err, null );
      })
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    })
    .doThen( function()
    {
      t.error( 'stop' );
      t.got( ( err, got ) => test.identical( err, 'stop' ) );
      test.identical( t.messagesGet().length, 1 );
      test.identical( t.correspondentsEarlyGet().length, 1 );
    })
    .timeOutThen( 1,function()
    {
      test.identical( t.messagesGet().length, 0 );
      test.identical( t.correspondentsEarlyGet().length, 0 );
    });

    return con;
  })

  return testCon;
}

timeOutAsync.timeOut = 20000;

//

function timeOutError( test )
{
  var delay = 300;
  var testCon = new wConsequence().give()

  /* */

  .doThen( function()
  {
    test.description = 'delay only';
    var timeBefore = _.timeNow();
    return _.timeOutError( delay )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.shouldBe( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine';
    var timeBefore = _.timeNow();
    return _.timeOutError( delay, () => {} )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine that returns a value';
    var timeBefore = _.timeNow();
    var value = 'value';
    return _.timeOutError( delay, () => value )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });
  })

  // /* */

  .doThen( function()
  {
    test.description = 'delay + routine that returns a consequence';
    var timeBefore = _.timeNow();
    return _.timeOutError( delay, () => _.timeOut( delay ) )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + routine that calls another timeOut';
    var timeBefore = _.timeNow();
    return _.timeOutError( delay, () => { _.timeOut( delay ) } )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + context + routine + arguments';
    var timeBefore = _.timeNow();
    function r( delay )
    {
      return delay / 2;
    }
    return _.timeOutError( delay, undefined, r, [ delay ] )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'delay + consequence';
    var timeBefore = _.timeNow();

    return _.timeOutError( delay, _.timeOut( delay * 2 ) )
    .doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay * 2 );
      test.identical( got, undefined );
      test.shouldBe( _.errIs( err ) );
    });
  })

  /* */

  .doThen( function()
  {
    test.description = 'stop timer with error';
    var timeBefore = _.timeNow();

    var t = _.timeOutError( delay );
    t.doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
      test.identical( got, undefined );
      test.identical( err, null );
      test.identical( t.messagesGet().length, 0 );
    })
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return t;
  })

  /* */

  .doThen( function()
  {
    test.description = 'stop timer with error, routine passed';
    var timeBefore = _.timeNow();
    var called = false;

    var t = _.timeOutError( delay, () => { called = true } );
    t.doThen( function( err, got )
    {
      test.shouldBe( _.timeNow() - timeBefore >= delay / 2 );
      test.identical( got, undefined );
      test.identical( called, false );
      test.identical( err, null )
      test.identical( t.messagesGet().length, 0 );
    })
    _.timeOut( delay/ 2, () => t.error( 'stop' ) );

    return t;
  })

  return testCon;
}

//

var Self =
{

  name : 'Time',
  silencing : 1,

  tests :
  {
    timeOut : timeOut,
    timeOutAsync : timeOutAsync,
    timeOutError : timeOutError
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );