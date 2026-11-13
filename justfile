default:
    @just --list

# Install dependencies
[group('setup')]
install:
    @brew install ruby
    @brew install swi-prolog
    @bundle install

# Run all tasks
[group('dev')]
run: validate execute generate classify parse

# Validate mission plans
[group('dev')]
validate:
    @cd mission-executive/operations/ && \
        find . -name 'operation_*' -exec bundle exec kwalify -lf schema.yaml {} +

# Execute individual mission plans
[group('dev')]
execute:
    @cd mission-executive/ && ./mission.rb

# Test the mission executive
[group('dev')]
test:
    @cd mission-executive/ && ruby test/mission_test.rb

# Generate PRISM DTMC/PCTL code from templates
[group('dev')]
generate:
    @cd mission-executive/ && \
        ./asset_template.rb && \
        ./survivability_template.rb && \
        ./property_template.rb

# Use SWI-Prolog to classify UAV mission elements
[group('dev')]
classify:
    @cd prolog-kb/ && \
        find . -name 'operation_*' | sort | xargs -I {} swipl -q -s {} -t halt

# Execute the parser
[group('dev')]
parse:
    @cd parser/ && ./parser.rb
