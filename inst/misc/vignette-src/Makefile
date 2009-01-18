	#Must already have a version of pgfSweave installed to compile this.
	#This is a workaround for using pgfSweave to compile the vignette
	#in the CRAN version without requiring pgfSweave already.
	#
	#The idea is that before submitting, the developer compiles the source
	#of the vignette with the version of pgfSweave they have been working on 
	#by running this make file.  Then copy the tex file output to inst/doc
	#as an Rnw file (with no code chunks) so that it registers as an official 
	#vignette.  
	#
	#Requires a little finagling to change the path to the example files and 
	#get rid of the \pgfrealjobname line

rmpath={*,../../doc/*}
rmsuffix={sh,map,aux,tex,log,pdf,dvi}

../../doc/pgfSweave-vignette.pdf: ../../doc/pgfSweave-vignette.Rnw
	(cd ../../doc/ ; R CMD Sweave pgfSweave-vignette.Rnw ; pdflatex pgfSweave-vignette.tex)

../../doc/pgfSweave-vignette.Rnw: ../../example/pgfSweave-example.tex pgfSweave-vignette-source.pdf
	cp Sweave.sty ../../doc/
	cp figs/*.pdf ../../doc/figs/
	cp -f ../../example/pgfSweave-example.Rnw ../../doc/pgfSweave-example-Rnw.in
	cp -f ../../example/pgfSweave-example.tex ../../doc/pgfSweave-example-tex.in
	cat pgfSweave-vignette-source.tex | grep -v "\\pgfrealjobname{pgfSweave-vignette-source}" | sed 's/\.\.\/\.\.\/example\///g' > tmp
	cat tmp | sed 's/pgfSweave-example\.Rnw/pgfSweave-example-Rnw.in/g' | sed 's/pgfSweave-example\.tex/pgfSweave-example-tex\.in/g' > ../../doc/pgfSweave-vignette.Rnw

pgfSweave-vignette-source.pdf:
	../../../exec/pgfSweave pgfSweave-vignette-source.Rnw

../../example/pgfSweave-example.tex:
	(cd ../../example/ ; make)

clean:
	rm -rf cache figs/* Rplots.* $(rmpath).$(rmsuffix) ../../doc/Sweave.sty ../../doc/*.Rnw ../../doc/figs/* tmp
	(cd ../../example/ ; make clean)

cleanforbuild:
	rm -rf cache figs/* Rplots.* $(rmpath).{log,aux,dvi,sh,map} ./pgfSweave-vignette-source.tex ../../doc/pgfSweave-vignette.tex tmp
	(cd ../../example/ ; make cleanforbuild)