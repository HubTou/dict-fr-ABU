URL=http://abu.cnam.fr/cgi-bin

MOTS_COMMUNS=donner-dico-uncompress?liste_
PRENOMS=donner_unformated?DICO/prenoms
CITES=donner_unformated?DICO/cites
PAYS=donner_unformated?DICO/pays
DIFFICULTES=donner_unformated?DICO/dicorth

# Default action is to show this help message:
.help:
	@echo "Possible targets:"
	@echo "  package        Build package"
	@echo "  upload-test    Upload the package to TestPyPi"
	@echo "  upload         Upload the package to PyPi"
	@echo "  clean          Remove all downloaded files"
	@echo "  distclean      Remove all generated files as well"

dict-fr-ABU-mots_communs:
	( cd data ; for LETTER in a b c d e f g h i j k l m n o p q r s t u v w x y z ; do fetch -q ${URL}/${MOTS_COMMUNS}$${LETTER} -o $${LETTER} ; done )
	( cd data ; for LETTER in a b c d e f g h i j k l m n o p q r s t u v w x y z ; do awk 'BEGIN {FOUND=0} /FIN DE LA LICENCE ABU/ {FOUND=1} FOUND==1 {print}' $${LETTER} ; done | grep -v -- "-----" | grep -v "^ *$$" | grep -v "^	" | iconv -f ISO-8859-1 -t UTF-8 | sort > dict-fr-ABU-mots_communs )
	( cd data ; sed "s/	.*//" dict-fr-ABU-mots_communs | uniq | tee dict-fr-ABU-mots_communs.unicode | unicode2ascii | sort | uniq > dict-fr-ABU-mots_communs.ascii )
	( cd data ; cat dict-fr-ABU-mots_communs.unicode dict-fr-ABU-mots_communs.ascii | sort | uniq > dict-fr-ABU-mots_communs.combined )

dict-fr-ABU-prenoms:
	( cd data ; fetch -q ${URL}/${PRENOMS} -o prenoms )
	( cd data ; awk 'BEGIN {FOUND=0} /DEBUT DU FICHIER DICO\/prenoms/ {FOUND=1} FOUND==1 {print}' prenoms | grep -v -- "-----" | grep -v "^ *$$" | iconv -f ISO-8859-1 -t UTF-8 | sort > dict-fr-ABU-prenoms )
	( cd data ; cat dict-fr-ABU-prenoms | uniq | tee dict-fr-ABU-prenoms.unicode | unicode2ascii | sort | uniq > dict-fr-ABU-prenoms.ascii )
	( cd data ; cat dict-fr-ABU-prenoms.unicode dict-fr-ABU-prenoms.ascii | sort | uniq > dict-fr-ABU-prenoms.combined )

dict-fr-ABU-cites:
	( cd data ; fetch -q ${URL}/${CITES} -o cites )
	( cd data ; awk 'BEGIN {FOUND=0} /DEBUT DU FICHIER DICO\/cites/ {FOUND=1} FOUND==1 {print}' cites | grep -v -- "-----" | grep -v "^ *$$" | iconv -f ISO-8859-1 -t UTF-8 | sort > dict-fr-ABU-cites )
	( cd data ; sed "s/	.*//" dict-fr-ABU-cites | uniq | tee dict-fr-ABU-cites.unicode | unicode2ascii | sort | uniq > dict-fr-ABU-cites.ascii )
	( cd data ; cat dict-fr-ABU-cites.unicode dict-fr-ABU-cites.ascii | sort | uniq > dict-fr-ABU-cites.combined )

dict-fr-ABU-pays:
	( cd data ; fetch -q ${URL}/${PAYS} -o pays )
	( cd data ; awk 'BEGIN {FOUND=0} /DEBUT DU FICHIER DICO\/pays/ {FOUND=1} FOUND==1 {print}' pays | grep -v -- "-----" | grep -v "^ *$$" | iconv -f ISO-8859-1 -t UTF-8 | sort > dict-fr-ABU-pays )
	( cd data ; cat dict-fr-ABU-pays | uniq | tee dict-fr-ABU-pays.unicode | unicode2ascii | sort | uniq > dict-fr-ABU-pays.ascii )
	( cd data ; cat dict-fr-ABU-pays.unicode dict-fr-ABU-pays.ascii | sort | uniq > dict-fr-ABU-pays.combined )

dict-fr-ABU-dicorth:
	( cd data ; fetch -q ${URL}/${DIFFICULTES} -o dicorth )
	( cd data ; awk 'BEGIN {FOUND=0} /DEBUT DU FICHIER DICO\/dicorth/ {FOUND=1} FOUND==1 {print}' dicorth | grep -v -- "-----" | grep -v "^ *$$" | iconv -f ISO-8859-1 -t UTF-8 > dict-fr-ABU-dicorth )

love:
	@echo "Not war!"

dict-fr-ABU: dict-fr-ABU-mots_communs dict-fr-ABU-prenoms dict-fr-ABU-cites dict-fr-ABU-pays dict-fr-ABU-dicorth

package: dict-fr-ABU clean
	python -m build

upload-test:
	python -m twine upload --repository testpypi dist/*

upload:
	python -m twine upload dist/*

clean:
	@( cd data ; rm -f [a-z] prenoms cites pays dicorth )

distclean: clean
	@( cd data ; rm -f dict-fr-ABU-mots_communs dict-fr-ABU-prenoms dict-fr-ABU-cites dict-fr-ABU-pays dict-fr-ABU-dicorth )
	@( cd data ; rm -f dict-fr-ABU-mots_communs.unicode dict-fr-ABU-prenoms.unicode dict-fr-ABU-cites.unicode dict-fr-ABU-pays.unicode )
	@( cd data ; rm -f dict-fr-ABU-mots_communs.ascii dict-fr-ABU-prenoms.ascii dict-fr-ABU-cites.ascii dict-fr-ABU-pays.ascii )
	@( cd data ; rm -f dict-fr-ABU-mots_communs.combined dict-fr-ABU-prenoms.combined dict-fr-ABU-cites.combined dict-fr-ABU-pays.combined )
	@rm -rf build dist *.egg-info

