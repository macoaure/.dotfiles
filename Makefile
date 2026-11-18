.PHONY: test install link

test:
	docker build -t dotfiles-test .
	docker run --rm dotfiles-test

install:
	bash install.sh

link:
	@for pkg in packages/*/; do \
		pkg_name=$${pkg%/}; pkg_name=$${pkg_name#packages/}; \
		stow --dir=packages --target=$$HOME $$pkg_name && echo "stowed $$pkg_name"; \
	done
