HUGO ?= hugo
PROD_BASE_URL ?= https://fonzi.xyz
PROD_DIR ?= .dist-prod

.PHONY: prod-build prod-serve prod-preview clean-dist

prod-build:
	$(HUGO) --environment production --baseURL $(PROD_BASE_URL) --minify --cleanDestinationDir --destination $(PROD_DIR)

prod-serve:
	python3 -m http.server 4173 --directory $(PROD_DIR)

prod-preview: prod-build prod-serve

clean-dist:
	rm -rf $(PROD_DIR)
