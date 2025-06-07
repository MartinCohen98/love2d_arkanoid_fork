NAME=arkanoid

all: love

love:
	zip -r dist/${NAME}.love *.lua \
		fonts img levels sounds \
		credits.txt Makefile \
		../LICENSE ../README.md
	cat dist/love.exe dist/${NAME}.love > dist/${NAME}.exe

clean:
	rm -f *.love
