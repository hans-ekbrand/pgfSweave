\name{pgfSweave}
\alias{pgfSweave}
\alias{pgfSweave-package}

\title{Quality speedy graphics compilation with Sweave}

\description{
The pgfSweave package provides capabilities for 'caching' graphics generated with Sweave.  Using pgfSweave, figure labels are converted to LaTeX strings so not only do they match the style of the document but math can be put in labels. pgfSweave provides a new driver for Sweave (pgfSweaveDriver) and new chunk options tikz, pgf, external and sanitize on top of the cache option provided by cacheSweave. This package is built upon cacheSweave and therefore also Sweave.
}

\usage{
pgfSweave(file, compile.tex = TRUE, syntax = getOption("SweaveSyntax"), ...)
}

\arguments{ 
    \item{file}{A connection or a character string giving the name of the file to load.} 
    \item{compile.tex}{If \code{TRUE} run \code{LaTeX}/\code{pdfLaTeX} on the resulting tex file. If \code{FALSE} only run \code{Sweave}.}
    \item{syntax}{An object of class SweaveSyntax or a character string with its name. The default installation provides SweaveSyntaxNoweb and SweaveSyntaxLatex (passed to Sweave).}
    \item{\dots}{Other options to be passed to \code{\link{texi2dvi}}} 
}

\details{
This package provides new features beyond \code{\link[cacheSweave]{cacheSweave}}:  
	\enumerate{
		\item better recognition of code chunk changes 
		\item the 'caching' of code chunks which generate graphics and 
		\item an interface to the tikzDevice package and the eps2pgf utility for the generation of graphics in which the font matches that of the main document.
}

The process carried out by \code{pgfSweave} involves:
\itemize{
	\item Running \code{Sweave} on the .Rnw file using \code{pgfSweaveDriver} function.
	\item Generating a graphics file from each newly created or changed graphic.  
	\item Running the pgf externalization commands for each newly generated graphic.
	\item Finally running \code{LaTeX} with on the .tex file using the real job name.
}

For more details see the \pkg{pgfSweave} package vignette.
}

\value{
A pdf file is generated if \code{compile.tex=TRUE} and a tex file only is generated otherwise. 
}

\references{
Sweave manual: \url{http://www.statistik.lmu.de/~leisch/Sweave/Sweave-manual.pdf}  

cacheSweave vignette: \url{http://cran.r-project.org/web/packages/cacheSweave/vignettes/cacheSweave.pdf}

pgf manual externalization section: \url{http://sourceforge.net/projects/pgf/}
}


\note{ 
	\itemize{
		\item The pgfSweave package must be installed from source to gain access to the R CMD pgfsweave interface. 
		\item Assuming \code{compile.tex=TRUE} the function will issue any system commands needed to ``externalize'' the pgf graphics.  To take advantage of the speedup, set \code{external=TRUE} on every code chunk that creates a plot.  
		\item the command \\\code{pgfrealjobname{myfile}} MUST in the header of your \code{LaTeX} file for the external graphics capablities.
}
}

\section{Known issues}{
	\enumerate{
		\item Sometimes caching is overzealous and caches and figures need to be manually removed.  
		\item changing the width and height of a figure only does not register as a change
		\item A stray Rplots.pdf gets generated when using caching.
	}
}
\author{Cameron Bracken \email{cameron.bracken@gmail.com} and Charlie Sharpsteen }

\seealso{
\code{\link[pgfSweave]{pgfSweaveDriver}}, 
\code{\link{Sweave}}, 
\code{\link[tikzDevice]{tikzDevice}}
\code{\link[cacheSweave]{cacheSweave}}
}

\examples{
\dontrun{vignette("pgfSweave")}

\dontrun{
library(pgfSweave)
oldcwd <- getwd()
dir <- tempdir()
setwd(dir)
file.copy(system.file("example","pgfSweave-example.Rnw", package = "pgfSweave"),dir)
file <- file.path(dir,"pgfSweave-example.Rnw")
pgfSweave(file,compile.tex=FALSE)
setwd(oldcwd)
}

\dontrun{
## Normally to compile to PDF by  
#    pgfSweave("pgfSweave-example.Rnw",pdf=T) 
# Here we need the pdf=T argument because it is passed to texi2dvi
#
# or use
#
# R CMD pgfsweave pgfSweave-example.Rnw
## From the command line which calls texi2dvi (default uses pdflatex)
#
#ifdef unix
## NOTE: LaTeX may not be included in your path by default when using the R
## GUI, please see the FAQ in the pgfSweave vignette if your latex or pdflatex ## are not found.
#endif
#ifdef windows
## WINDOWS USERS: This has only been tested with MiKTeX
#endif
}

## Use pgfSweave outside of R with the script provided in the pgfSweave exec/ directory
}
\keyword{utilities}
\concept{Reproducible research}
\concept{Tangle and Weave}
\concept{Literate programming}
