#******************************************
#
#  (C) Copyright IBM Corp. 2015
#
#  Author: Bradley J Eck 
#
#******************************************

#  File: inpFuncs_tests.r
#  Purpose: test reading of .inp files 

source("../R/inpFuncs.r")


context("functions for inp parts")
test_that("semi-colon at end of line is removed",
          {
          l <-  .processCommentsAndClean(" 40	 		10                      	;")
          expect_that(grepl(";",l), equals(FALSE))
          })


test_that("Net1 JUNCTIONs table",
{ 
          jt <- JUNCTIONS(readLines("Net1.inp"))
          expect_that(class(jt), equals("data.frame"))
})

test_that("Net2 JUNCTIONS table",
         {
            jt <- JUNCTIONS(readLines("Net2.inp"))
            expect_true( jt$Pattern[1] == 2 ) 
         })



test_that("IDs are character",{

			# Net 1
          jt <- JUNCTIONS(readLines("Net1.inp"))
          expect_true( class(jt$ID) == "character")
		  # Net 2
		  jt <- JUNCTIONS(readLines("Net2.inp"))
          expect_true( class(jt$ID) == "character")
	  })


test_that("Net3 RESERVOIRSs table",
{ 
          res <- RESERVOIRS(readLines("Net3.inp"))
          expect_that(class(res), equals("data.frame"))
          expect_that(res$Pattern[1], equals(NA))
		  expect_true( class(res$ID) == "character")
})


test_that("RESERVOIR table has patterns",{
			
			res <- RESERVOIRS(c("[RESERVOIRS]"," R1    55.5    R1Pat", "[END]"))
			expect_that(names(res)[3], equals("Pattern"))
		})

test_that("Net3 TANKS table",
{ 
          tt <- TANKS(readLines("Net3.inp"))
          expect_that(class(tt), equals("data.frame"))
          expect_that(dim(tt)[1], equals(3))
          expect_that(tt$VolCurve[1], equals(NA))
})


test_that("Net3 PIPES table",
          {
            pip <- PIPES(readLines("Net3.inp"))
          expect_that(dim(pip)[1], equals(117))
          })

test_that("pipes table missing status",{
  pip <- PIPES(readLines("inp-pipe-table-some-statuses-empty.txt"))
  expect_equal( class(pip$Status), "factor") 
})



test_that("Net3 PUMPS table",
          {
            pmpt <- PUMPS(readLines("Net3.inp"))
            expect_that(dim(pmpt)[1], equals(2))
          })

test_that("Net3 ENERGY table is ok ",
          {
            engy <-ENERGY(readLines("Net3.inp"))
            expect_that(length(engy),equals(3))
          })



test_that("Net3 TIMES",
          {
            tms <- TIMES(readLines("Net3.inp"))
            expect_that(length(tms),equals(9))
          })

test_that("Net3 OPTIONS",
          {
            opts <- OPTIONS(readLines("Net3.inp"))
            expect_that(class(opts),equals("list"))
          })
test_that("Net3 COORDINATES",
          {
            coord <- COORDINATES(readLines("Net3.inp"))
            expect_that(dim(coord)[1],equals(96))
          })

test_that("two word options are picked up",
           {
           newList <-  .listUpdater( list( a_b = 4 ), "a b 5")
           expect_that(newList[[1]], equals("5"))
           })


test_that("for options case doesn't matter",
           {
           newList <-  .listUpdater( list( A_B = 4 ), "a b 5")
           expect_that(newList$A_B, equals("5"))
           })

  
test_that(" patterns work",
          {
            pats <- suppressWarnings(  PATTERNS(readLines("Net3.inp")) ) 
            expect_that(length(pats),equals(5))
            expect_that(pats$`1`[16],equals(.83))
		    expect_warning(PATTERNS(readLines("Net3.inp"))) 	
          })

test_that("curves work",
          {
            crvs <- suppressWarnings( CURVES(readLines("Net3.inp")) ) 
            expect_that(length(crvs),equals(2))
		    expect_warning(	CURVES(readLines("Net3.inp")) )
          })

test_that("some pattern entries in junc table can be missing",
          {
            junc <- JUNCTIONS(readLines("Net2.inp"))
          })


test_that("title reads correctly",
{
          titl <- TITLE( readLines("net1.inp"))
          expect_that( titl[1], equals("EPANET Example Network 1"))
})


test_that("[STATUS]  reads ok" ,{
			
	stat <- STATUS( readLines("Net3.inp"))
	expect_that( stat[1,1], equals('10') )
	expect_true( stat[1,2] =="Closed")
			
			
		})

