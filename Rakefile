require 'rake'
require 'rake/testtask'

LOGO = 
'#    ___                   ____ _____    ',
'#   / _ \ _ __   ___ _ __ / ___|___ /    ',
'#  | | | | \'_ \ / _ \ \'_ \  ___ \ |_ \ ',
'#  | |_| | |_) |  __/ | | |___) |__) |   ',
'#   \___/| .__/ \___|_| |_|____/____/    ',
'#        |_|                             '

TEST_INFO = <<TEST_INFO
#
#  This test suite is running limited. To enable the full test suite, please set
#  OPENS3_TESTDIR to the location of a safe, writable directory.
#
TEST_INFO

FILE_WRITE_WARNING = <<FILE_WRITE_WARNING
#
#                 !!! WARNING !!!
#
# This test suite will be writing data to:
# #{ENV['OPENS3_TESTDIR']}
#
FILE_WRITE_WARNING

BAD_DIR_WARNING = <<BAD_DIR_WARNING
# #{ENV['OPENS3_TESTDIR']} 
# is not a directory, or writable and will be not be used, 
# testing will now run limited.
#
BAD_DIR_WARNING

Rake::TestTask.new do |t|
  puts LOGO
  if ENV['OPENS3_TESTDIR']

    if File.Directory?(ENV['OPENS3_TESTDIR'])
      puts FILE_WRITE_WARNING
    else
      puts BAD_DIR_WARNING
      ENV.delete('OPENS3_TESTDIR')
    end

  else
    puts TEST_INFO
  end
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end
