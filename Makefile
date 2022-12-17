all:
	cd data/seed_0 && make all
	cp data/seed_0/test.img data/seed_1/test.img
	cp data/seed_0/test.img data/seed_2/test.img
	./../downpour torrent create -f data/seed_0/test.img -t "http://10.10.1.1:6969/announce" -o torrent/test.torrent
	tar -czvf experiment.tar.gz config script torrent binary data Makefile terminate.sh

.PHONY: clean
clean:
	-@rm $(wildcard data/[^seed_*]*/test.img*)

