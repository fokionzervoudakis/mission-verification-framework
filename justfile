# Install dependencies
[group('setup')]
install:
    @brew install swi-prolog
    @bundle install

# Validate mission plans
[group('run')]
validate:
    @cd mission-executive/operations/; \
        find . -name 'operation_*' -exec kwalify -lf schema.yaml {} \;

# Execute individual mission plans
[group('run')]
execute:
    @cd mission-executive/; ./mission.rb


# Generate PRISM DTMC/PCTL code from templates
[group('run')]
generate:
    @cd mission-executive/; \
        ./asset_template.rb; \
        ./survivability_template.rb; \
        ./property_template.rb

# Use SWI-Prolog to classify UAV mission elements
[group('run')]
classify:
    @cd prolog-kb/; \
        find . -name 'operation_*' | sort | xargs -I {} swipl -q -s {} -t halt

# Execute the parser
[group('run')]
parse:
    @cd parser/; ./parser.rb

# Lint Ruby code with RuboCop
[group('lint')]
lint:
    @bundle exec rubocop