test_that("[DEMANDS] reads ok",{
			
			dmd <- DEMANDS( readLines("oneprv.inp"))
			expect_that( dmd[1,2], equals(1.1) ) 
			expect_that( dim(dmd)[1], equals(3))  
			
		})

context("missing inp tables are null")
test_that("Net1 valves table is missing",
          {
            vlv <- VALVES(readLines("Net1.inp"))
            expect_that(vlv, equals(NULL))
          })

test_that("Net2.inp has no reservoirs",{
			
			resr <- RESERVOIRS(readLines("Net2.inp"))
			expect_that(resr, equals(NULL))
		})

test_that("Net2.inp has no pumps",{
			pmp <- PUMPS(readLines("Net2.inp"))
			expect_that(pmp, equals(NULL))
		})


test_that("TITLE is null",{
         t <- TITLE(readLines("empty.inp"))
         expect_that(t, equals(NULL))
        })

test_that("JUNCTIONS is null",{
         s <- JUNCTIONS(readLines("empty.inp"))
         expect_that(s, equals(NULL))
        })
test_that("TANKS is null",{
         s <- TANKS(readLines("empty.inp"))
         expect_that(s, equals(NULL))
        })

test_that("RESERVOIRS is null",{
         s <- RESERVOIRS(readLines("empty.inp"))
         expect_that(s, equals(NULL))
        })
test_that("PIPES is null",{
         s <- PIPES(readLines("empty.inp"))
         expect_that(s, equals(NULL))
        })

test_that("PUMPS is null",{
         s <- PUMPS(readLines("empty.inp"))
         expect_that(s, equals(NULL))
        })
test_that("VALVES is null",{
         s <- VALVES(readLines("empty.inp"))
         expect_that(s, equals(NULL))
        })

test_that("DEMANDS is null",{
			s <- DEMANDS(readLines("empty.inp"))
            expect_that(s, equals(NULL))
		})

test_that("PATTERNS is null",{
         s <- PATTERNS(readLines("empty.inp"))
         expect_that(s, equals(NULL))
        })

test_that("CURVES is null",{
         s <- CURVES(readLines("empty.inp"))
         expect_that(s, equals(NULL))
        })

test_that("ENERGY is null",{
         t <- ENERGY(readLines("empty.inp"))
         expect_that(t, equals(NULL))
        })

test_that("ENERGY is null",{
         t <- ENERGY(readLines("empty.inp"))
         expect_that(t, equals(NULL))
        })

test_that("TIMES is null",{
         t <- TIMES(readLines("empty.inp"))
         expect_that(t, equals(NULL))
        })

test_that("COORDINATES is null",{
         t <- COORDINATES(readLines("empty.inp"))
         expect_that(t, equals(NULL))
        })


context("IDs in inp sections are character")

test_that(" junction IDs are char",{
			
			junc <- JUNCTIONS(readLines("Net1.inp"))
		    expect_true( class(junc$ID) == "character")	
		})

context("some non-ID columns in inp sections are factors")
test_that("[Junctions] Pattern is factor",{
			
			junc <- JUNCTIONS(readLines("Net2.inp"))
			expect_true( class(junc$Pattern) == 'factor')
		})

test_that("[Tanks] Curve ID is factor",{
			
			tank <- TANKS(readLines("for-various-tests.inp"))
			expect_true( class(tank$VolCurve) == 'factor')
			
		})

test_that("[Reservoirs] Pattern is factor",{
			
			res <- RESERVOIRS(readLines("for-various-tests.inp"))
			expect_true( class(res$Pattern) == 'factor')
		})

test_that("[Pipes] status is factor",{
			
			pipe <- PIPES(readLines("Net3.inp"))
			expect_true(class(pipe$Status) == 'factor')
		})

test_that("[Pumps] keyword is factor",{
			
			pmp <- PUMPS(readLines("Net3.inp"))
			expect_true(class(pmp$Parameters) == 'factor')
		})

test_that("[Valves] type is factor",{
			
			vlv <- VALVES(readLines("oneprv.inp"))
			expect_true(class(vlv$Type) == 'factor')
		})

test_that("[Status] Status is factor",{
			
			stat <- STATUS(readLines("Net3.inp"))
			expect_true(class(stat$Status) == 'factor')
		})

test_that("[Demands] Pattern is factor",{
		
			dmd <- DEMANDS(readLines("oneprv.inp"))
			expect_true(class(dmd$Pattern) == 'factor')
			
		})
