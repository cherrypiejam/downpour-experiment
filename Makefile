all:
	cd data/seed_0 && make all
	cp data/seed_0/test.img data/seed_1/test.img
	cp data/seed_0/test.img data/seed_2/test.img
	./../downpour torrent create -f data/seed_0/test.img -t "http://10.10.1.1:6969/announce" -o torrent/test.torrent
	tar -czvf experiment.tar.gz config script torrent binary data Makefile terminate.sh

clean:
	-@rm data/0/test.img*
	-@rm data/1/test.img*
	-@rm data/2/test.img*
	-@rm data/3/test.img*
	-@rm data/4/test.img*

