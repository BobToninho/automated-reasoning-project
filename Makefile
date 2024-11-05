report.pdf: report.tex
	latexmk -pdf report.tex
	# pdflatex report.tex
	# biber report
	# pdflatex report.tex
