.PHONY: all image publish n-doc n-doc-plantuml

all: publish

publish: images
	docker push ndesign/n-doc:latest
	docker push ndesign/n-doc:latest-plantuml

images: n-doc-plantuml

n-doc-plantuml: n-doc
	docker build $(CACHE_OPTION) -f Dockerfile.plantuml --progress plain --tag ndesign/n-doc:latest-plantuml .

n-doc:
	docker build $(CACHE_OPTION) --progress plain --build-arg ctanmirror --build-arg baseimage --tag ndesign/n-doc:latest .

