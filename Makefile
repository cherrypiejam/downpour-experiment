all:
	cd data/seed && make all
	./../downpour torrent create -f data/seed/test.img -t "http://10.10.1.1:6969/announce" -o torrent/test.torrent
	tar -czvf experiment.tar.gz config script torrent binary data Makefile terminate.sh

clean:
	-@rm data/1/test.img*
	-@rm data/2/test.img*
	-@rm data/3/test.img*
	-@rm data/4/test.img*
	-@rm data/5/test.img*

