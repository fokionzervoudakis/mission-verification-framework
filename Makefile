alL: validate execute generate classify parse

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

.PHONY: all install validate execute generate classify parse
