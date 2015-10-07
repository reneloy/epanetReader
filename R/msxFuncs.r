#************************************
#
#  (C) Copyright IBM Corp. 2015
#
#  Author: Bradley J Eck
#
#************************************



msxSection2df <- function( sect ){
 # make a section into it's own data frame

  imax <- length(sect)
  
   # Take column headings from labels. 
   headerRow1 <- unlist(strsplit( gsub("^\\s+", "", sect[3] ), "\\s+"))
   columnNames <-  headerRow1

   
  # set colClasses, everything is numeric execpt fist 
	# and last column
	lcn <- length( columnNames)
  cc <- rep("numeric", lcn )
  cc[1] <- "character"  # for ID column 
  
   
  # make the section a data frame 
  df <- utils::read.table( text = sect[6:imax], 
		  col.names=columnNames,
		  colClasses = cc, 
		  strip.white = TRUE, fill = TRUE, header = FALSE )
  
  
  # convert that stamp into sections 
  time_secs <-  sapply(df$Time, .timeStampToSeconds )
  
  df$timeInSeconds <- time_secs
  
   # Make a new first column "ID" rather than
   # "Node" or "Link"  to be consistent with inp objects
   df$ID <- getID(sect[1])

	return( df ) 
}

# get the element ID from the
# marker  <<< Node/Link ID >>> 
# that starts the msx results tables 
getID <-function( marker ){

    # gradually take out the unwanted parts
	m1 <- gsub("<<<", "", marker)
	m2 <- gsub(">>>", "", m1 )
	m3 <- gsub("Node", "", m2 )
	m4 <- gsub("Link", "", m3 )
	ID <- gsub("\\s", "", m4)
	
	return(ID)
}