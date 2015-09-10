#************************************
#
#  (C) Copyright IBM Corp. 2015
#
#  Author: Bradley J Eck
#
#************************************

# File:  test_rptFuncs.r
#



source("../R/rptFuncs.r")

context("test helper functions used with rpt ")

test_that("testing binBreaker",{
		  vals1 <- c(-1,0,1,2,3,4,5)
		  v1bb <- binBreaker(vals1, 4)
		  expect_true( v1bb$Breaks[1] < min(vals1), "first break point is less than min value")
		  
		  expect_equal( (substr(v1bb$Labels[1], 2,3)),  as.character(min(vals1)), "lower range of first bin is sample min")
		  
		  expect_equal( ( substr( v1bb$Labels[4], 6,6)) ,
		                as.character(max(vals1)), 
						"upper end of last bin is sample max")
		
		  vals2 <- c(0,1.1, 2.2, 3.3, NA, 2, 3, 4, 5, 6.6)
		 expect_true ( class(binBreaker(vals2, 3)) == "list", "function returns even with NA inpus ") 
		  
		})


test_that("two line heading for ID works",{
          
          #some sample input
aFewLines <- c(          
"Node Results at 0:00 Hrs: ",
"  ---------------------------------------------------------------------- ",
"  Node                Demand      Head  Pressure   Quality               ",
"  ID                     GPM        ft       psi      mg/L               ",
"  ---------------------------------------------------------------------- ",
"  10                    0.00   1004.35    127.54      0.50               ",
"  11                  150.00    985.23    119.26      0.50               ",
"  12                  150.00    970.07    117.02      0.50               ",
"  13                  100.00    968.87    118.67      0.50               ",
"  21                  150.00    971.55    117.66      0.50               ",
"  22                  200.00    969.08    118.76      0.50               " )

df <- .section2df(aFewLines)

expect_equal( names(df)[1], expected = "ID") 
expect_equal( names(df)[5], expected = "Quality") 

        })


test_that("one line heading for ID works",{

          #some sample input
aFewLines <- c(          
"Node Results at 0:00:00 hrs:  ",
"  -------------------------------------------------------- ",
"                     Demand      Head  Pressure  Chlorine  ",
"  Node                  gpm        ft       psi      mg/L  ",
"  -------------------------------------------------------- ",
"  10                    0.00   1004.35    127.54      0.50               ",
"  11                  150.00    985.23    119.26      0.50               ",
"  12                  150.00    970.07    117.02      0.50               ",
"  13                  100.00    968.87    118.67      0.50               ",
"  21                  150.00    971.55    117.66      0.50               ",
"  22                  200.00    969.08    118.76      0.50               " )

df <- .section2df(aFewLines)

expect_equal( names(df)[1], expected = "ID") 
expect_equal( names(df)[5], expected = "Chlorine") 

        })


test_that("IDs are characters",{
		
			## Manually input due to complexity of reading and breaking into sections
			aFewLines <- c(          
					"Node Results at 0:00:00 hrs:  ",
					"  -------------------------------------------------------- ",
					"                     Demand      Head  Pressure  Chlorine  ",
					"  Node                  gpm        ft       psi      mg/L  ",
					"  -------------------------------------------------------- ",
					"  10                    0.00   1004.35    127.54      0.50               ",
					"  11                  150.00    985.23    119.26      0.50               ",
					"  12                  150.00    970.07    117.02      0.50               ",
					"  13                  100.00    968.87    118.67      0.50               ",
					"  21                  150.00    971.55    117.66      0.50               ",
					"  22                  200.00    969.08    118.76      0.50               " )
			
			df <- .section2df(aFewLines)
			
			expect_true(class(df$ID) == "character")
		})