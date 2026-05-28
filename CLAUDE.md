# CLAUDE.md

Guidance for working in this repository.

## Testing

- One `expect` per test. Each example asserts a single behavior; when you need several assertions, split them into separate `it` blocks.
- When a test fits on a single line, its description adds nothing — omit it and use the one-liner form. For example, prefer:

  ```ruby
  it { expect(described_class.verify_and_save(encode(solution_params))).to be_truthy }
  ```

  over:

  ```ruby
  it "returns a truthy value for a valid submission" do
    expect(described_class.verify_and_save(encode(solution_params))).to be_truthy
  end
  ```
- For each `describe` that targets a method under test, declare a named `subject` for that method. For example, prefer:

  ```ruby
  describe ".verify_and_save" do
    subject(:verify_and_save) { described_class.verify_and_save(encoded) }

    it { expect(verify_and_save).to be_truthy }
  end
  ```

  over:

  ```ruby
  describe ".verify_and_save" do
    it { expect(described_class.verify_and_save(encoded)).to be_truthy }
  end
  ```
- When a spec needs helper methods, declare them at the bottom of the file, in a `private` section. For example, prefer:

  ```ruby
  RSpec.describe DailySummary do
    subject(:summary) { described_class.new }

    it { expect(summary_kinds).to be_empty }

    private

    def summary_kinds
      summary.concerned_administrators.flat_map(&:kind)
    end
  end
  ```

  over defining the helper near the top of the example group.
