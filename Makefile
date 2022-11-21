NAME = aesoper/ubuntu-s6-overlay
VERSION = 1.0.1

.PHONY: build build-nocache test tag-latest push push-latest release git-tag-version

build:
	docker build -t $(NAME):$(VERSION) --rm  -f ./Dockerfile .

build-nocache:
	docker build -t $(NAME):$(VERSION) --no-cache --rm  -f ./Dockerfile .

test:
	env NAME=$(NAME) VERSION=$(VERSION) bats test/test.bats

tag:
	docker tag $(NAME):$(VERSION) $(NAME):$(VERSION)

tag-latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

push:
	docker push $(NAME):$(VERSION)

push-latest:
	docker push $(NAME):latest

release: build test tag-latest push push-latest

git-tag-version:
	git tag -a v$(VERSION) -m "v$(VERSION)"
	git push origin v$(VERSION)
