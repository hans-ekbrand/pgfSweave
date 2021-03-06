.onLoad <- function(lib, pkg) {
        pkgList <- c("filehash", "stashR", "cacheSweave", "tikzDevice")
        
        for(pkg in pkgList) {
                status <- suppressMessages({
                        require(pkg, quietly = TRUE, character.only = TRUE)
                })
                if(!status)
                        stop(gettextf("'%s' package required", pkg))
        }
		
	checkPGFVersion2orDie()	
}

.onAttach <- function(lib, pkg) {
        if(!require(utils))
                stop("'utils' package required to use 'Sweave'")
}

checkPGFVersion2orDie <- function(){
	
	texDir <- tempdir()
	cwd <- getwd()
	texFile <- 'test-for-pgf.tex'
	logFile <- 'test-for-pgf.log'
	
	dummy <- file.copy(
		system.file('misc',texFile,package='pgfSweave'),
		file.path(texDir,texFile))
	
	setwd(texDir)
	
	  # requires tikzDevice to be loaded
	latexCmd <- getOption('tikzLatex')

	# Append the batchmode flag to increase LaTeX 
	# efficiency.
	latexCmd <- paste( latexCmd, '-interaction=batchmode',
		'-output-directory', texDir, texFile)

	# Run that
	silence <- system( latexCmd, intern=T, ignore.stderr=T)
	
	logContents <- readLines( logFile )

	# Recover width by finding the line containing
	# tikzTeXWidth in the logfile.
	match <- logContents[ grep('PGFVersion=', logContents) ]

	# if pgf is not available, compilation will stop before printing anything 
	# out and there will be no matches. 
	if( length(match) == 0 ) stop("PGF >= 2.00 is required to use pgfSweave")

	# Remove all parts of the string besides the
	# number.
	version <- gsub('[=A-Za-z-]','',match)
	
	match <- strsplit(match,'=')[[1]][2]
	
	setwd(cwd)
	
	if(compareVersion(version,"2.00") < 0)
		stop(paste('PGF >= 2.00 is required to use pgfSweave, you are using version',match))
	else
		packageStartupMessage(paste('pgfSweave: Using PGF Version',match))
	
}