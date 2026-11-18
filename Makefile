.PHONY: test dev shell install link

test:
	docker build --target test -t dotfiles-test .
	docker run --rm dotfiles-test

dev:
	docker build --target dev -t dotfiles-dev .

shell: dev
	docker run -it dotfiles-dev

install:
	bash install.sh

link:
	@for pkg in packages/*/; do \
		pkg_name=$${pkg%/}; pkg_name=$${pkg_name#packages/}; \
		stow --dir=packages --target=$$HOME $$pkg_name && echo "stowed $$pkg_name"; \
	done
