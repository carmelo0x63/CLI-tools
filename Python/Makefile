help :
	@echo "Available commands:\n\tdiff\n\tdiffexact\n\tinstall\n"

diff :
	for FILE in $$(ls *py); do diff -q $${FILE} ~/scripts/$${FILE}; done ;\

diffexact :
	for FILE in $$(ls *py); do diff $${FILE} ~/scripts/$${FILE}; done ;\

install :
	install *py ~/scripts/
