help :
	@printf "Available commands:\n\tdiff\n\tdiffexact\n\tinstall\n\tinstallmacos\n"

diff :
	for FILE in $$(ls *sh); do diff -q $${FILE} ~/scripts/$${FILE}; done ;\

diffexact :
	for FILE in $$(ls *sh); do diff $${FILE} ~/scripts/$${FILE}; done ;\

install :
	cp -u *sh *tmpl ~/scripts/

installmacos :
	install *sh ~/scripts/
