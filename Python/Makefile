test :
	@echo "Test: OK!"

diff :
	for FILE in $$(ls *sh); do diff -q $${FILE} ~/scripts/$${FILE}; done ;\

diffexact :
	for FILE in $$(ls *sh); do diff $${FILE} ~/scripts/$${FILE}; done ;\

install :
	install *sh ~/scripts/
