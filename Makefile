default:
	@echo "make install"
	@echo "make validate"
	@echo "make execute"
	@echo "make generate"
	@echo "make classify"
	@echo "make parse"
	@echo "make lint"

# Install dependencies
install:
	brew install swi-prolog
	bundle install
	bundle exec yard gems

validate:
	cd mission-executive/operations/; \
		find . -name 'operation_*' -exec kwalify -lf schema.yaml {} \;

execute:
	cd mission-executive/; ./mission.rb

generate:
	cd mission-executive/; \
		./asset_template.rb; \
		./survivability_template.rb; \
		./property_template.rb

classify:
	cd prolog-kb/; \
		find . -name 'operation_*' -exec swipl -q -s {} -t halt \;

parse:
	cd parser/; ./parser.rb

lint:
	bundle exec rubocop

.PHONY: default install validate execute generate classify parse lint
.SILENT: default install validate execute generate classify parse lint
