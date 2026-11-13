BOLD := `printf "\033[1m"`
RED := `printf "\033[31m"`
RESET := `printf "\033[0m"`

default:
    @just --list

# Install dependencies
[group('setup')]
install:
    @brew install ruby
    @brew install swi-prolog
    @bundle install

# Update dependencies
[group('setup')]
update:
    @echo "{{RED}}{{BOLD}}Updating dependencies...{{RESET}}"
    @bundle update

# Generate PRISM DTMC/PCTL code from templates
[group('dev')]
generate:
    @echo "{{RED}}{{BOLD}}Generating PRISM code from templates...{{RESET}}"
    @cd mission-executive/ && \
        ./asset_template.rb && \
        ./survivability_template.rb && \
        ./property_template.rb

# Run tests
[group('dev')]
test:
    @echo "{{RED}}{{BOLD}}Running tests...{{RESET}}"
    @cd mission-executive/ && ruby -e 'Dir["./test/*_test.rb"].each { |file| require file }'

# Lint sources
[group('dev')]
lint:
    @echo "{{RED}}{{BOLD}}Linting sources...{{RESET}}"
    @bundle exec rubocop

# Run all tasks
[group('dev')]
run: validate execute generate classify parse

# Validate mission plans
[group('dev')]
validate:
    @echo "{{RED}}{{BOLD}}Validating mission plans...{{RESET}}"
    @cd mission-executive/operations/ && bundle exec kwalify -lf schema.yaml operation_*

# Execute individual mission plans
[group('dev')]
execute:
    @echo "{{RED}}{{BOLD}}Executing mission plans...{{RESET}}"
    @cd mission-executive/ && ./mission.rb

# Use SWI-Prolog to classify UAV mission elements
[group('dev')]
classify:
    @echo "{{RED}}{{BOLD}}Classifying mission elements...{{RESET}}"
    @cd prolog-kb/ && \
        find . -name 'operation_*' | sort | xargs -I {} swipl --on-error=status -q -s {} -t halt

# Execute the parser
[group('dev')]
parse:
    @echo "{{RED}}{{BOLD}}Parsing plans and models...{{RESET}}"
    @cd parser/ && ./parser.rb && ./metrics.rb
