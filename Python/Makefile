test :
	@echo "Test: OK!"

diff :
	for FILE in $$(ls *py); do diff -q $${FILE} ~/scripts/$${FILE}; done ;\

diffexact :
	for FILE in $$(ls *py); do diff $${FILE} ~/scripts/$${FILE}; done ;\

install :
	install *py ~/scripts/
