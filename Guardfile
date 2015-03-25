clearing :on
notification :terminal_notifier if defined?(TerminalNotifier)

guard :minitest, {
  all_on_start: true,
  autorun: false,
  include: ['lib', 'test'],
  test_folders: ['test'],
  test_file_patterns: ["*_test.rb"]
} do
  if ENV['TEST_FILES']
    ENV['TEST_FILES'].split(',').map(&:strip).each do |file|
      watch(%r{.*}) { file }
    end
  else
    watch(%r{.*}) { 'test' }
  end
end
